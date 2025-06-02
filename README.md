# n8n Energy Project

Este projeto implementa uma solução baseada em workflows (n8n) para monitoramento de consumo de energia elétrica de clientes, com detecção de outliers no consumo com base em Z-score.

## 📂 Estrutura do Projeto

- `create-tables.sql`: Criação das tabelas e schema no banco de dados PostgreSQL.
- `main_workflow.sql`: Consulta que calcula a média de consumo nos últimos 3 meses.
- `main_workflow.py`: Lógica Python para identificar outliers no consumo de energia.
- `init-data.sh`: Script para criação de usuário e permissões no banco.
- `.env`: Variáveis de ambiente usadas pelo `docker-compose`.
- `docker-compose.yml`: Orquestração dos serviços necessários com Docker.

## 🛠️ Tecnologias Utilizadas

- **n8n**: Plataforma de automação de workflows.
- **PostgreSQL**: Banco de dados relacional.
- **Docker** + **Docker Compose**: Ambiente de contêineres para facilitar a execução local.
- **Python**: Utilizado no node do n8n para cálculo estatístico.
- **SQL**: Utilizado para agregações e consulta de consumo.

## 🧱 Estrutura do Banco de Dados

A estrutura foi criada com os campos especificados no enunciado, sem a criação de campos adicionais, a fim de manter a simplicidade na modelagem dos dados.

```sql
SCHEMA: energy

TABLE clients (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
)

TABLE contracts (
  id SERIAL PRIMARY KEY,
  start_date TIMESTAMP NOT NULL,
  enabled BOOLEAN DEFAULT TRUE,
  client_id INTEGER REFERENCES clients(id)
)

TABLE readings (
  id SERIAL PRIMARY KEY,
  reading_date TIMESTAMP NOT NULL,
  kwh_value NUMERIC(10,2) NOT NULL,
  contract_id INTEGER REFERENCES contracts(id)
)
```

## ⚙️ Como Executar

### 1. Clonar o Repositório

```bash
git clone <repo-url>
cd n8n-test
```

### 2. Subir os serviços com Docker

```bash
docker compose up -d
```

### 3. Executar workflow de inserção de dados

1. Entrar no ambiente do n8n containerizado através do link http://localhost:5678/
2. Preencher dados para login (pode preencher quaisquer valores, por exemplo teste@gmail.com e Teste123)
3. Importar workflow inserts_workflow.json, presentes na pasta /workflows na raiz do projeto
4. É possível que nos steps de Postgresql, seja necessário criar as credenciais para conexão no banco de dados. Basta usar as credenciais conforme imagem (a senha é 'postgres')
![Conexão com o banco](db_connection.png)
5. Executar workflow para inserir dados presentes nos arquivos csv

### 4. Executar workflow principal
1. Ainda no ambiente do n8n containerizado, criar outro workflow, importando o arquivo main_workflow.json
2. Da mesma forma que no step anterior, é possível seja necessário criar as credenciais para conexão no banco de dados. Basta usar as credenciais conforme imagem (a senha é 'postgres')
![Conexão com o banco](db_connection.png)
3. Basta agora executar o workflow através do webhook configurado e receber o resultado no formato json

## 🔎 Lógica de Detecção de Outliers

Para a detecção dos outliers foi utilizado o Z-score, uma medida estatística que indica quantos desvios padrão um valor está acima ou abaixo da média.

1. O SQL (`main_workflow.sql`) calcula a média de consumo dos últimos 3 meses por cliente.
2. Um script Python (`main_workflow.py`) calcula o desvio padrão e classifica o consumo como `normal` ou `outlier` usando um limiar de 2 desvios.

## ✅ Exemplo de Saída (JSON)

```json
[
  {
    "clientName": "Cliente 82",
    "avgConsumption": "410.44",
    "consumptionStatus": "outlier"
  },
  {
    "clientName": "Cliente 61",
    "avgConsumption": "312.90",
    "consumptionStatus": "normal"
  },
  {
    "clientName": "Cliente 25",
    "avgConsumption": "311.52",
    "consumptionStatus": "normal"
  }
]
```