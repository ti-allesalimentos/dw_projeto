with src as (
    select * from raw.dclientes_condpgt
)

select
    nullif(trim("E4_CODIGO"), '') as cond_pagto_codigo,
    nullif(trim("E4_COND"),   '') as cond_pagto_condicao,
    nullif(trim("E4_DESCRI"), '') as cond_pagto_descricao,

    -- Se no raw vier numeric já, cast funciona.
    -- Se vier texto, também funciona (desde que seja número).
    cast("E4_DESCFIN" as numeric(18,6)) / 100 as descfin_valor

    ,dw_batch_id
    ,dw_source
    ,dw_loaded_at
from src