import pandas as pd
from sqlalchemy import text

def add_tech_columns(df: pd.DataFrame, batch_id: str, source: str) -> pd.DataFrame:
    df = df.copy()
    df["dw_batch_id"] = batch_id
    df["dw_source"] = source
    df["dw_loaded_at"] = pd.Timestamp.utcnow()
    return df

def replace_table(engine, schema: str, table: str, df: pd.DataFrame):
    full = f"{schema}.{table}"
    with engine.begin() as conn:
        conn.execute(text(f"create schema if not exists {schema};"))
        df.head(0).to_sql(table, con=conn, schema=schema, if_exists="append", index=False)
        conn.execute(text(f"truncate table {full};"))
        df.to_sql(table, con=conn, schema=schema, if_exists="append", index=False, chunksize=50000)
