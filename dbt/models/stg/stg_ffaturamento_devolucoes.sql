with src as (
    select *
    from raw.ffaturamento_devolucao
)

select
    nullif(trim("D1_FILIAL"), '')   as faturamento_devolucao_filial,
    nullif(trim("D1_ITEM"), '')     as faturamento_devolucao_item,
    nullif(trim("D1_DOC"), '')      as faturamento_devolucao_documento,

    nullif(trim("D1_COD"), '')      as faturamento_devolucao_produto_codigo,
    nullif(trim("D1_UM"), '')       as faturamento_devolucao_unidade_medida,

    cast("D1_QUANT" as numeric(18,4))   as faturamento_devolucao_quantidade,
    cast("D1_VUNIT" as numeric(18,4))   as faturamento_devolucao_valor_unitario,
    cast("D1_TOTAL" as numeric(18,4))   as faturamento_devolucao_valor_total,
    cast("D1_VALDESC" as numeric(18,4)) as faturamento_devolucao_valor_desconto,

    nullif(trim("D1_ITEMORI"), '')  as faturamento_devolucao_item_origem,
    nullif(trim("D1_NFORI"), '')    as faturamento_devolucao_documento_origem,

    nullif(trim("D1_FORNECE"), '')  as faturamento_devolucao_fornecedor_codigo,
    nullif(trim("D1_LOJA"), '')     as faturamento_devolucao_fornecedor_loja,

    nullif(trim("D1_SERIE"), '')    as faturamento_devolucao_serie,
    nullif(trim("D1_COR"), '')      as faturamento_devolucao_cor,
    nullif(trim("D1_CHASSI"), '')   as faturamento_devolucao_chassi,

    cast("D1_EMISSAO" as date)      as faturamento_devolucao_data_emissao,
    cast("D1_DTDIGIT" as date)      as faturamento_devolucao_data_digitacao,

    nullif(trim("D1_CF"), '')       as faturamento_devolucao_cfop,
    nullif(trim("D1_TIPO"), '')     as faturamento_devolucao_tipo,

    nullif(trim("F1_FILIAL"), '')   as faturamento_devolucao_capa_filial,
    nullif(trim("F1_DOC"), '')      as faturamento_devolucao_capa_documento,
    nullif(trim("F1_SERIE"), '')    as faturamento_devolucao_capa_serie,
    nullif(trim("F1_FORNECE"), '')  as faturamento_devolucao_capa_fornecedor_codigo,
    nullif(trim("F1_LOJA"), '')     as faturamento_devolucao_capa_fornecedor_loja,
    nullif(trim("F1_FORMUL"), '')   as faturamento_devolucao_formulario,
    nullif(trim("F1_STATUS"), '')   as faturamento_devolucao_status,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
where nullif(trim("F1_STATUS"), '') is not null
  and (
        trim("D1_CF") in (
            '1202','1203','1410','1411','1201','1903',
            '2410','2411','2201','2202','2203','2911','2551'
        )
        or (trim("D1_TIPO") = 'D' and nullif(trim("D1_CF"), '') is null)
      )
  and trim("D1_COD") like '%PA%'
  and trim("D1_FORNECE") not in ('97316293', '30704321')
  and trim("D1_SERIE") not like '%AC%'
  and (
        trim("D1_FILIAL") <> '01004'
        or trim("D1_DOC") not in (
            '000016378','000016379','000016380',
            '000016621','000016622','000016623',
            '000016625','000016626','000016696',
            '000016714','000016715','000016915',
            '000016916','000016917'
        )
      )
  and (
        trim("D1_FILIAL") <> '01006'
        or trim("D1_DOC") not in ('000045676','000045699')
      )