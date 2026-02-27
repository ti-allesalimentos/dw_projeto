with src as (
    select *
    from raw.ffaturamento_devolucao
)

select
    -- SD1
    nullif(trim("D1_FILIAL"), '') as devolucao_filial,
    nullif(trim("D1_ITEM"), '')   as devolucao_item,
    nullif(trim("D1_DOC"), '')    as devolucao_documento,

    nullif(trim("D1_COD"), '')    as devolucao_produto_codigo,
    nullif(trim("D1_UM"), '')     as devolucao_produto_unidade_medida,

    cast("D1_QUANT" as numeric(18,4))   as devolucao_quantidade,
    cast("D1_VUNIT" as numeric(18,4))   as devolucao_valor_unitario,
    cast("D1_TOTAL" as numeric(18,4))   as devolucao_valor_total,
    cast("D1_VALDESC" as numeric(18,4)) as devolucao_valor_desconto,

    nullif(trim("D1_ITEMORI"), '') as devolucao_item_origem,
    nullif(trim("D1_NFORI"), '')   as devolucao_documento_origem,

    nullif(trim("D1_FORNECE"), '') as devolucao_fornecedor_codigo,
    nullif(trim("D1_LOJA"), '')    as devolucao_fornecedor_loja,

    nullif(trim("D1_SERIE"), '')   as devolucao_serie,
    nullif(trim("D1_COR"), '')     as devolucao_cor,
    nullif(trim("D1_CHASSI"), '')  as devolucao_chassi,

    cast("D1_EMISSAO" as date)     as devolucao_data_emissao,
    cast("D1_DTDIGIT" as date)     as devolucao_data_digitacao,

    nullif(trim("D1_CF"), '')      as devolucao_cfop,
    nullif(trim("D1_TIPO"), '')    as devolucao_tipo,

    -- SF1 (chaves repetidas da capa + atributos)
    nullif(trim("F1_FILIAL"), '')  as devolucao_capa_filial,
    nullif(trim("F1_DOC"), '')     as devolucao_capa_documento,
    nullif(trim("F1_SERIE"), '')   as devolucao_capa_serie,
    nullif(trim("F1_FORNECE"), '') as devolucao_capa_fornecedor_codigo,
    nullif(trim("F1_LOJA"), '')    as devolucao_capa_fornecedor_loja,

    nullif(trim("F1_FORMUL"), '')  as devolucao_formulario,
    nullif(trim("F1_STATUS"), '')  as devolucao_status,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src