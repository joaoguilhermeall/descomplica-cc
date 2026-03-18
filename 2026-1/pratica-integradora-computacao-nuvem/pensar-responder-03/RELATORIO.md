# Relatório de Implementação: Banco de Dados MySQL na AWS RDS

**Disciplina**: Prática Integradora - Computação em Nuvem
**Autor**: João Guilherme
**Data**: 17 de março de 2026

---

## 1. Introdução

Esta atividade consiste na criação de uma instância pública de banco de dados MySQL na nuvem utilizando o serviço AWS RDS (Relational Database Service). O banco de dados foi desenvolvido para armazenar frases e traduções de um projeto pessoal de aprendizado de inglês, organizando o conteúdo por nível de dificuldade e acompanhando o progresso de revisão.

O provisionamento da infraestrutura foi realizado utilizando Terraform, uma ferramenta de Infrastructure as Code (IaC), ao invés do console web da AWS. Esta escolha se justifica pela experiência prévia adquirida em projetos anteriores e pela adoção de boas práticas de DevOps, que proporcionam:

- **Reprodutibilidade**: O mesmo código Terraform pode recriar a infraestrutura de forma idêntica em diferentes ambientes
- **Versionamento**: Todo o código de infraestrutura está versionado no Git, permitindo rastrear mudanças e realizar rollback se necessário
- **Automação**: Possibilita integração com pipelines de CI/CD para deployment automatizado
- **Profissionalismo**: Abordagem amplamente utilizada em ambientes corporativos e projetos reais

A implementação foi mantida simples e direta, consolidando toda a configuração em um único arquivo Terraform, facilitando o aprendizado e a compreensão dos recursos necessários para provisionar um banco de dados na nuvem.

---

## 2. Implementação

### Estrutura do Projeto

A implementação foi organizada da seguinte forma:

```
pensar-responder-03/
├── terraform/
│   └── main.tf                     # Configuração Terraform completa
├── sql/
│   └── schema.sql                  # Schema do banco de dados
├── RELATORIO.md                    # Este documento
└── README.md                       # Guia rápido de uso
```

### Recursos Terraform Criados

O arquivo [terraform/main.tf](terraform/main.tf) provisiona os seguintes recursos na AWS:

1. **random_password** (`db_password`)
   - Gera senha aleatória de 16 caracteres para o banco de dados
   - Sem caracteres especiais para evitar problemas de escape
   - Armazenada no state do Terraform e exibida via output sensível

2. **aws_security_group** (`mysql_sg`)
   - Nome: `english-learning-mysql-sg`
   - Regra de entrada (ingress): Permite conexões TCP na porta 3306 de qualquer origem (0.0.0.0/0)
   - Regra de saída (egress): Permite todo tráfego de saída
   - **Nota**: Acesso público é apenas para fins educacionais; em produção deve-se restringir por IP

3. **aws_db_instance** (`english_learning_db`)
   - Identificador: `english-learning-db`
   - Engine: MySQL 8.0.35
   - Classe de instância: `db.t3.micro` (elegível ao free tier)
   - Armazenamento: 20GB GP2 (SSD)
   - Nome do banco: `english_learning`
   - Usuário: `admin`
   - Senha: Gerada pelo `random_password`
   - Público: `publicly_accessible = true`
   - Backup: Desabilitado (retention = 0)
   - Snapshot final: Desabilitado para facilitar destruição

### Schema do Banco de Dados

O arquivo [sql/schema.sql](sql/schema.sql) define a estrutura do banco:

**Tabela `frases`**:
- `id`: INT AUTO_INCREMENT PRIMARY KEY
- `frase_ingles`: VARCHAR(500) - Frase em inglês
- `frase_portugues`: VARCHAR(500) - Tradução em português
- `revisada_em`: DATETIME - Data da última revisão (nullable)
- `dominio`: ENUM('facil', 'media', 'dificil') - Nível de dificuldade
- `criada_em`: TIMESTAMP - Data de criação automática
- `atualizada_em`: TIMESTAMP - Atualização automática

**Índices**:
- `idx_dominio`: Facilita busca por nível de dificuldade
- `idx_revisada_em`: Facilita busca por frases que precisam revisão

O schema inclui 5 frases de exemplo para teste, distribuídas entre os três níveis de dificuldade.

---

## 3. Como Fazer o Deploy e Testar

### Pré-requisitos

