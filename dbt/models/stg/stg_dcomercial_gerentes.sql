with src as (
    select *
    from raw.dcomercial_gerentes
)

select
    nullif(trim("A3_COD"), '')   as gerente_codigo,
    nullif(trim("A3_NOME"), '')  as gerente_nome,
    cast("A3_COMIS" as numeric(18,4)) / 100 as gerente_comissao,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
