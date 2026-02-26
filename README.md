Pipeline:
- Python extrai ERP + importa fManual (Excel) -> Postgres (raw)
- dbt transforma -> Postgres (stg/core/mart)
- Power BI consome mart

Como rodar:
1) Ativar venv
2) python scripts/run_pipeline.py
