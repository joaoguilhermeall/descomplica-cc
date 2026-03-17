# Temperature Converter - AWS Lambda Function

![AWS Lambda](https://img.shields.io/badge/AWS-Lambda-orange?logo=amazon-aws)
![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python)
![Terraform](https://img.shields.io/badge/Terraform-1.0+-purple?logo=terraform)

API serverless para conversão de temperatura entre Celsius, Fahrenheit e Kelvin, com integração meteorológica automatizada para Belo Horizonte.

## 🌟 Funcionalidades

- ✅ **Conversão de Temperatura**: Celsius → Fahrenheit e Kelvin
- 🌤️ **Integração Meteorológica**: Busca automática da temperatura atual de Belo Horizonte
- ☁️ **Serverless**: Escalabilidade automática com AWS Lambda
- 🚀 **API Gateway**: Endpoint HTTP público
- 📊 **Monitoramento**: CloudWatch Logs integrado
- 🔧 **Infrastructure as Code**: Deployment via Terraform

## 🏗️ Arquitetura

```
Cliente → API Gateway → Lambda → [Open-Meteo API]
                          ↓
                    CloudWatch Logs
```

## 📋 Pré-requisitos

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado com credenciais
- Conta AWS (Free Tier suficiente)

## 🚀 Deploy Rápido

```bash
# 1. Clone o repositório
cd pensar-responder-02

# 2. Navegue para o diretório terraform
cd terraform

# 3. Inicialize o Terraform
terraform init

# 4. Faça o deploy
terraform apply
# Digite 'yes' quando solicitado

# 5. Obtenha a URL da API
terraform output api_endpoint
```

## 📖 Uso da API

### Converter temperatura específica

```bash
curl "https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/convert?celsius=25"
```

**Resposta:**
```json
{
  "source": "input",
  "temperature": {
    "celsius": 25.0,
    "fahrenheit": 77.0,
    "kelvin": 298.15
  }
}
```

### Obter temperatura atual de Belo Horizonte

```bash
curl "https://YOUR_API_ID.execute-api.us-east-1.amazonaws.com/convert"
```

**Resposta:**
```json
{
  "source": "belo_horizonte",
  "temperature": {
    "celsius": 23.5,
    "fahrenheit": 74.3,
    "kelvin": 296.65
  },
  "location": {
    "city": "Belo Horizonte",
    "state": "Minas Gerais",
    "country": "Brazil"
  }
}
```

## 📚 Documentação Completa

- **[RELATORIO.md](RELATORIO.md)**: Relatório completo de implementação em português
- **[terraform/README.md](terraform/README.md)**: Guia de deployment detalhado
- **[src/lambda_function.py](src/lambda_function.py)**: Código fonte comentado

## 🧪 Testes

```bash
# Ver logs em tempo real
aws logs tail /aws/lambda/temperature-converter --follow

# Testar com diferentes valores
curl "API_URL/convert?celsius=0"     # Ponto de congelamento
curl "API_URL/convert?celsius=100"   # Ponto de ebulição
curl "API_URL/convert?celsius=-273.15"  # Zero absoluto
```

## 💰 Custo

**$0.00/mês** - Todos os recursos estão cobertos pelo AWS Free Tier:
- Lambda: 1M requisições/mês gratuitas
- API Gateway: 1M requisições/mês gratuitas
- CloudWatch Logs: 5 GB/mês gratuitos

## 🧹 Limpeza

Para remover todos os recursos e evitar custos:

```bash
cd terraform
terraform destroy
# Digite 'yes' para confirmar
```

## 🛠️ Tecnologias

- **AWS Lambda**: Computação serverless
- **API Gateway**: Gerenciamento de API HTTP
- **Python 3.12**: Runtime da função
- **Terraform**: Infrastructure as Code
- **Open-Meteo API**: Dados meteorológicos gratuitos
- **CloudWatch**: Logging e monitoramento

## 📁 Estrutura do Projeto

```
pensar-responder-02/
├── src/
│   └── lambda_function.py      # Código da Lambda
├── terraform/
│   ├── main.tf                 # Recursos AWS
│   ├── variables.tf            # Variáveis
│   ├── outputs.tf              # Outputs
│   └── README.md               # Guia de deployment
├── RELATORIO.md                # Relatório completo
├── README.md                   # Este arquivo
└── requirements.txt            # Dependências Python
```

## 🎓 Contexto Acadêmico

Este projeto foi desenvolvido para a disciplina **Prática Integradora - Computação em Nuvem** do curso de Ciência da Computação da Faculdade Descomplica, demonstrando:

- Arquitetura serverless
- Infrastructure as Code
- Integração de APIs
- DevOps e automação
- Boas práticas de desenvolvimento em nuvem

## 📝 Licença

Este projeto é de uso educacional.

## 👤 Autor

**João Guilherme**
Faculdade Descomplica - Ciência da Computação

---

**Para documentação detalhada, consulte [RELATORIO.md](RELATORIO.md)**
