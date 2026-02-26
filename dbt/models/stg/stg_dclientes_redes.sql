with src as (
    select * from raw.dclientes_redes
)

select
    nullif(trim("ACY_GRPVEN"), '') as rede_codigo,
    nullif(trim("ACY_DESCRI"), '') as rede_descricao,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src