with src as (
    select *
    from raw.ffinanceiro_contas_pagar
)

select
    nullif(trim("E2_FILIAL"), '')   as contas_pagar_filial,
    nullif(trim("E2_PREFIXO"), '')  as contas_pagar_prefixo,
    nullif(trim("E2_NUM"), '')      as contas_pagar_numero,
    nullif(trim("E2_PARCELA"), '')  as contas_pagar_parcela,

    nullif(trim("E2_FORNECE"), '')  as contas_pagar_fornecedor_codigo,
    nullif(trim("E2_LOJA"), '')     as contas_pagar_fornecedor_loja,
    nullif(trim("E2_NOMFOR"), '')   as contas_pagar_fornecedor_nome,

    nullif(trim("E2_TIPO"), '')     as contas_pagar_tipo,
    nullif(trim("E2_NATUREZ"), '')  as contas_pagar_natureza_codigo,

    cast("E2_EMISSAO" as date)      as contas_pagar_data_emissao,
    cast("E2_VENCREA" as date)      as contas_pagar_data_vencimento,

    nullif(trim("E2_X_RENEG"), '')  as contas_pagar_renegociado_flag,

    cast("E2_JUROS" as numeric(18,4))   as contas_pagar_valor_juros,
    cast("E2_VALLIQ" as numeric(18,4))  as contas_pagar_valor_liquido,

    cast("E2_BAIXA" as date)        as contas_pagar_data_baixa,

    nullif(trim("E2_FORMPAG"), '')  as contas_pagar_forma_pagamento,

    cast("E2_VALOR" as numeric(18,4))  as contas_pagar_valor_original,
    cast("E2_SALDO" as numeric(18,4))  as contas_pagar_valor_saldo,

    nullif(trim("E2_LINDIG"), '')   as contas_pagar_linha_digitavel,
    nullif(trim("E2_CODBAR"), '')   as contas_pagar_codigo_barras,

    nullif(trim("E2_X_PRIOR"), '')  as contas_pagar_prioridade,
    nullif(trim("E2_X_SIT"), '')    as contas_pagar_situacao,

    cast("E2_DECRESC" as numeric(18,4)) as contas_pagar_valor_decrescimo,

    nullif(trim("E2_FATURA"), '')   as contas_pagar_fatura,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src