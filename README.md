# Infraestrutura AWS para Casino Online com Terraform

Este repositório contém o código Terraform para provisionar a infraestrutura completa de uma "Operação de Casino Online" na AWS. O projeto foi desenvolvido como parte de um desafio técnico para Engenheiro Cloud , com foco na aplicação de boas práticas de segurança, escalabilidade, alta disponibilidade e organização de código (Infrastructure as Code).

## Visão Geral da Arquitetura

A infraestrutura foi projetada para ser robusta e segura, utilizando uma arquitetura de microserviços distribuída em múltiplas Zonas de Disponibilidade (AZs) para garantir alta disponibilidade.

### Os componentes principais da arquitetura são:

**Região da AWS:** ca-central-1 (Canadá).

**Rede (VPC):** Duas VPCs conectadas via VPC Peering:

**VPC Principal:** Hospeda as aplicações, APIs e serviços públicos.

**VPC Secundária:** Dedicada à bodega de dados (banco de dados histórico).

**Sub-redes:** Sub-redes públicas e privadas distribuídas em pelo menos duas AZs para alta disponibilidade.

### Gateways:

**Internet Gateway (IGW):** Para permitir acesso de e para a internet na VPC principal.

**NAT Gateway com Elastic IP:** Para permitir que instâncias em sub-redes privadas acessem a internet de forma segura para atualizações e patches.

### Balanceamento de Carga:

**Application Load Balancer (ALB):** Gerencia todo o tráfego de entrada da internet, distribuindo-o para os servidores de aplicação. Utiliza um certificado SSL/TLS do AWS Certificate Manager (ACM).

**Servidores de Aplicação (EC2):** Instâncias EC2 localizadas em sub-redes privadas para os seguintes microserviços:

- frontsite 
- backoffice
- webapi
- gameapi

### Bancos de Dados:

**RDS (Transacional):** Na VPC Principal para as operações do dia a dia.

**RDS ou Redshift (Bodega de Dados):** Na VPC Secundária para dados históricos e análises.

**Cache:** Amazon ElastiCache for Redis para diminuir a latência e melhorar o desempenho das aplicações.

### CDN e Armazenamento:

**Amazon S3:** Para armazenar conteúdo estático como imagens e assets.

**Amazon CloudFront:** Atua como CDN para distribuir o conteúdo estático do S3 globalmente e com baixa latência.

## Destaques de Segurança

A segurança é um pilar fundamental deste projeto, seguindo o princípio do menor privilégio.

**Isolamento de Rede:** Uso rigoroso de Security Groups e Network ACLs para isolar as camadas de balanceador, EC2, Redis e bancos de dados.

**Acesso Privado ao S3:** O bucket S3 que armazena o conteúdo estático é configurado como privado. O acesso é permitido exclusivamente para o CloudFront através de um Origin Access Control (OAC), garantindo que o conteúdo não possa ser acessado diretamente.

**VPC Endpoints:** Para aumentar a segurança e reduzir custos de transferência de dados, foram implementados VPC Endpoints:

**Endpoint Gateway para S3:** Permite que as instâncias EC2 acessem o S3 sem passar pela internet pública.

**Endpoint Interface para Secrets Manager:** Garante que as credenciais e segredos sejam acessados de forma privada pelas aplicações.

**Criptografia:** O bucket S3 possui criptografia SSE-S3 habilitada para proteger os dados em repouso.

### Monitoramento e Logs

Para garantir a observabilidade e a capacidade de auditoria, a seguinte estrutura de monitoramento foi implementada:

**CloudWatch Log Groups:** Grupos de logs centralizados para coletar logs das instâncias EC2 e das aplicações.

**ALB Access Logs:** Os logs de acesso do Application Load Balancer são ativados e armazenados no S3 ou CloudWatch, permitindo a análise detalhada de todo o tráfego HTTP/HTTPS.

## Estrutura do Projeto

O código Terraform está organizado de forma modular para promover a reutilização e a fácil manutenção.

├── main.tf           # Arquivo principal que orquestra os módulos
├── variables.tf      # Variáveis de entrada para customização
├── outputs.tf        # Saídas da infraestrutura (ex: DNS do ALB)
├── network.tf        # Módulo de rede (VPCs, Sub-redes, Gateways, Peering)
├── instances.tf      # Módulo das instâncias EC2 e Target Groups
├── s3.tf             # Módulo do bucket S3 para conteúdo estático
├── cloudfront.tf     # Módulo da distribuição CloudFront com OAC
├── endpoints.tf      # Módulo dos VPC Endpoints
└── monitoring.tf     # Módulo de monitoramento (CloudWatch Logs)

## Como Implantar a Infraestrutura

**Pré-requisitos**

**Conta AWS:** Acesso a uma conta AWS com as permissões necessárias.

**Terraform:** Terraform CLI instalado (versão 1.0.0 ou superior).

**AWS CLI:** AWS CLI instalado e configurado com suas credenciais (aws configure).

## Passos para a Implantação

Clonar o repositório:

```
git clone [repositorio]
cd [nome-do-repositorio]
```
Inicializar o Terraform: Este comando inicializa o diretório de trabalho e baixa os provedores necessários.

```
terraform init
```

Planejar a implantação: O Terraform irá gerar um plano de execução mostrando quais recursos serão criados. É altamente recomendado revisar este plano antes de aplicar.

```
terraform plan
```

Aplicar as configurações: Este comando provisionará todos os recursos definidos nos arquivos .tf.

```
terraform apply
```

Digite yes quando solicitado para confirmar a criação da infraestrutura.

Destruir a infraestrutura: Para remover todos os recursos criados por este projeto e evitar custos, execute:

```
terraform destroy
```

## Entregáveis Adicionais

Conforme solicitado no desafio, este projeto inclui:

**Código Terraform Completo:** Todos os arquivos .tf necessários para provisionar a infraestrutura.

**Diagrama de Arquitetura:** O diagrama visualiza todos os componentes descritos, incluindo as VPCs, o peering, os serviços e os fluxos de comunicação.

**Estimativa de Custos Mensal:** Uma análise detalhada dos custos mensais estimados para a execução desta infraestrutura na AWS, com base nos serviços provisionados.
