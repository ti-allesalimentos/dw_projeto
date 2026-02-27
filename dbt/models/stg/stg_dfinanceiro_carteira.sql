with src as (
    select *
    from raw.dfinanceiro_carteira
)

select
    nullif(trim("FRV_CODIGO"), '') as carteira_codigo,
    nullif(trim("FRV_DESCRI"), '') as carteira_descricao,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src