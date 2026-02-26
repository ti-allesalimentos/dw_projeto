with src as (
    select * from raw.dclientes_fprospect
)

select
    nullif(trim("US_NOME"),  '') as prospect_nome,
    nullif(trim("US_CGC"),   '') as prospect_documento,
    nullif(trim("US_MUN"),   '') as prospect_municipio,
    nullif(trim("US_EST"),   '') as prospect_uf,
    nullif(trim("US_DDD"),   '') as prospect_ddd,
    nullif(trim("US_TEL"),   '') as prospect_telefone,
    nullif(trim("US_EMAIL"), '') as prospect_email,

    -- no Protheus normalmente é YYYYMMDD (texto); transformamos em date
    case
        when "US_DTCAD" is null then null
        when trim("US_DTCAD") in ('', '00000000') then null
        else to_date(trim("US_DTCAD"), 'YYYYMMDD')
    end as prospect_data_cadastro,

    nullif(trim("US_STATUS"), '') as prospect_status,
    nullif(trim("US_VEND"),   '') as vendedor_codigo,

    nullif(trim("US_X_MOTI"), '') as motivo,
    nullif(trim("US_X_TRAV"), '') as impeditivo,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src