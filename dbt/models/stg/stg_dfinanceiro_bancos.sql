with src as (
    select *
    from raw.dfinanceiro_bancos
)

select
    nullif(trim("A6_COD"), '')     as banco_codigo,
    nullif(trim("A6_AGENCIA"), '') as banco_agencia,
    nullif(trim("A6_NUMCON"), '')  as banco_numero_conta,
    nullif(trim("A6_NOME"), '')    as banco_nome,
    cast("A6_SALATU" as numeric(18,4)) as banco_saldo_atual,
    nullif(trim("A6_FILIAL"), '')  as banco_filial,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src