# Relatório de Implementação: API Serverless de Conversão de Temperatura

**Disciplina**: Prática Integradora - Computação em Nuvem
**Autor**: João Guilherme
**Data**: 16 de março de 2026

---

## 1. Introdução

Este relatório documenta a implementação de uma API serverless para conversão de temperatura entre as escalas Celsius, Fahrenheit e Kelvin, utilizando AWS Lambda e API Gateway.

**Funcionalidades implementadas:**
- Conversão de temperatura entre 3 escalas (Celsius, Fahrenheit, Kelvin)
- Integração com API Open-Meteo para obter temperatura de Belo Horizonte automaticamente
- Endpoint HTTP público acessível via REST API

**Objetivos:**
- Implementar função Lambda em Python para conversões de temperatura
- Expor a função como endpoint HTTP via API Gateway
- Integrar com API meteorológica externa (Open-Meteo)
- Provisionar infraestrutura usando Terraform (Infrastructure as Code)

### Por Que Terraform?

Optei por usar Terraform em vez da interface AWS porque:
- **Reprodutibilidade**: Mesmo código recria infraestrutura idêntica
- **Versionamento**: Código em Git com histórico de mudanças
- **Documentação automática**: Arquivos `.tf` documentam a infraestrutura
- **Automação**: Possibilita CI/CD e deployment automatizado
- **Profissionalismo**: Abordagem usada em ambientes reais de produção

## 2. Arquitetura da Solução

### Componentes

```
Cliente

API Gateway (HTTP API) → /convert?celsius=25

AWS Lambda Function (Python 3.12)
    ├─ Conversão: Celsius → Fahrenheit, Kelvin
    └─ Se sem parâmetro: busca temperatura de BH via Open-Meteo API
CloudWatch Logs (monitoramento)
```

### Fluxos de Processamento

**Cenário 1 - Com parâmetro**:
```
Cliente → API Gateway → Lambda → Converte → Retorna JSON
```

**Cenário 2 - Sem parâmetro**:
```
Cliente → API Gateway → Lambda → Open-Meteo API → Converte → Retorna JSON
```

### Tecnologias

- **AWS Lambda**: Python 3.12, 128MB RAM, 10s timeout
- **API Gateway**: HTTP API com CORS habilitado
- **CloudWatch**: Logs e monitoramento
- **IAM**: Roles e permissões
- **Open-Meteo**: API meteorológica gratuita
- **Terraform**: Provisionamento de infraestrutura

### Estrutura do Projeto

```
pensar-responder-02/
├── src/
│   └── lambda_function.py          # Código da função Lambda
├── terraform/
│   ├── main.tf                     # Recursos de infraestrutura
│   ├── variables.tf                # Variáveis de configuração
│   ├── outputs.tf                  # Outputs após deployment
│   └── lambda_function.zip         # Gerado automaticamente
├── RELATORIO.md                    # Este documento
└── README.md                       # Visão geral do projeto
```

---

## 3. Implementação

### Função Lambda (src/lambda_function.py)

**Funções principais:**
- `get_belo_horizonte_temperature()`: Busca temperatura via Open-Meteo
- `celsius_to_fahrenheit()`: F = (C × 9/5) + 32
- `celsius_to_kelvin()`: K = C + 273.15
- `lambda_handler()`: Processa requisições e coordena conversões

**Tratamento de erros:**
- HTTP 400: Parâmetro inválido
- HTTP 503: API meteorológica indisponível
- HTTP 500: Erros inesperados
- Timeout: 5s para chamadas externas

### Recursos Terraform Criados

1. IAM Role (permissões de execução)
2. Lambda Function (Python 3.12, 128MB, 10s timeout)
3. API Gateway HTTP API (endpoint público)
4. Integration (conecta API Gateway ao Lambda)
5. Route (GET /convert)
6. Stage (deployment)
7. Lambda Permission (autorização)
8. CloudWatch Log Groups (logs)

### Deployment

```bash
cd terraform
terraform init    # Inicializa Terraform
terraform plan    # Preview das mudanças
terraform apply   # Cria infraestrutura (30-60s)
terraform output  # Mostra URL da API
```

## 4. Conclusão

A implementação da API serverless de conversão de temperatura foi concluída com sucesso, atendendo a todos os requisitos funcionais e não funcionais. A infraestrutura foi provisionada usando Terraform, garantindo reprodutibilidade e automação.
