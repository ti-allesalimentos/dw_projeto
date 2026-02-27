with src as (
    select *
    from raw.ffaturamento_faturamento
)

select
    nullif(trim("D1_FILIAL"), '')   as faturamento_filial,
    nullif(trim("D1_ITEM"), '')     as faturamento_item,
    nullif(trim("D1_DOC"), '')      as faturamento_documento,

    nullif(trim("D1_COD"), '')      as faturamento_produto_codigo,
    nullif(trim("D1_UM"), '')       as faturamento_produto_unidade_medida,

    cast("D1_QUANT" as numeric(18,4))   as faturamento_quantidade,
    cast("D1_VUNIT" as numeric(18,4))   as faturamento_valor_unitario,
    cast("D1_TOTAL" as numeric(18,4))   as faturamento_valor_total,
    cast("D1_VALDESC" as numeric(18,4)) as faturamento_valor_desconto,

    nullif(trim("D1_ITEMORI"), '')  as faturamento_item_origem,
    nullif(trim("D1_NFORI"), '')    as faturamento_documento_origem,

    nullif(trim("D1_FORNECE"), '')  as faturamento_fornecedor_codigo,
    nullif(trim("D1_LOJA"), '')     as faturamento_fornecedor_loja,

    nullif(trim("D1_SERIE"), '')    as faturamento_serie,
    nullif(trim("D1_COR"), '')      as faturamento_cor,
    nullif(trim("D1_CHASSI"), '')   as faturamento_chassi,

    cast("D1_EMISSAO" as date)      as faturamento_data_emissao,
    cast("D1_DTDIGIT" as date)      as faturamento_data_digitacao,

    nullif(trim("D1_CF"), '')       as faturamento_cfop,
    nullif(trim("D1_TIPO"), '')     as faturamento_tipo,

    nullif(trim("F1_FORMUL"), '')   as faturamento_formulario,
    nullif(trim("F1_STATUS"), '')   as faturamento_status,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src