# Relatório de Implementação: Backup no Amazon S3 com Versionamento

**Disciplina**: Prática Integradora - Computação em Nuvem
**Autor**: João Guilherme
**Data**: 17 de março de 2026

---

## 1. Introdução

Esta atividade consiste na configuração de um bucket S3 na AWS com versionamento ativado para simular uma rotina de backup, demonstrando como esse recurso mitiga ataques do tipo ransomware. O versionamento de objetos no S3 permite manter múltiplas versões de um mesmo arquivo, possibilitando a recuperação de versões anteriores em caso de sobrescrita acidental ou ataque malicioso.

O provisionamento da infraestrutura foi realizado utilizando Terraform, uma ferramenta de Infrastructure as Code (IaC), seguindo as boas práticas adotadas em projetos anteriores desta disciplina. Após a criação do bucket, foram realizadas operações via AWS CLI para validar o funcionamento do versionamento.

A implementação demonstra conceitos fundamentais de segurança na nuvem, incluindo backup automatizado, recuperação de desastres e proteção contra ransomware - ameaça crescente que criptografa dados e exige resgate para liberá-los.

---

## 2. Implementação

### Estrutura do Projeto

A implementação foi organizada da seguinte forma:

```
pensar-responder-04/
├── terraform/
│   └── main.tf                     # Configuração Terraform do bucket S3
├── backup_v1.zip                   # Arquivo de backup versão 1 (exemplo)
├── backup_v2.zip                   # Arquivo de backup versão 2 (exemplo)
└── RELATORIO.md                    # Este documento
```

### Recursos Terraform Criados

O arquivo `terraform/main.tf` provisiona os seguintes recursos na AWS:

1. **aws_s3_bucket** (`backup_bucket`)
   - Nome: `bucketbackup2025`
   - Região: `sa-east-1` (São Paulo)
   - Bucket para armazenamento de backups com nomenclatura única global

2. **aws_s3_bucket_versioning** (`backup_versioning`)
   - Status: `Enabled`
   - Habilita o versionamento automático de todos os objetos
   - Equivalente ao passo 12 da atividade proposta
   - Permite recuperação de versões anteriores e proteção contra exclusão acidental

### Configuração de Versionamento

O versionamento no S3 funciona da seguinte forma:

- Cada objeto enviado para o bucket recebe um ID de versão único
- Ao sobrescrever um arquivo existente, a versão antiga é preservada
- É possível listar todas as versões de um objeto
- Versões antigas podem ser restauradas a qualquer momento
- Proteção contra exclusão: ao "deletar" um arquivo, apenas uma marca de exclusão é criada, mantendo todas as versões

---

## 3. Como Fazer o Deploy e Testar

### Pré-requisitos

- AWS CLI configurado com credenciais válidas (`aws configure`)
- Terraform instalado (versão >= 1.0)
- Arquivos de backup de exemplo criados (ou use arquivos de teste)

### Passo 1: Criar Arquivos de Teste

Crie dois arquivos de backup para simular versionamento:

```bash
cd pensar-responder-04
echo "Backup version 1" > backup_v1.txt
zip backup_v1.zip backup_v1.txt
echo "Backup version 2 - updated content" > backup_v2.txt
zip backup_v2.zip backup_v2.txt
```

### Passo 2: Inicializar Terraform

Navegue até o diretório do Terraform e inicialize os providers:

```bash
cd terraform
terraform init
```

Este comando baixa o provider AWS necessário e prepara o ambiente.

### Passo 3: Visualizar o Plano de Execução

Antes de criar recursos, visualize o que será criado:

```bash
terraform plan
```

Você verá 2 recursos a serem criados:
- 1 bucket S3 (`bucketbackup2025`)
- 1 configuração de versionamento

### Passo 4: Criar a Infraestrutura

Execute o apply para provisionar os recursos na AWS:

```bash
terraform apply
```

Digite `yes` quando solicitado para confirmar. O processo leva aproximadamente 1-2 minutos.

**Equivalente ao passo 12 da atividade**: O versionamento é ativado automaticamente pelo Terraform.

### Passo 5: Verificar Bucket Criado

Liste os buckets S3 para confirmar a criação:

```bash
aws s3 ls
```

Você deve ver `bucketbackup2025` na listagem.

### Passo 6: Enviar Primeira Versão do Backup

Envie o primeiro arquivo de backup via AWS CLI:

