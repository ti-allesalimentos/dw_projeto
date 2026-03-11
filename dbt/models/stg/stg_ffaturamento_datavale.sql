with src as (
    select *
    from raw.fmanual_ffaturamento_datavale
)

select
    nullif(trim("Coluna 1"), '')  as faturamento_filial,
    nullif(trim("Coluna 2"), '')  as faturamento_codigo_cliente,
    nullif(trim("Coluna 3"), '')  as faturamento_codigo_produto,
    nullif(trim("Coluna 4"), '')  as faturamento_quantidade,
    nullif(trim("Coluna 5"), '')  as faturamento_unidade_medida,
    nullif(trim("Coluna 6"), '')  as faturamento_valor_unitario,
    nullif(trim("Coluna 7"), '')  as faturamento_valor_total,
    nullif(trim("Coluna 8"), '')  as faturamento_código_vendedor,
    nullif(trim("Coluna 9"), '')  as faturamento_estado,
    cast("Coluna 10" as date) as faturamento_data,
    nullif(trim("Coluna 11"), '') as faturamento_descricao_cliente,
    nullif(trim("Coluna 12"), '') as faturamento_cnpj,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src