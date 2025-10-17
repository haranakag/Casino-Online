# Notas y suposiciones utilizadas en la estimación

Para obtener estas cifras, realicé algunas suposiciones basadas en un escenario de aplicación con tráfico moderado y alta disponibilidad, según el desafío:

Región: Todos los precios corresponden a la región ca-central-1 (Canadá), como se especifica en el documento.

EC2: El desafío requiere 4 aplicaciones (frontsite, backoffice, webapi, gameapi) en alta disponibilidad. Asumí que esto significa 2 instancias por aplicación (una en cada una de las 2 zonas de disponibilidad), para un total de 8 instancias. Se eligió el tipo t3.medium como punto de partida equilibrado.

RDS: Utilicé una instancia db.t3.medium en modo Multi-AZ para alta disponibilidad, con 100 GB de almacenamiento SSD (gp3).

Puerta de enlace NAT: El costo incluye la tarifa por hora y un estimado de 50 GB de datos procesados ​​para actualizaciones del sistema y llamadas API externas.

CloudFront y S3: La mayor parte del costo proviene de la transferencia de datos desde CloudFront a los usuarios. Calculé un volumen considerable (1 Terabyte) para una aplicación como la de un casino en línea. El costo del almacenamiento en S3 es relativamente bajo.

Puntos de conexión de VPC: El punto de conexión de puerta de enlace para S3 es gratuito. El costo proviene del punto de conexión de interfaz para Secrets Manager, que se factura por hora y por AZ.

Servicios gratuitos o de bajo costo: Muchas de las funciones de su lista no tienen un costo directo significativo o están incluidas en la capa gratuita de AWS. Esto incluye:

VPC, subredes, tablas de rutas, puerta de enlace de Internet, emparejamiento de VPC.

Grupos de seguridad, roles de IAM, políticas de bucket de S3, OAC de CloudFront.

El costo de los grupos objetivo y los oyentes está incluido en el costo del ALB.

Para optimizar estos costos en el futuro, podría considerar usar Instancias Reservadas o Planes de Ahorro para EC2 y RDS, que pueden ofrecer descuentos de hasta un 60-70% en comparación con los precios bajo demanda utilizados en esta estimación.

| Servicio | Descripción | Costo Mensual Estimado (USD) |
| :--- | :--- | :--- |
| **EC2** | 8 instancias (`t3.medium`) en alta disponibilidad (2 por aplicación en 2 AZ) | ~$292.00 |
| **RDS** | 1 instancia (`db.t3.medium`) Multi-AZ con 100 GB de almacenamiento | ~$159.00 |
| **ALB** | 1 balanceador de carga activo, incluyendo procesamiento de datos (LCU) | ~$25.00 |
| **NAT Gateway** | 1 instancia con IP elástica y procesamiento de 50 GB de datos | ~$39.00 |
| **S3 + CloudFront** | 50 GB en S3 + 1 TB de tráfico de salida de CloudFront | ~$90.00 |
| **VPC Endpoints** | 1 Endpoint de Interface para Secrets Manager em 2 AZs (S3 é gratuito) | ~$18.00 |
| **CloudWatch Logs** | Ingestão e armazenamento de aproximadamente 10 GB de logs mensais | ~$5.00 |
| **Total Estimado** | | **~$628.00** |