```bash
cd ..
aws s3 cp backup_v1.zip s3://bucketbackup2025/
```

Saída esperada: `upload: ./backup_v1.zip to s3://bucketbackup2025/backup_v1.zip`

### Passo 7: Enviar Segunda Versão (Sobrescrita)

Envie o segundo arquivo com o **mesmo nome** para criar uma nova versão:

```bash
aws s3 cp backup_v2.zip s3://bucketbackup2025/backup_v1.zip
```

Note que estamos enviando `backup_v2.zip` mas salvando como `backup_v1.zip` no bucket, simulando uma atualização do mesmo arquivo de backup.

### Passo 8: Listar Versões do Objeto

Verifique que ambas as versões foram preservadas:

```bash
aws s3api list-object-versions --bucket bucketbackup2025
```

**Equivalente ao passo 17 da atividade**: O comando retorna JSON com duas versões do arquivo, cada uma com:
- `VersionId`: ID único da versão
- `LastModified`: Timestamp de quando foi criada
- `Size`: Tamanho do arquivo
- `IsLatest`: Indica qual é a versão mais recente

### Passo 9: Recuperar Versão Anterior (Teste de Ransomware)

Para simular recuperação após ataque, baixe a versão original usando o `VersionId`:

```bash
# Copie o VersionId da primeira versão do comando anterior
aws s3api get-object --bucket bucketbackup2025 --key backup_v1.zip --version-id <VERSION_ID> backup_v1_recuperado.zip
```

Descompacte e verifique que o conteúdo original foi recuperado:

```bash
unzip -p backup_v1_recuperado.zip
```

### Passo 10: Validar Proteção Contra Exclusão

Tente "deletar" o arquivo:

```bash
aws s3 rm s3://bucketbackup2025/backup_v1.zip
```

Liste as versões novamente:

```bash
aws s3api list-object-versions --bucket bucketbackup2025
```

Você verá que todas as versões ainda existem, e uma nova entrada `DeleteMarkers` foi criada. O arquivo pode ser completamente restaurado removendo o marcador de exclusão.

### Passo 11: Destruir os Recursos (IMPORTANTE)

**Após concluir a atividade**, destrua todos os recursos para evitar cobranças:

```bash
# Primeiro, remova todos os objetos e versões do bucket
aws s3api delete-objects --bucket bucketbackup2025 --delete "$(aws s3api list-object-versions --bucket bucketbackup2025 --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

# Depois, destrua a infraestrutura
cd terraform
terraform destroy
```

Digite `yes` para confirmar. Todos os recursos serão removidos da AWS.

---

## 4. Comparativo de Serviços de Armazenamento em Nuvem com Backup

| **Serviço** | **Plano / Preço** | **Recursos Principais** | **Backup / Versionamento** |
|-------------|-------------------|-------------------------|----------------------------|
| **Amazon S3** | Standard<br>~$0,023/GB/mês | Durabilidade 99,999999999%, integração AWS, classes de armazenamento (S3 Glacier), lifecycles | Object Versioning nativo, MFA Delete, Object Lock (WORM) |
| **Google Cloud Storage** | Standard<br>~$0,020/GB/mês | Alta durabilidade (11 noves), integração GCP, classes de armazenamento frio (Nearline, Coldline) | Object Versioning nativo, retenção configurável, Bucket Lock |
| **Azure Blob Storage** | LRS<br>~$0,018/GB/mês | Integração Azure, hot/cool/archive tiers, lifecycle management | Soft Delete + Versioning, até 365 dias de retenção, Immutable storage |
| **Backblaze B2** | ~$0,006/GB/mês | API S3-compatível, baixo custo, 10 GB gratuitos, CDN parceiros (Cloudflare) | File Versioning por 30 dias (plano pago), Lifecycle Rules |

### Serviço Escolhido e Justificativa

Para esta atividade, **Amazon S3** foi escolhido pelos seguintes motivos:

1. **Integração com AWS**: A disciplina já utiliza outros serviços AWS (RDS em atividades anteriores), mantendo consistência no ecossistema
2. **Maturidade e Confiabilidade**: S3 é o serviço de armazenamento em nuvem mais estabelecido e testado do mercado
3. **Recursos Avançados de Segurança**: Oferece Object Lock (compliance mode), MFA Delete e integração nativa com AWS IAM e KMS
4. **Durabilidade**: 99,999999999% (11 noves) de durabilidade anual dos dados

