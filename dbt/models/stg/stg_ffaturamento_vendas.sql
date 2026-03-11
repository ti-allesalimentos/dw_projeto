with src as (
    select *
    from raw.ffaturamento_faturamento
)

select
    -- SF2 (capa)
    nullif(trim("F2_FILIAL"), '')   as vendas_filial,
    nullif(trim("F2_DOC"), '')      as vendas_documento,
    nullif(trim("F2_CLIENTE"), '')  as vendas_cliente_codigo,
    nullif(trim("F2_LOJA"), '')     as vendas_cliente_loja,
    nullif(trim("F2_COND"), '')     as vendas_condicao_pagamento_codigo,
    nullif(trim("F2_DUPL"), '')     as vendas_duplicata,
    nullif(trim("F2_EST"), '')      as vendas_uf,
    nullif(trim("F2_TIPOCLI"), '')  as vendas_tipo_cliente,
    nullif(trim("F2_TIPO"), '')     as vendas_tipo_documento,

    -- SD2 (itens)
    nullif(trim("D2_FILIAL"), '')   as vendas_item_filial,
    nullif(trim("D2_ITEM"), '')     as vendas_item,
    nullif(trim("D2_COD"), '')      as vendas_produto_codigo,

    cast("D2_QUANT" as numeric(18,4)) as vendas_quantidade,
    nullif(trim("D2_UM"), '')         as vendas_unidade_medida,

    cast("D2_TOTAL" as numeric(18,4))   as vendas_valor_total,
    cast("D2_DESCZFR" as numeric(18,4)) as vendas_valor_desconto,

    nullif(trim("D2_CF"), '')       as vendas_cfop,

    nullif(trim("D2_CLIENTE"), '')  as vendas_item_cliente_codigo,
    nullif(trim("D2_LOJA"), '')     as vendas_item_cliente_loja,
    nullif(trim("D2_DOC"), '')      as vendas_item_documento,
    nullif(trim("D2_SERIE"), '')    as vendas_serie,

    cast("D2_EMISSAO" as date)      as vendas_data_emissao,

    nullif(trim("D2_PEDIDO"), '')   as vendas_pedido,

    cast("D2_PICM" as numeric(18,4))    as vendas_percentual_icms,
    cast("D2_ALQPIS" as numeric(18,4))  as vendas_aliquota_pis,
    cast("D2_ALQCOF" as numeric(18,4))  as vendas_aliquota_cofins,
    cast("D2_ICMSRET" as numeric(18,4)) as vendas_valor_icms_retido,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
where to_date("D2_EMISSAO", 'YYYYMMDD') > date '2025-01-31'
  and trim("D2_CLIENTE") <> '97316293'
  and trim("F2_TIPO") <> 'B'

  and trim("D2_CF") in (
        '6101','5102','6118','5101','5403','6110','6401','6107','6102',
        '5401','6403','6108','6109','5109','6501', '7101', '7102'
      )

  and trim("D2_FILIAL") in (
        '01001','01003','01004','01005','01006','01007','01009',
        '01010','01011'
      )

  and (
        trim("D2_FILIAL") <> '01004'
        or trim("D2_DOC") not in (
            '000029000','000012896','000012898','000012899','000012900','000012901',
            '000012908','000012909','000012910','000012911','000012912','000015334',
            '000015335','000015336','000015455','000015456','000015457','000016294',
            '000016295','000016296','000016298','000016299','000016300','000016320',
            '000016321','000016322','000016323','000016324','000018493','000023971',
            '000025043'
        )
      )

  and (
        trim("D2_FILIAL") <> '03001'
        or trim("D2_DOC") not in ('000002073','000002082')
      )