- AWS CLI configurado com credenciais válidas (`aws configure`)
- Terraform instalado (versão >= 1.0)
- Cliente MySQL instalado (`mysql-client` no Linux/Mac ou MySQL Workbench)

### Passo 1: Inicializar Terraform

Navegue até o diretório do Terraform e inicialize os providers:

```bash
cd terraform
terraform init
```

Este comando baixa os providers necessários (AWS e Random) e prepara o ambiente.

### Passo 2: Visualizar o Plano de Execução

Antes de criar recursos, visualize o que será criado:

```bash
terraform plan
```

Você verá 3 recursos a serem criados:
- 1 security group
- 1 instância RDS MySQL
- 1 senha aleatória (random_password)

### Passo 3: Criar a Infraestrutura

Execute o apply para provisionar os recursos na AWS:

```bash
terraform apply
```

Digite `yes` quando solicitado para confirmar. O processo leva aproximadamente 5-10 minutos, pois a criação de instâncias RDS requer tempo para configuração e inicialização.

### Passo 4: Obter Credenciais e Endpoint

Após a conclusão, visualize os outputs do Terraform:

```bash
terraform output
```

Para exibir a senha (que é sensível):

```bash
terraform output db_password
```

Anote:
- **Endpoint**: Endereço para conexão (ex: `english-learning-db.xxxxx.us-east-1.rds.amazonaws.com`)
- **Usuário**: `admin`
- **Senha**: Exibida pelo comando acima
- **Banco**: `english_learning`

### Passo 5: Conectar ao Banco de Dados

Use o cliente MySQL para conectar:

```bash
mysql -h <ENDPOINT_ADDRESS> -u admin -p
```

Digite a senha quando solicitado. Você verá o prompt do MySQL se a conexão for bem-sucedida.

### Passo 6: Executar o Schema

Execute o schema SQL para criar a tabela e inserir dados de exemplo:

```bash
mysql -h <ENDPOINT_ADDRESS> -u admin -p english_learning < ../sql/schema.sql
```

Ou, dentro do prompt do MySQL:

```sql
USE english_learning;
SOURCE ../sql/schema.sql;
```

### Passo 7: Validar a Instalação

Verifique se a tabela foi criada e contém dados:

```bash
mysql -h <ENDPOINT_ADDRESS> -u admin -p -e "USE english_learning; SELECT * FROM frases;"
```

Você deve ver 5 frases de exemplo listadas.

### Passo 8: Destruir os Recursos (IMPORTANTE)

**Após concluir a atividade e capturar o endpoint para entrega**, destrua todos os recursos para evitar cobranças:

```bash
terraform destroy
```

Digite `yes` para confirmar. Todos os recursos serão removidos da AWS, incluindo o banco de dados (sem snapshot final).

---

## 4. Conclusão

A implementação do banco de dados MySQL na AWS RDS foi concluída com sucesso utilizando Terraform como ferramenta de Infrastructure as Code. O projeto demonstrou os benefícios de automatizar o provisionamento de infraestrutura em nuvem, garantindo consistência, rastreabilidade e facilidade de reprodução.

**Conhecimentos reforçados:**

1. **AWS RDS**: Compreensão prática de como provisionar e configurar bancos de dados gerenciados na AWS, incluindo configurações de conectividade, segurança e armazenamento

2. **Terraform**: Aprofundamento no uso de IaC para criar recursos na nuvem de forma declarativa, incluindo gerenciamento de dependências entre recursos (security group → RDS) e uso de recursos auxiliares (random_password)

3. **Segurança na Nuvem**: Entendimento dos conceitos de security groups, controle de acesso público e gerenciamento seguro de credenciais, mesmo que configurado de forma permissiva para fins educacionais

4. **MySQL**: Prática no design de schemas relacionais, definição de tipos de dados apropriados, uso de enums para valores fixos e implementação de índices para otimização de consultas

5. **Boas Práticas DevOps**: Aplicação de princípios de automação, versionamento de infraestrutura e documentação técnica clara

A experiência consolidou o entendimento de que bancos de dados em nuvem oferecem escalabilidade, disponibilidade e facilidade de gerenciamento superiores às soluções on-premises, sendo fundamentais para aplicações modernas. A combinação de serviços gerenciados (RDS) com ferramentas de automação (Terraform) representa o estado da arte em operações de infraestrutura, preparando para cenários profissionais reais.
