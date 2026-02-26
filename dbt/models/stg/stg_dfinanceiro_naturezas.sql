with src as (
    select *
    from raw.dFinanceiro_Naturezas
)

select
    nullif(trim("ED_CODIGO"), '')  as natureza_codigo,
    nullif(trim("ED_DESCRIC"), '') as natureza_descricao,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
where "D_E_L_E_T_" = ''