with src as (
    select *
    from raw.ffinanceiro_contas_receber
)

select
    nullif(trim("E1_FILIAL"), '')   as contas_receber_filial,
    nullif(trim("E1_PREFIXO"), '')  as contas_receber_prefixo,
    nullif(trim("E1_NUM"), '')      as contas_receber_numero,
    nullif(trim("E1_PARCELA"), '')  as contas_receber_parcela,

    nullif(trim("E1_TIPO"), '')     as contas_receber_tipo,
    nullif(trim("E1_NATUREZ"), '')  as contas_receber_natureza_codigo,
    nullif(trim("E1_SITUACA"), '')  as contas_receber_situacao,

    nullif(trim("E1_CLIENTE"), '')  as contas_receber_cliente_codigo,
    nullif(trim("E1_LOJA"), '')     as contas_receber_cliente_loja,
    nullif(trim("E1_NOMCLI"), '')   as contas_receber_cliente_nome,

    cast("E1_EMISSAO" as date)      as contas_receber_data_emissao,
    cast("E1_VENCTO" as date)       as contas_receber_data_vencimento,
    cast("E1_VENCREA" as date)      as contas_receber_data_vencimento_real,

    cast("E1_VALOR" as numeric(18,4)) as contas_receber_valor_original,

    cast("E1_BAIXA" as date)        as contas_receber_data_baixa,

    nullif(trim("E1_NUMBOR"), '')   as contas_receber_numero_boleto,
    cast("E1_DATABOR" as date)      as contas_receber_data_boleto,

    cast("E1_SALDO" as numeric(18,4))  as contas_receber_valor_saldo,
    cast("E1_VLCRUZ" as numeric(18,4)) as contas_receber_valor_cruzado,
    cast("E1_DESCFIN" as numeric(18,4)) as contas_receber_valor_desconto_financeiro,

    nullif(trim("E1_HIST"), '')     as contas_receber_historico,
    nullif(trim("E1_FLUXO"), '')    as contas_receber_fluxo,
    nullif(trim("E1_FORMREC"), '')  as contas_receber_forma_recebimento,
    nullif(trim("E1_X_FREC"), '')   as contas_receber_frequencia_recebimento,

    nullif(trim("E1_VEND1"), '')    as contas_receber_vendedor_codigo,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src