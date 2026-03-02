with src as (
    select *
    from raw.drh_funcionarios
)

select
    nullif(trim("RA_FILIAL"), '')   as rh_funcionario_filial,
    nullif(trim("RA_MAT"), '')      as rh_funcionario_matricula,
    nullif(trim("RA_NOME"), '')     as rh_funcionario_nome,
    nullif(trim("RA_SEXO"), '')     as rh_funcionario_sexo,

    cast("RA_NASC" as date)         as rh_funcionario_data_nascimento,
    cast("RA_ADMISSA" as date)      as rh_funcionario_data_admissao,
    cast("RA_DEMISSA" as date)      as rh_funcionario_data_demissao,

    nullif(trim("RA_SITFOLH"), '')  as rh_funcionario_situacao_folha,
    nullif(trim("RA_CC"), '')       as rh_funcionario_centro_custo_codigo,
    nullif(trim("RA_CODFUNC"), '')  as rh_funcionario_codigo_funcao,

    cast("RA_SALARIO" as numeric(18,4)) as rh_funcionario_salario,
    cast("RA_HRSMES" as numeric(18,4))  as rh_funcionario_horas_mes,
    cast("RA_ADCPERI" as numeric(18,4)) as rh_funcionario_adicional_periculosidade,
    cast("RA_ADCINS" as numeric(18,4))  as rh_funcionario_adicional_insalubridade,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src