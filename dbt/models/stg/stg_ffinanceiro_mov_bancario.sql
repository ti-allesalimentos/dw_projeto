with src as (
    select *
    from raw.ffinanceiro_mov_bancario
)

select
    nullif(trim("E5_FILORIG"), '') as mov_bancario_filial_origem,
    nullif(trim("E5_TIPODOC"), '') as mov_bancario_tipo_documento,

    cast("E5_VALOR" as numeric(18,4)) as mov_bancario_valor,

    nullif(trim("E5_NATUREZ"), '') as mov_bancario_natureza_codigo,

    nullif(trim("E5_BANCO"), '')   as mov_bancario_banco_codigo,
    nullif(trim("E5_AGENCIA"), '') as mov_bancario_agencia,
    nullif(trim("E5_CONTA"), '')   as mov_bancario_conta,

    nullif(trim("E5_HISTOR"), '')  as mov_bancario_historico,
    nullif(trim("E5_BENEF"), '')   as mov_bancario_beneficiario,

    nullif(trim("E5_NUMERO"), '')  as mov_bancario_numero,
    nullif(trim("E5_PARCELA"), '') as mov_bancario_parcela,

    nullif(trim("E5_CLIFOR"), '')  as mov_bancario_clifor_codigo,
    nullif(trim("E5_LOJA"), '')    as mov_bancario_clifor_loja,

    nullif(trim("E5_SEQ"), '')     as mov_bancario_sequencia,

    cast("E5_DATA" as date)        as mov_bancario_data,

    nullif(trim("E5_MOTBX"), '')   as mov_bancario_motivo_baixa,
    nullif(trim("E5_TABORI"), '')  as mov_bancario_tabela_origem,
    nullif(trim("E5_TIPO"), '')    as mov_bancario_tipo,

    cast("E5_DTCANBX" as date)     as mov_bancario_data_cancelamento_baixa,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src