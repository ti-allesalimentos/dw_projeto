with src as (
    select *
    from raw.fproducao_mov_interna
)

select
    nullif(trim("D3_FILIAL"), '') as producao_mov_interno_filial,
    nullif(trim("D3_OP"), '')     as producao_mov_interno_ordem_producao,
    nullif(trim("D3_COD"), '')    as producao_mov_interno_produto_codigo,
    nullif(trim("D3_UM"), '')     as producao_mov_interno_unidade_medida,

    cast("D3_QUANT" as numeric(18,4)) as producao_mov_interno_quantidade,

    nullif(trim("D3_TM"), '')     as producao_mov_interno_tipo_movimento,
    nullif(trim("D3_GRUPO"), '')  as producao_mov_interno_grupo,

    cast("D3_EMISSAO" as date)    as producao_mov_interno_data_emissao,

    nullif(trim("D3_CF"), '')     as producao_mov_interno_cfop,
    nullif(trim("D3_ESTORNO"), '') as producao_mov_interno_estorno_flag,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src