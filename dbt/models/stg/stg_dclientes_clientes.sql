with src as (
    select * from raw.dclientes_clientes
),

clean as (
    select
        -- chaves (cliente + loja)
        nullif(trim("A1_COD"),  '') as cliente_codigo,
        nullif(trim("A1_LOJA"), '') as cliente_loja,

        -- pessoa (F/J normalmente)
        nullif(trim("A1_PESSOA"), '') as cliente_pessoa_tipo,

        -- textos
        nullif(trim("A1_NOME"),   '') as cliente_nome,
        nullif(trim("A1_NREDUZ"), '') as cliente_nome_reduzido,
        nullif(trim("A1_END"),    '') as cliente_endereco,
        nullif(trim("A1_BAIRRO"), '') as cliente_bairro,
        nullif(trim("A1_MUN"),    '') as cliente_municipio,
        nullif(trim("A1_EST"),    '') as cliente_uf,

        -- documentos / códigos
        nullif(trim("A1_CGC"),   '') as cliente_cgc_cpf,
        nullif(trim("A1_CEP"),   '') as cliente_cep,
        nullif(trim("A1_GRPVEN"), '') as cliente_grupo_vendas,
        nullif(trim("A1_X_FREC"), '') as cliente_frequencia,
        nullif(trim("A1_COND"),  '') as cliente_condicao_pagto,
        nullif(trim("A1_CONTA"), '') as cliente_conta,
        nullif(trim("A1_BCO1"),  '') as cliente_banco_1,
        nullif(trim("A1_VEND"),  '') as vendedor_1_codigo,
        nullif(trim("A1_VEND3"), '') as vendedor_3_codigo,
        nullif(trim("A1_X_TPCLI"), '') as cliente_tipo_custom,
        nullif(trim("A1_TIPO"),    '') as cliente_tipo,
        cast("A1_COMIS" as numeric(12,4)) as cliente_comissao_pct,
        cast("A1_DESC"  as numeric(12,4)) as cliente_desconto_pct,

        -- datas Protheus (YYYYMMDD)
        case
            when trim("A1_DTCAD") in ('', '00000000') then null
            else to_date(trim("A1_DTCAD"), 'YYYYMMDD')
        end as cliente_data_cadastro,

        case
            when trim("A1_ULTCOM") in ('', '00000000') then null
            else to_date(trim("A1_ULTCOM"), 'YYYYMMDD')
        end as cliente_data_ultima_compra,

        -- bloqueio (ajuste se no seu Protheus for diferente)
        case
            when nullif(trim("A1_MSBLQL"), '') is null then null
            when trim("A1_MSBLQL") in ('1','S','s','Y','y') then true
            else false
        end as cliente_bloqueado,

        -- colunas técnicas (vieram do Python)
        dw_batch_id,
        dw_source,
        dw_loaded_at

    from src
)

select * from clean