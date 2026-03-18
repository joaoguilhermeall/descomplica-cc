# Pensar e Responder 03 - Banco de Dados MySQL na AWS RDS

Implementação de uma instância pública de banco de dados MySQL na AWS RDS usando Terraform para um projeto de aprendizado de inglês.

## 📋 Descrição

Este projeto provisiona automaticamente uma instância MySQL 8.0 na AWS RDS com uma tabela para armazenar frases em inglês e português, organizadas por nível de dificuldade (fácil, média, difícil) e controle de revisão.

## 🎯 Objetivos

- Compreender recursos e ferramentas de bancos de dados em nuvem
- Praticar provisionamento de infraestrutura com Terraform (IaC)
- Implementar um banco de dados relacional para aplicação real
- Aplicar boas práticas de automação e versionamento

## 🏗️ Arquitetura

```
AWS RDS MySQL 8.0.35
├── Instance: db.t3.micro (Free Tier)
├── Storage: 20GB GP2
├── Database: english_learning
└── Table: frases
    ├── id (INT PRIMARY KEY)
    ├── frase_ingles (VARCHAR)
    ├── frase_portugues (VARCHAR)
    ├── revisada_em (DATETIME)
    ├── dominio (ENUM: facil/media/dificil)
    ├── criada_em (TIMESTAMP)
    └── atualizada_em (TIMESTAMP)
```

## 📁 Estrutura do Projeto

```
pensar-responder-03/
├── terraform/
│   └── main.tf          # Configuração completa da infraestrutura
├── sql/
│   └── schema.sql       # Schema do banco de dados
├── RELATORIO.md         # Documentação técnica detalhada
└── README.md            # Este arquivo
```

## 🔧 Pré-requisitos

- [AWS CLI](https://aws.amazon.com/cli/) configurado com credenciais válidas
- [Terraform](https://www.terraform.io/) >= 1.0
- Cliente MySQL (`mysql-client` ou MySQL Workbench)
- Conta AWS (Free Tier é suficiente)

## 🚀 Como Usar

### 1. Provisionar a Infraestrutura

```bash
# Navegar até o diretório do Terraform
cd terraform

# Inicializar o Terraform
terraform init

# Visualizar o plano de execução
terraform plan

# Criar os recursos na AWS (leva ~5-10 minutos)
terraform apply
# Digite 'yes' quando solicitado
```

### 2. Obter Credenciais de Acesso

```bash
# Exibir todos os outputs
terraform output

# Exibir a senha (sensível)
terraform output db_password
```

Anote o **endpoint**, **usuário** (admin) e **senha** gerada.

### 3. Conectar ao Banco de Dados

```bash
# Conectar via MySQL CLI
mysql -h <ENDPOINT_ADDRESS> -u admin -p
# Digite a senha quando solicitado
```

### 4. Executar o Schema

```bash
# Executar o schema SQL a partir do terminal
mysql -h <ENDPOINT_ADDRESS> -u admin -p english_learning < ../sql/schema.sql

# OU dentro do MySQL prompt:
USE english_learning;
SOURCE ../sql/schema.sql;
```

### 5. Validar a Instalação

```bash
# Verificar tabela e dados
mysql -h <ENDPOINT_ADDRESS> -u admin -p -e "USE english_learning; SELECT * FROM frases;"
```

Você deve ver 5 frases de exemplo.

### 6. Destruir os Recursos ⚠️

**IMPORTANTE**: Após concluir a atividade, destrua os recursos para evitar cobranças:

```bash
cd terraform
terraform destroy
# Digite 'yes' para confirmar
```

## 📊 Recursos Terraform Criados

| Recurso | Tipo | Descrição |
|---------|------|-----------|
| `random_password` | Random | Senha aleatória de 16 caracteres |
| `aws_security_group` | Security | Permite tráfego MySQL (porta 3306) |
| `aws_db_instance` | RDS | Instância MySQL 8.0.35 (db.t3.micro) |

## 🔐 Segurança

⚠️ **Aviso**: Esta configuração permite acesso público de qualquer IP (0.0.0.0/0) **apenas para fins educacionais**.

Em ambientes de produção:
- Restrinja o security group a IPs específicos
- Use VPCs privadas e VPN/Bastion Host
- Habilite SSL/TLS para conexões
- Configure backups e retenção adequada
- Use AWS Secrets Manager para credenciais

## 💰 Custos

Este projeto foi projetado para o **AWS Free Tier**:
- ✅ 750 horas/mês de instâncias db.t3.micro
- ✅ 20GB de armazenamento GP2
- ✅ Free Tier válido por 12 meses

**Importante**: Sempre execute `terraform destroy` após o uso para garantir que não haverá cobranças inesperadas.

## 📝 Respostas das Perguntas da Atividade

### a) Na sua visão, porque os bancos de dados são importantes?

Bancos de dados são fundamentais porque organizam grandes volumes de informações de forma estruturada, permitindo consultas rápidas e eficientes. Eles garantem integridade, consistência e segurança dos dados, além de possibilitarem operações complexas como buscas, relacionamentos e transações. Na era digital, com a explosão de dados gerados por aplicações, IoT e comércio eletrônico, bancos de dados são a espinha dorsal de praticamente todos os sistemas modernos.

### b) Para qual aplicação você utilizaria o seu banco de dados gratuito na AWS RDS?

Utilizaria este banco de dados para uma aplicação web/móvel de **aprendizado de inglês pessoal**, onde posso:
- Cadastrar frases que encontro em livros, filmes e conversas
- Classificar por nível de dificuldade para revisar progressivamente
- Acompanhar quais frases já foram revisadas
- Implementar algoritmos de repetição espaçada (spaced repetition)
- Exportar dados para outros sistemas de estudo
- Praticar desenvolvimento full-stack conectando backend (Node.js/Python) ao banco

## 📚 Documentação Adicional

Para documentação técnica completa, incluindo detalhes de implementação e aprendizados, consulte [RELATORIO.md](RELATORIO.md).

## 👤 Autor

**João Guilherme**
Disciplina: Prática Integradora - Computação em Nuvem
Data: 17 de março de 2026

## 📄 Licença

Este projeto é parte de uma atividade acadêmica para fins educacionais.
