import os
import sys
import argparse
import time
from pathlib import Path
from datetime import datetime
import subprocess
from sqlalchemy import text
from dotenv import load_dotenv

from src.utils.db import dw_engine
from src.utils.log import setup_logger
from src.extract.erp_extract import erp_engine, list_sql_files, run_query
from src.load.load_utils import replace_table, add_tech_columns
from src.manual.ingest_fmanual import ingest_fmanual

load_dotenv()
logger = setup_logger()

def ensure_dirs():
    Path("C:/DW/dw_projeto/logs").mkdir(parents=True, exist_ok=True)
    Path("C:/DW/dw_projeto/ops").mkdir(parents=True, exist_ok=True)

def lock_path():
    return Path("C:/DW/dw_projeto/ops/dw.lock")

def acquire_lock_or_exit():
    lp = lock_path()
    if lp.exists():
        # Se já existe, assume que tem outra execução rodando
        raise RuntimeError(f"Já existe lock ({lp}). Provável execução em andamento. Abortando para evitar duplicidade.")
    lp.write_text(f"locked_at={datetime.utcnow().isoformat()}", encoding="utf-8")

def release_lock():
    lp = lock_path()
    if lp.exists():
        lp.unlink()

def log_file_for_batch(b):
    return Path(f"C:/DW/dw_projeto/logs/dw_{b}.log")

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--only-sql",
        default=None,
        help="Roda apenas um arquivo SQL específico. Ex: dClientes_Clientes.sql",
    )
    parser.add_argument(
        "--only-prefix",
        default=None,
        help="Roda apenas arquivos SQL que começam com um prefixo. Ex: dClientes_",
    )
    parser.add_argument(
        "--skip-manual",
        action="store_true",
        help="Pula a importação do fManual (Excel). Útil para testes rápidos.",
    )
    parser.add_argument(
        "--skip-dbt",
        action="store_true",
        help="Pula o dbt run. Útil quando você quer só atualizar RAW.",
    )
    return parser.parse_args()


def batch_id():
    return datetime.utcnow().strftime("%Y%m%d%H%M%S")


def open_run(engine, b):
    with engine.begin() as conn:
        r = conn.execute(
            text("insert into dw.etl_runs(batch_id, status) values (:b, 'RUNNING') returning run_id"),
            {"b": b},
        ).fetchone()
        return r[0]


def close_run(engine, run_id, status, message=""):
    with engine.begin() as conn:
        conn.execute(
            text("update dw.etl_runs set finished_at=now(), status=:s, message=:m where run_id=:id"),
            {"s": status, "m": message, "id": run_id},
        )


def run_dbt():
    project_dir = Path(__file__).resolve().parents[1]  # ...\dw_projeto
    dbt_exe = project_dir / ".venv" / "Scripts" / "dbt.exe"

    if dbt_exe.exists():
        cmd = [str(dbt_exe), "run"]
    else:
        cmd = [sys.executable, "-m", "dbt", "run"]

    profiles_dir = Path(r"C:\Users\dw.admin\.dbt")
    cmd += ["--profiles-dir", str(profiles_dir)]
    return subprocess.run(cmd, cwd=str(project_dir / "dbt"), capture_output=True, text=True)


def filter_sql_files(files, only_sql: str | None, only_prefix: str | None):
    """
    files: lista de Paths retornada por list_sql_files()
    only_sql: nome exato do arquivo (ex: dClientes_Clientes.sql)
    only_prefix: prefixo do arquivo (ex: dClientes_)
    """
    filtered = list(files)

    if only_sql and only_prefix:
        raise RuntimeError("Use apenas UM: --only-sql OU --only-prefix (não os dois ao mesmo tempo).")

    if only_sql:
        filtered = [f for f in filtered if f.name.lower() == only_sql.lower()]
        if not filtered:
            available = ", ".join(sorted([x.name for x in files]))
            raise RuntimeError(f"Não achei o arquivo: {only_sql}. Disponíveis: {available}")

    if only_prefix:
        filtered = [f for f in filtered if f.name.lower().startswith(only_prefix.lower())]
        if not filtered:
            prefixes = sorted(set([x.name.split('_')[0] for x in files if '_' in x.name]))
            raise RuntimeError(f"Nenhum .sql encontrado com prefixo: {only_prefix}. Prefixos comuns: {prefixes}")

    return filtered


def main():
    ensure_dirs()
    acquire_lock_or_exit()
    args = parse_args()
    b = batch_id()
    log_path = log_file_for_batch(b)
    logger.info(f"Log em arquivo: {log_path}")
    dw = dw_engine()
    run_id = open_run(dw, b)
    logger.info(f"Iniciando batch_id={b} run_id={run_id}")

    try:
        erp = erp_engine()

        files = list_sql_files()
        files = filter_sql_files(files, args.only_sql, args.only_prefix)

        logger.info(f"Total de queries para rodar: {len(files)}")

        for f in files:
            table = f.stem.lower()
            sql_text = f.read_text(encoding="utf-8")
            logger.info(f"Extraindo {f.name} -> raw.{table}")
            df = run_query(erp, sql_text)
            df = add_tech_columns(df, batch_id=b, source=f"ERP:{f.name}")
            replace_table(dw, "raw", table, df)
            logger.info(f"OK raw.{table} linhas={len(df)}")

        if not args.skip_manual:
            logger.info("Importando fManual (Excel) ...")
            ingest_fmanual(dw, batch_id=b)
        else:
            logger.info("Pulando fManual (Excel) (--skip-manual)")

        if not args.skip_dbt:
            logger.info("Rodando dbt run ...")
            r = run_dbt()
            if r.returncode != 0:
                logger.error(r.stdout)
                logger.error(r.stderr)
                raise RuntimeError("dbt run falhou")
        else:
            logger.info("Pulando dbt (--skip-dbt)")

        close_run(dw, run_id, "SUCCESS", "Pipeline OK")
        logger.info("Finalizado com sucesso")

    except Exception as e:
        close_run(dw, run_id, "FAILED", str(e))
        logger.exception("Falhou")
        raise
    finally:
        release_lock()


if __name__ == "__main__":
    main()