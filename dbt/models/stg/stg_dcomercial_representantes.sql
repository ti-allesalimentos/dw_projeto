with src as (
    select *
    from raw.dcomercial_representantes
)

select
    nullif(trim("A3_COD"), '')   as representante_codigo,
    nullif(trim("A3_NOME"), '')  as representante_nome,
    nullif(trim("A3_GEREN"), '') as representante_gerente_codigo,
    cast("A3_COMIS" as numeric(18,4)) / 100 as representante_comissao,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
where "D_E_L_E_T_" = ''