{{ config(materialized='table') }}

with base as (

    select *
    from {{ ref('stg_dclientes_clientes') }}

),

dedup as (

    select *
    from (
        select
            *,
            row_number() over (
                partition by cliente_codigo, cliente_loja
                order by dw_loaded_at desc
            ) as rn
        from base
        where cliente_codigo is not null
          and cliente_loja is not null
    ) x
    where rn = 1

),

enriched as (

    select
        d.*,

        -- conformando nomes (para o DW)
        d.cliente_grupo_vendas      as rede_codigo,
        r.rede_descricao            as rede_descricao,

        d.cliente_condicao_pagto    as cond_pagto_codigo,
        p.cond_pagto_descricao      as cond_pagto_descricao,
        p.descfin_valor             as descfin_valor

    from dedup d
    left join {{ ref('stg_dclientes_redes') }} r
        on r.rede_codigo = d.cliente_grupo_vendas

    left join {{ ref('stg_dclientes_condpgt') }} p
        on p.cond_pagto_codigo = d.cliente_condicao_pagto

)

select
    md5(cliente_codigo || '|' || cliente_loja) as sk_cliente,
    cliente_codigo || '|' || cliente_loja      as nk_cliente,

    enriched.*
from enriched