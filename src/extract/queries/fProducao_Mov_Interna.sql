SELECT
    D3_FILIAL,
    D3_OP,
    D3_COD,
    D3_UM,
    D3_QUANT,
    D3_TM,
    D3_GRUPO,
    D3_EMISSAO,
    D3_CF,
    D3_ESTORNO
FROM SD3010
WHERE D_E_L_E_T_ = ''
--   AND D3_OP <> ''
--   AND D3_COD NOT LIKE '%MOD%'
--   AND D3_OP NOT LIKE '%OS%'
--   AND D3_CF LIKE '%RE%'
--   AND D3_ESTORNO <> 'S'