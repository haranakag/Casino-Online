# Notas e suposições utilizadas na estimativa

Para obter estes números, fiz algumas suposições baseadas em um cenário de aplicação com tráfego moderado e alta disponibilidade, conforme o desafio:

Região: Todos os preços correspondem à região ca-central-1 (Canadá), como especificado no documento.

EC2: O desafio requer 4 aplicações (frontsite, backoffice, webapi, gameapi) em alta disponibilidade. Assumi que isso significa 2 instâncias por aplicação (uma em cada uma das 2 zonas de disponibilidade), para um total de 8 instâncias. O tipo t3.medium foi escolhido como um ponto de partida equilibrado.

RDS: Utilizei uma instância db.t3.medium em modo Multi-AZ para alta disponibilidade, com 100 GB de armazenamento SSD (gp3).

NAT Gateway: O custo inclui a tarifa por hora e uma estimativa de 50 GB de dados processados para atualizações do sistema e chamadas de API externas.

CloudFront e S3: A maior parte do custo vem da transferência de dados do CloudFront para os usuários. Calculei um volume considerável (1 Terabyte) para uma aplicação como a de um cassino online. O custo de armazenamento no S3 é relativamente baixo.

VPC Endpoints: O endpoint de gateway para S3 é gratuito. O custo vem do endpoint de interface para Secrets Manager, que é cobrado por hora e por AZ.

Serviços gratuitos ou de baixo custo: Muitas das funcionalidades da sua lista não têm um custo direto significativo ou estão incluídas no nível gratuito da AWS. Isso inclui:

VPC, sub-redes, tabelas de rotas, gateway de Internet, VPC peering.

Grupos de segurança, funções IAM, políticas de bucket S3, OAC do CloudFront.

O custo dos target groups e listeners está incluído no custo do ALB.

Para otimizar estes custos no futuro, poderia considerar o uso de Instâncias Reservadas ou Savings Plans para EC2 e RDS, que podem oferecer descontos de até 60-70% em comparação com os preços sob demanda utilizados nesta estimativa.

| Serviço | Descrição | Custo Mensal Estimado (USD) |
| :--- | :--- | :--- |
| **EC2** | 8 instâncias (`t3.medium`) em alta disponibilidade (2 por aplicação em 2 AZs) | ~$292.00 |
| **RDS** | 1 instância (`db.t3.medium`) Multi-AZ com 100 GB de armazenamento | ~$159.00 |
| **ALB** | 1 balanceador de carga ativo, incluindo processamento de dados (LCU) | ~$25.00 |
| **NAT Gateway** | 1 instância com IP elástico e processamento de 50 GB de dados | ~$39.00 |
| **S3 + CloudFront** | 50 GB no S3 + 1 TB de tráfego de saída do CloudFront | ~$90.00 |
| **VPC Endpoints** | 1 Endpoint de Interface para Secrets Manager em 2 AZs (S3 é gratuito) | ~$18.00 |
| **CloudWatch Logs** | Ingestão e armazenamento de aproximadamente 10 GB de logs mensais | ~$5.00 |
| **Total Estimado** | | **~$628.00** |
