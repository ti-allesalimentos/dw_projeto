import os
from pathlib import Path
import hashlib
import shutil

import pandas as pd
import yaml
from sqlalchemy import text
from dotenv import load_dotenv

from src.load.load_utils import replace_table, add_tech_columns

load_dotenv()

def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

def load_layout() -> dict:
    layout_path = Path("src/manual/layouts/fmanual_schema.yml")
    if not layout_path.exists():
        raise FileNotFoundError(
            "Arquivo de layout não encontrado: src/manual/layouts/fmanual_schema.yml"
        )
    return yaml.safe_load(layout_path.read_text(encoding="utf-8"))

def validate_df(df: pd.DataFrame, required_columns: list[str], file_name: str, sheet_name: str | None = None):
    missing = [c for c in required_columns if c not in df.columns]
    if missing:
        where = f"Arquivo={file_name}"
        if sheet_name:
            where += f" | Aba={sheet_name}"
        raise ValueError(f"{where} | Colunas faltando: {missing}")

def already_ingested(engine, source_name: str, file_hash: str) -> bool:
    with engine.begin() as conn:
        r = conn.execute(
            text("""
                select 1
                from dw.ingested_files
                where source_name=:s and file_hash=:h
                limit 1
            """),
            {"s": source_name, "h": file_hash},
        ).fetchone()
        return r is not None

def register_ingest(engine, source_name: str, file_name: str, file_hash: str, row_count: int, status: str, message: str):
    with engine.begin() as conn:
        conn.execute(
            text("""
                insert into dw.ingested_files(source_name, file_name, file_hash, row_count, status, message)
                values (:s,:n,:h,:r,:st,:m)
            """),
            {"s": source_name, "n": file_name, "h": file_hash, "r": row_count, "st": status, "m": message},
        )

def ingest_fmanual(dw_engine, batch_id: str):
    """
    Suporta:
    - Excel com 1 aba (layout simples)
    - Excel com várias abas (layout com sheets no YAML)
    """
    source_name = "fmanual"

    inbox = Path(os.getenv("FMANUAL_INBOX", "data/manual/inbox"))
    processed = Path(os.getenv("FMANUAL_PROCESSED", "data/manual/processed"))
    rejected = Path(os.getenv("FMANUAL_REJECTED", "data/manual/rejected"))

    inbox.mkdir(parents=True, exist_ok=True)
    processed.mkdir(parents=True, exist_ok=True)
    rejected.mkdir(parents=True, exist_ok=True)

    layout = load_layout()

    # Layout 1: simples (uma tabela)
    # table: fmanual
    # required_columns: [...]
    simple_table = layout.get("table")
    simple_required = layout.get("required_columns", [])

    # Layout 2: múltiplas abas
    # sheets:
    #   - name: "Aba1"
    #     target_table: "fmanual_aba1"
    #     required_columns: [...]
    sheets_cfg = layout.get("sheets", [])

    for file in sorted(inbox.glob("*.xlsx")):
        fhash = sha256_file(file)

        if already_ingested(dw_engine, source_name, fhash):
            shutil.move(str(file), processed / file.name)
            continue

        try:
            if sheets_cfg:
                # múltiplas abas
                for s in sheets_cfg:
                    sheet_name = s["name"]
                    target_table = s["target_table"]
                    required_cols = s.get("required_columns", [])

                    df = pd.read_excel(file, sheet_name=sheet_name)
                    validate_df(df, required_cols, file.name, sheet_name)

                    df = add_tech_columns(df, batch_id=batch_id, source=f"MANUAL:{file.name}:{sheet_name}")
                    df["dw_source_file"] = file.name
                    df["dw_source_file_hash"] = fhash
                    df["dw_sheet_name"] = sheet_name

                    replace_table(dw_engine, "raw", target_table.lower(), df)

                register_ingest(dw_engine, source_name, file.name, fhash, 0, "OK", "Importou abas configuradas")
            else:
                # simples (uma aba)
                if not simple_table:
                    raise ValueError("Layout fmanual_schema.yml não tem 'table' nem 'sheets'.")

                df = pd.read_excel(file)  # primeira aba
                validate_df(df, simple_required, file.name, None)

                df = add_tech_columns(df, batch_id=batch_id, source=f"MANUAL:{file.name}")
                df["dw_source_file"] = file.name
                df["dw_source_file_hash"] = fhash

                replace_table(dw_engine, "raw", simple_table.lower(), df)
                register_ingest(dw_engine, source_name, file.name, fhash, len(df), "OK", "Importou layout simples")

            shutil.move(str(file), processed / file.name)

        except Exception as e:
            register_ingest(dw_engine, source_name, file.name, fhash, 0, "ERROR", str(e))
            shutil.move(str(file), rejected / file.name)
            raise