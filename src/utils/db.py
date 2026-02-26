import os
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

def dw_engine():
    host = os.getenv("DW_PG_HOST")
    port = os.getenv("DW_PG_PORT")
    db = os.getenv("DW_PG_DB")
    user = os.getenv("DW_PG_USER")
    pwd = os.getenv("DW_PG_PASSWORD")
    url = f"postgresql+psycopg2://{user}:{pwd}@{host}:{port}/{db}"
    return create_engine(url, pool_pre_ping=True)
