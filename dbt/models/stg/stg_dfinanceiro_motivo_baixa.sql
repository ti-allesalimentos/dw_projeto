with src as (
    select *
    from raw.dfinanceiro_motivo_baixa
)

select
    nullif(trim("F7G_SIGLA"), '')  as mot_baixa_codigo,
    nullif(trim("F7G_DESCRI"), '') as mot_baixa_descricao,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src