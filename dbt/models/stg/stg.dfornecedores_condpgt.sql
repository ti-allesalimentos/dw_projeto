with src as (
    select *
    from raw.dfornecedores_condpgt
)

select
    nullif(trim("E4_CODIGO"), '') as condicao_pagamento_codigo,
    nullif(trim("E4_TIPO"), '')   as ondicao_pagamento_tipo,
    nullif(trim("E4_COND"), '')   as condicao_pagamento_descricao,
    nullif(trim("E4_DDD"), '')    as condicao_pagamento_ddd,

    dw_batch_id,
    dw_source,
    dw_loaded_at
from src
where "D_E_L_E_T_" = ''