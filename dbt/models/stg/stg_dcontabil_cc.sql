with src as (
    select *
    from raw.dcontabil_cc
)

select
    nullif(trim("CTT_CUSTO"), '')  as centro_custo_codigo,
    nullif(trim("CTT_DESC01"), '') as centro_custo_descricao,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src