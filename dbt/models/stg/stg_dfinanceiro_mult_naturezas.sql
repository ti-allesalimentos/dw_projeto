with src as (
    select *
    from raw.ffinanceiro
)

select
    nullif(trim("EV_FILIAL"), '')  as mult_natureza_filial,
    nullif(trim("EV_PREFIXO"), '') as mult_natureza_prefixo,
    nullif(trim("EV_NUM"), '')     as mult_natureza_numero,
    nullif(trim("EV_PARCELA"), '') as mult_natureza_parcela,

    nullif(trim("EV_CLIFOR"), '')  as mult_natureza_clifor_codigo,
    nullif(trim("EV_LOJA"), '')    as mult_natureza_clifor_loja,

    nullif(trim("EV_TIPO"), '')    as mult_natureza_tipo,

    cast("EV_VALOR" as numeric(18,4)) as mult_natureza_valor,
    nullif(trim("EV_NATUREZ"), '')    as mult_natureza_natureza_codigo,
    cast("EV_PERC" as numeric(18,4))  as mult_natureza_percentual,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src