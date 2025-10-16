# Notas e Premissas Usadas na Estimativa

Para chegar a esses números, fiz algumas suposições baseadas em um cenário de aplicação com tráfego moderado e alta disponibilidade, conforme o desafio:

Região: Todos os preços são para a região ca-central-1 (Canadá), como especificado no documento.

EC2: O desafio pede 4 aplicações (frontsite, backoffice, webapi, gameapi) em alta disponibilidade. Assumi que isso significa 2 instâncias por aplicação (uma em cada uma das 2 Zonas de Disponibilidade), totalizando 8 instâncias. O tipo t3.medium foi escolhido como um ponto de partida balanceado.

RDS: Utilizei uma instância db.t3.medium em modo Multi-AZ para alta disponibilidade, com 100 GB de armazenamento SSD (gp3).

NAT Gateway: O custo inclui a taxa por hora e uma estimativa de 50 GB de dados processados para atualizações de sistema e chamadas a APIs externas.

CloudFront & S3: A maior parte do custo aqui vem da transferência de dados do CloudFront para os usuários. Estimei um volume considerável (1 Terabyte) para uma aplicação como um casino online. O custo de armazenamento no S3 é relativamente baixo.

VPC Endpoints: O Endpoint do tipo Gateway para o S3 é gratuito. O custo vem do Endpoint do tipo Interface para o Secrets Manager, que é cobrado por hora e por AZ.

Serviços Gratuitos ou de Baixo Custo: Muitos dos recursos na sua lista não têm um custo direto significativo ou estão incluídos no "Free Tier" da AWS. Isso inclui:

VPC, Sub-redes, Route Tables, Internet Gateway, VPC Peering.

Security Groups, IAM Roles, S3 Bucket Policies, CloudFront OAC.

O custo dos Target Groups e Listeners está embutido no custo do ALB.

Para otimizar esses custos no futuro, você poderia considerar o uso de Instâncias Reservadas ou Savings Plans para EC2 e RDS, o que pode gerar descontos de até 60-70% em comparação com os preços sob demanda usados nesta estimativa.

| Serviço | Descrição | Estimado Mensual (USD) |
| :--- | :--- | :--- |
| **EC2** | 8 instâncias (`t3.medium`) em alta disponibilidade (2 por aplicação em 2 AZs) | ~$292.00 |
| **RDS** | 1 instância (`db.t3.medium`) Multi-AZ com 100 GB de storage | ~$159.00 |
| **ALB** | 1 balanceador ativo, incluindo processamento de dados (LCUs) | ~$25.00 |
| **NAT Gateway** | 1 instância com Elastic IP + processamento de 50 GB de dados | ~$39.00 |
| **S3 + CloudFront** | 50 GB em S3 + 1 TB de tráfego de saída do CloudFront | ~$90.00 |
| **VPC Endpoints** | 1 Endpoint de Interface para Secrets Manager em 2 AZs (S3 é gratuito) | ~$18.00 |
| **CloudWatch Logs** | Ingestão e armazenamento de aproximadamente 10 GB de logs mensais | ~$5.00 |
| **Total Estimado** | | **~$628.00** |
