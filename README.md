# Infraestrutura AWS para Casinos Online com Terraform

Este repositório contém o código Terraform para provisionar a infraestrutura completa para uma "Operação de Casino Online" na AWS. O projeto foi desenvolvido como parte de um desafio técnico para um engenheiro de nuvem, focando na aplicação das melhores práticas de segurança, escalabilidade, alta disponibilidade e organização de código (Infraestrutura como Código).

## Descrição arquitetural

![Arquitetura](Reto%20Ingeniero%20Cloud.drawio.png)
A infraestrutura é projetada para ser robusta e segura, utilizando uma arquitetura de microsserviços distribuída em múltiplas zonas de disponibilidade (AZ) para garantir alta disponibilidade.

### Os principais componentes da arquitetura são:

**Região da AWS:** ca-central-1 (Canadá).

**Rede (VPC):** Duas VPCs conectadas via VPC Peering:

**VPC Principal:** Hospeda aplicações, APIs e serviços públicos.

**VPC Secundária:** Dedicada ao armazenamento de dados (banco de dados histórico).

**Sub-redes:** Sub-redes públicas e privadas distribuídas em pelo menos duas zonas de disponibilidade (AZ) para alta disponibilidade.

### Gateways:

Internet Gateway (IGW): Permite acesso de e para a internet na VPC principal.

NAT Gateway com IP Elástico: Permite que instâncias em sub-redes privadas acessem a internet de forma segura para obter atualizações e patches.

Balanceamento de Carga:

Application Load Balancer (ALB): Gerencia todo o tráfego de entrada da internet e o distribui para os servidores de aplicação. Utiliza um certificado SSL/TLS do AWS Certificate Manager (ACM).

Servidores de Aplicação (EC2): Instâncias EC2 localizadas em sub-redes privadas para os seguintes microsserviços:

- frontsite
- backoffice
- webapi
- gameapi

### Bancos de Dados:

RDS (Transacional): Na VPC principal para operações diárias.

RDS ou Redshift (Data Vault): Na VPC secundária para dados históricos e análises.

Cache: Amazon ElastiCache para Redis para reduzir a latência e melhorar o desempenho das aplicações.

### CDN e Armazenamento:

Amazon S3: Para armazenar conteúdo estático, como imagens e recursos.

Amazon CloudFront: Atua como CDN para distribuir conteúdo estático do S3 globalmente e com baixa latência.

## Destaques de Segurança

A segurança é um pilar fundamental deste projeto, seguindo o princípio do menor privilégio.

**Isolamento de Rede:** Uso estrito de grupos de segurança e listas de controle de acesso (ACL) de rede para isolar as camadas do balanceador de carga, EC2, Redis e banco de dados.

**Acesso Privado ao S3:** O bucket S3 que armazena conteúdo estático é configurado como privado. O acesso é concedido exclusivamente ao CloudFront através do controle de acesso de origem (OAC), garantindo que o conteúdo não possa ser acessado diretamente.

**VPC Endpoints:** Para aumentar a segurança e reduzir custos de transferência de dados, foram implementados VPC Endpoints:

**Gateway Endpoint para S3:** Permite que instâncias EC2 acessem o S3 sem precisar acessar a rede pública de internet.

**Interface Endpoint para Secrets Manager:** Garante que as aplicações acessem credenciais e segredos de forma privada.

**Criptografia:** O bucket S3 tem criptografia SSE-S3 habilitada para proteger dados em repouso.

### Monitoramento e Logs

Para garantir observabilidade e auditabilidade, o seguinte framework de monitoramento foi implementado:

CloudWatch Log Groups: Grupos de logs centralizados para coletar logs de instâncias EC2 e aplicações.

ALB Access Logs: Logs de acesso do Application Load Balancer (ALB) são habilitados e armazenados no S3 ou CloudWatch, permitindo análise detalhada de todo o tráfego HTTP/HTTPS.

## Estrutura do Projeto

O código Terraform é organizado de forma modular para facilitar reutilização e manutenção.

```
.
├── main.tf          # Orquestra os módulos
├── variables.tf     # Variáveis de entrada
├── outputs.tf       # Saídas da infraestrutura
├── network.tf       # Módulo de rede (VPC, sub-redes, etc.)
├── instances.tf     # Módulo de instâncias EC2
├── s3.tf            # Módulo de bucket S3
├── cloudfront.tf    # Módulo de distribuição CloudFront
├── endpoints.tf     # Módulo de endpoints da VPC
└── monitoring.tf    # Módulo de monitoramento (CloudWatch)
```

## Como implementar a infraestrutura

**Pré-requisitos**

**Conta AWS:** Acesso a uma conta AWS com as permissões necessárias.

**Terraform:** Terraform CLI instalado (versão 1.0.0 ou superior).

**AWS CLI:** AWS CLI instalado e configurado com suas credenciais (aws configure).

## Passos de Implementação

Clonar o repositório:

```
git clone https://github.com/haranakag/Casino-Online.git
cd Casino-Online
```
Inicializar Terraform: este comando inicializa o diretório de trabalho e baixa os provedores necessários.

```
terraform init
```

Planejar a implementação: Terraform gerará um plano de execução mostrando os recursos que serão criados. Recomenda-se revisar este plano antes de aplicar.

```
terraform plan
```

Aplicar configuração: este comando provisionará todos os recursos definidos nos arquivos .tf.

```
terraform apply
```

Digite "Yes" quando solicitado para confirmar a criação da infraestrutura.

Destruir a infraestrutura: Para remover todos os recursos criados por este projeto e evitar custos, execute:

```
terraform destroy
```

## Entregáveis Adicionais

Como solicitado no desafio, este projeto inclui:

**Código Terraform Completo:** Todos os arquivos .tf necessários para provisionar a infraestrutura.

**Diagrama de Arquitetura:** O diagrama visualiza todos os componentes descritos, incluindo VPC, peering, serviços e fluxos de comunicação.

**[Estimativa de Custo Mensal:](Costos.md)** Um detalhamento dos custos mensais estimados para executar esta infraestrutura na AWS, com base nos serviços provisionados.
