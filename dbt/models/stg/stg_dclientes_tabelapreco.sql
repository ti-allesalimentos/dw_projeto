with src as (
    select * from raw.dclientes_tabelapreco
)

select
    nullif(trim("DA0_CODTAB"), '') as tabela_codigo,
    nullif(trim("DA0_DESCRI"), '') as tabela_descricao,

    nullif(trim("DA1_CODPRO"), '') as produto_codigo,

    cast("DA1_PRCVEN" as numeric(18,4)) as preco_unitario,

    nullif(trim("DA1_ESTADO"), '') as uf

    ,dw_batch_id
    ,dw_source
    ,dw_loaded_at
from src