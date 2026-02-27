with src as (
    select *
    from raw.dfinanceiro_motivo_baixa
)

select
    nullif(trim("A6_COD"), '')     as motivo_baixa_codigo,
    nullif(trim("A6_AGENCIA"), '') as motivo_baixa_agencia,
    nullif(trim("A6_NUMCON"), '')  as motivo_baixa_numero_conta,
    nullif(trim("A6_NOME"), '')    as motivo_baixa_nome,
    cast("A6_SALATU" as numeric(18,4)) as motivo_baixa_saldo_atual,
    nullif(trim("A6_FILIAL"), '')  as motivo_baixa_filial,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src