**Alternativas válidas por caso de uso**:
- **Backblaze B2**: Ideal para projetos com orçamento limitado (~70% mais barato que S3), especialmente para armazenamento de longo prazo
- **Google Cloud Storage**: Melhor escolha quando há dependência do ecossistema Google (BigQuery, GKE, análise de dados)
- **Azure Blob Storage**: Preferível para organizações já investidas no ecossistema Microsoft (Azure AD, Office 365)

A escolha final depende do ecossistema já adotado pela organização e dos requisitos específicos de custo, compliance e integração.

---

## 5. Serviços Complementares para Segurança em Nuvem

Além do armazenamento com backup versionado, uma estratégia completa de segurança em nuvem deve incluir:

### Proteção Contra DDoS

- **AWS Shield** / **Azure DDoS Protection** / **Google Cloud Armor**
- Proteção contra ataques de negação de serviço (DDoS)
- Garante disponibilidade das aplicações mesmo sob ataque volumétrico
- Essencial para aplicações públicas e sistemas críticos

### Gerenciamento de Chaves de Criptografia

- **AWS KMS** / **Azure Key Vault** / **Google Cloud KMS**
- Gerenciamento centralizado de chaves de criptografia
- Protege dados em repouso (encryption at rest) e em trânsito (encryption in transit)
- Permite criptografia do lado do servidor para backups no S3
- Auditoria completa de uso de chaves

### Controle de Acesso e Identidade

- **AWS IAM** / **Azure Active Directory** / **Google IAM**
- Controle de acesso baseado em funções (RBAC)
- Princípio do menor privilégio: usuários têm apenas permissões necessárias
- Previne acessos não autorizados que possam comprometer ou excluir backups
- Suporte a autenticação multifator (MFA)

### Auditoria e Monitoramento

- **AWS CloudTrail** / **Azure Monitor** / **Google Cloud Logging**
- Registro de todas as ações realizadas na conta (log de auditoria)
- Permite detectar acessos suspeitos ou alterações em arquivos
- Alertas em tempo real para atividades anômalas
- Essencial para resposta a incidentes como ransomware
- Integração com SIEM (Security Information and Event Management)

### Defesa em Profundidade

Esses serviços, combinados com o backup versionado, formam uma **estratégia de defesa em profundidade**:

1. **Prevenção**: IAM e KMS impedem acessos não autorizados
2. **Detecção**: CloudTrail e Cloud Armor identificam ameaças em tempo real
3. **Resposta**: Versionamento e backups permitem recuperação rápida
4. **Resiliência**: Shield garante disponibilidade durante ataques

O backup garante a recuperação dos dados após um incidente, enquanto os demais serviços atuam na prevenção e detecção precoce de ameaças, minimizando a janela de exposição.

---

## 6. Conclusão

A implementação de backup com versionamento no Amazon S3 foi concluída com sucesso, demonstrando uma técnica fundamental para proteção contra ransomware e outros ataques que comprometem a integridade dos dados. O versionamento automático garante que versões anteriores de arquivos permaneçam acessíveis mesmo após sobrescrita ou exclusão, proporcionando uma camada crítica de resiliência.

**Conhecimentos reforçados:**

1. **AWS S3**: Compreensão prática de armazenamento em nuvem, incluindo versionamento de objetos, gerenciamento de ciclo de vida e configuração de buckets

2. **Terraform**: Continuidade na aplicação de Infrastructure as Code para provisionar recursos de forma reproduzível e versionável

3. **AWS CLI**: Operações avançadas com S3, incluindo listagem de versões, recuperação de objetos específicos e manipulação de metadados

4. **Segurança em Nuvem**: Entendimento de estratégias de backup, recuperação de desastres e mitigação de ransomware através de múltiplas camadas de proteção

5. **Arquitetura de Segurança**: Visão holística de como diferentes serviços (armazenamento, criptografia, controle de acesso, auditoria) se complementam para formar uma defesa robusta

A experiência consolidou o princípio de que **backup não é opcional**, mas sim um componente essencial de qualquer arquitetura em nuvem. O versionamento automático, combinado com políticas adequadas de retenção e teste regular de recuperação, fornece proteção eficaz contra erros humanos, falhas de sistema e ataques maliciosos. A capacidade de recuperar dados rapidamente após um incidente pode significar a diferença entre uma pequena interrupção e uma perda catastrófica de dados.
