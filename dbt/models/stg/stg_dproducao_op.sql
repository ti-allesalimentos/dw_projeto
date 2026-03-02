with src as (
    select *
    from raw.dproducao_op
)

select
    nullif(trim("C2_FILIAL"), '')  as producao_op_filial,
    nullif(trim("C2_NUM"), '')     as producao_op_numero,
    nullif(trim("C2_ITEM"), '')    as producao_op_item,
    nullif(trim("C2_SEQUEN"), '')  as producao_op_sequencia,
    nullif(trim("C2_PRODUTO"), '') as producao_op_produto_codigo,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src