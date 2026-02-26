import os
from pathlib import Path
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
from tenacity import retry, stop_after_attempt, wait_fixed

load_dotenv()

def erp_engine():
    conn_type = os.getenv("ERP_CONN_TYPE", "mssql")
    host = os.getenv("ERP_HOST")
    port = os.getenv("ERP_PORT")
    db = os.getenv("ERP_DB")
    user = os.getenv("ERP_USER")
    pwd = os.getenv("ERP_PASSWORD")

    if conn_type == "mssql":
        # Opção simples (requer: pip install pymssql)
        url = f"mssql+pymssql://{user}:{pwd}@{host}:{port}/{db}"
        return create_engine(url, pool_pre_ping=True)

    if conn_type == "postgres":
        url = f"postgresql+psycopg2://{user}:{pwd}@{host}:{port}/{db}"
        return create_engine(url, pool_pre_ping=True)

    raise ValueError(f"ERP_CONN_TYPE não suportado: {conn_type}")

def list_sql_files():
    qdir = Path("src/extract/queries")
    return sorted(qdir.glob("*.sql"))

@retry(stop=stop_after_attempt(3), wait=wait_fixed(5))
def run_query(engine, sql_text: str) -> pd.DataFrame:
    return pd.read_sql_query(text(sql_text), con=engine)
