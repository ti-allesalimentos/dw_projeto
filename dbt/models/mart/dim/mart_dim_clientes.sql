{{ config(materialized='view') }}

select
    sk_cliente,
    nk_cliente,

    cliente_codigo,
    cliente_loja,
    cliente_nome,
    cliente_nome_reduzido,
    cliente_pessoa_tipo,

    cliente_municipio,
    cliente_uf,
    cliente_cep,

    rede_codigo,
    rede_descricao,

    cond_pagto_codigo,
    cond_pagto_descricao,
    descfin_valor,

    cliente_bloqueado,
    cliente_data_cadastro,
    cliente_data_ultima_compra

from {{ ref('dim_clientes') }}