with src as (
    select *
    from raw.dprodutos_produtos
)

select
    nullif(trim("B1_COD"), '')     as produto_codigo,
    nullif(trim("B1_DESC"), '')    as produto_descricao,
    nullif(trim("B1_TIPO"), '')    as produto_tipo,
    nullif(trim("B1_UM"), '')      as produto_unidade_medida,
    nullif(trim("B1_GRUPO"), '')   as produto_grupo,
    nullif(trim("B1_UCOM"), '')    as produto_unidade_compra,
    nullif(trim("B1_CONTA"), '')   as produto_conta,
    nullif(trim("B1_X_AGRUP"), '') as produto_agrupador,
    nullif(trim("B1_UPRC"), '')    as produto_uprc,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
where "D_E_L_E_T_" = ''