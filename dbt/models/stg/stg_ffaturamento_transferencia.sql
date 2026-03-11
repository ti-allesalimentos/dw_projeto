with src as (
    select *
    from raw.ffaturamento_faturamento
)

select
    -- SF2 (capa)
    nullif(trim("F2_FILIAL"), '')   as transferencia_filial,
    nullif(trim("F2_DOC"), '')      as transferencia_documento,
    nullif(trim("F2_CLIENTE"), '')  as transferencia_cliente_codigo,
    nullif(trim("F2_LOJA"), '')     as transferencia_cliente_loja,
    nullif(trim("F2_COND"), '')     as transferencia_condicao_pagamento_codigo,
    nullif(trim("F2_DUPL"), '')     as transferencia_duplicata,
    nullif(trim("F2_EST"), '')      as transferencia_uf,
    nullif(trim("F2_TIPOCLI"), '')  as transferencia_tipo_cliente,
    nullif(trim("F2_TIPO"), '')     as transferencia_tipo_documento,

    -- SD2 (itens)
    nullif(trim("D2_FILIAL"), '')   as transferencia_item_filial,
    nullif(trim("D2_ITEM"), '')     as transferencia_item,
    nullif(trim("D2_COD"), '')      as transferencia_produto_codigo,

    cast("D2_QUANT" as numeric(18,4)) as transferencia_quantidade,
    nullif(trim("D2_UM"), '')         as transferencia_unidade_medida,

    cast("D2_TOTAL" as numeric(18,4))   as transferencia_valor_total,
    cast("D2_DESCZFR" as numeric(18,4)) as transferencia_valor_desconto,

    nullif(trim("D2_CF"), '')       as transferencia_cfop,

    nullif(trim("D2_CLIENTE"), '')  as transferencia_item_cliente_codigo,
    nullif(trim("D2_LOJA"), '')     as transferencia_item_cliente_loja,
    nullif(trim("D2_DOC"), '')      as transferencia_item_documento,
    nullif(trim("D2_SERIE"), '')    as transferencia_serie,

    cast("D2_EMISSAO" as date)      as transferencia_data_emissao,

    nullif(trim("D2_PEDIDO"), '')   as transferencia_pedido,

    cast("D2_PICM" as numeric(18,4))    as transferencia_percentual_icms,
    cast("D2_ALQPIS" as numeric(18,4))  as transferencia_aliquota_pis,
    cast("D2_ALQCOF" as numeric(18,4))  as transferencia_aliquota_cofins,
    cast("D2_ICMSRET" as numeric(18,4)) as transferencia_valor_icms_retido,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
where to_date("D2_EMISSAO", 'YYYYMMDD') > date '2025-01-31'
  and trim("D2_CLIENTE") <> '97316293'
  and trim("F2_TIPO") <> 'B'

  and trim("D2_CF") in (
        '5151', '5152', '6151', '6152'
      )

  and trim("D2_FILIAL") in (
        '01001','01003','01004','01005','01006','01007','01009',
        '01010','01011'
      )