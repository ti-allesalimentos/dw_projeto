📊 Data Warehouse Project

🚀 Visão Geral

Este projeto implementa um Data Warehouse completo utilizando:

PostgreSQL

dbt (Data Build Tool)

Python (orquestração do pipeline)

Windows Task Scheduler

Ambiente virtual Python

Arquitetura em camadas (Raw → Staging → Marts)

O objetivo é consolidar dados transacionais e disponibilizá-los para consumo em ferramentas de BI.

🏗 Arquitetura
Fonte de Dados (ERP / Queries SQL)
        ↓
Extração (Python)
        ↓
Camada RAW (Postgres)
        ↓
Transformações (dbt)
        ↓
Staging
        ↓
Core
        ↓
Data Marts
        ↓
Power BI / Ferramenta de BI

📂 Estrutura do Projeto
dw_projeto/
│
├── dbt/                 # Projeto dbt (modelos e transformações)
│
├── scripts/             # Scripts Python (pipeline)
│   └── run_pipeline.py
│
├── logs/                # Logs de execução
│
├── .venv/               # Ambiente virtual (não versionado)
│
├── requirements.txt     # Dependências do projeto
│
├── .gitignore
│
└── README.md

⚙️ Tecnologias Utilizadas

Python 3.12.4

PostgreSQL

dbt Core

Git

Windows Server 2022

Docker (Postgres rodando em VM Linux)

🔄 Pipeline de Execução

O pipeline executa:

Extração dos dados

Carga na camada RAW

Execução do dbt

Atualização das tabelas analíticas

Geração de logs

Execução manual:

python -m scripts.run_pipeline

🛠 Como Rodar Localmente
1️⃣ Criar ambiente virtual
python -m venv .venv
2️⃣ Ativar ambiente
.venv\Scripts\activate
3️⃣ Instalar dependências
pip install -r requirements.txt
4️⃣ Configurar conexão dbt

Criar arquivo profiles.yml (fora do versionamento).

5️⃣ Executar dbt
dbt run
dbt test
📈 Consumo no BI

As tabelas finais (marts) estão prontas para conexão via:

Power BI

Metabase

Tableau

Qualquer ferramenta compatível com PostgreSQL

🔐 Segurança

Arquivos sensíveis não são versionados:

.env

profiles.yml

Logs

Ambiente virtual

🎯 Objetivo do Projeto

Este projeto foi desenvolvido com foco em:

Boas práticas de Engenharia de Dados

Separação por camadas

Versionamento com Git

Estrutura profissional de Data Warehouse

Execução automatizada

👨‍💻 Autor

Projeto desenvolvido por [Lucas R. Nogarini]
Engenharia de Dados | Data Warehouse | BI

🔥 Próximos passos 


✔ Separar modelos dbt em staging/ e marts/

✔ Criar documentação automática com dbt docs

✔ Adicionar diagrama de arquitetura

✔ Criar Dockerfile do projeto

✔ Colocar badge de tecnologias

✔ Criar versão “deployable”