with src as (
    select *
    from raw.dprodutos_grupos
)

select
    nullif(trim("BM_GRUPO"), '') as produto_grupo_codigo,
    nullif(trim("BM_DESC"), '')  as produto_grupo_descricao,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
