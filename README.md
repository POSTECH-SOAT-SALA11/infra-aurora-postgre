# Repositório Terraform - Configuração de RDS

Este repositório contém o código Terraform para provisionar um banco de dados RDS na AWS, gerenciar credenciais via Secrets Manager e criar a infraestrutura necessária, como o grupo de sub-rede de banco de dados.

## Estrutura dos Arquivos

- **data.tf**: Contém as definições de dados para a seleção da VPC e das sub-redes utilizadas pelo RDS.
- **rds.tf**: Inclui as configurações principais para o provisionamento do RDS, o Secrets Manager e a criação das políticas de IAM associadas.

## Recursos Provisionados

### AWS RDS (PostgreSQL)
- Um banco de dados PostgreSQL utilizando a versão 15, com:
  - Armazenamento alocado de 10 GB.
  - Acesso público habilitado.
  - Criação de backup automatizada com retenção de 30 dias.

### Secrets Manager
- Armazenamento seguro das credenciais do banco de dados (usuário e senha) no AWS Secrets Manager.
- Política de IAM permitindo o acesso às credenciais armazenadas.

### Grupo de Sub-redes (DB Subnet Group)
- Um grupo de sub-redes para o banco de dados, utilizando duas sub-redes específicas.

### Strings Aleatórias
- Geração de um nome de usuário e senha aleatórios para o banco de dados, utilizando o provedor `random_string`.

## Variáveis

- `aws-region`: Define a região da AWS onde os recursos serão provisionados. O padrão é `sa-east-1`.

## Saídas (Outputs)

- `secrets_policy`: ARN da política do Secrets Manager criada.
- `secrets_id`: ID do segredo armazenado no Secrets Manager.

## Backend

O estado do Terraform é armazenado em um bucket S3:
- **Bucket**: `tfstate-6soat`
- **Chave**: `terraform-rds/terraform.tfstate`
- **Região**: `sa-east-1`

## Requisitos

- Terraform v1.0 ou superior.
- Provedor AWS v4.65 ou superior.
