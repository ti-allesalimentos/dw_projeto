with src as (
    select *
    from raw.dfornecedores_fornecedores
)

select
    nullif(trim("A2_COD"), '')     as fornecedor_codigo,
    nullif(trim("A2_LOJA"), '')    as fornecedor_loja,
    nullif(trim("A2_NREDUZ"), '')  as fornecedor_nome_reduzido,
    nullif(trim("A2_CGC"), '')     as fornecedor_cnpj,
    nullif(trim("A2_NOME"), '')    as fornecedor_nome,
    nullif(trim("A2_END"), '')     as fornecedor_endereco,
    nullif(trim("A2_BAIRRO"), '')  as fornecedor_bairro,
    nullif(trim("A2_MUN"), '')     as fornecedor_municipio,
    nullif(trim("A2_EST"), '')     as fornecedor_uf,
    nullif(trim("A2_CEP"), '')     as fornecedor_cep,
    nullif(trim("A2_EMAIL"), '')   as fornecedor_email,
    nullif(trim("A2_GRPTRIB"), '') as fornecedor_grupo_tributario,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
where "D_E_L_E_T_" = ''