# Infraestructura de AWS para Casinos Online con Terraform

Este repositorio contiene el código de Terraform para aprovisionar la infraestructura completa para una "Operación de Casino Online" en AWS. El proyecto se desarrolló como parte de un desafío técnico para un ingeniero de la nube, centrándose en la aplicación de las mejores prácticas de seguridad, escalabilidad, alta disponibilidad y organización del código (Infraestructura como Código).

## Descripción arquitectónica

![Arquitetura](Reto%20Ingeniero%20Cloud.drawio.png)
La infraestructura está diseñada para ser robusta y segura, utilizando una arquitectura de microservicios distribuida en múltiples zonas de disponibilidad (AZ) para garantizar una alta disponibilidad.

### Los componentes principales de la arquitectura son:

**Región de AWS:** ca-central-1 (Canadá).

**Red (VPC):** Dos VPC conectadas mediante peering de VPC:

**VPC principal:** Aloja aplicaciones, API y servicios públicos.

**VPC secundaria:** Dedicada al almacén de datos (base de datos histórica).

**Subredes:** Subredes públicas y privadas distribuidas en al menos dos zonas de disponibilidad (AZ) para alta disponibilidad.

### Gateways:

Puerta de enlace de Internet (IGW): Permite el acceso a y desde internet en la VPC principal.

Puerta de enlace NAT con IP elástica: Permite que las instancias en subredes privadas accedan de forma segura a internet para obtener actualizaciones y parches.

Balanceo de carga:

Balanceador de carga de aplicaciones (ALB): Gestiona todo el tráfico entrante de internet y lo distribuye a los servidores de aplicaciones. Utiliza un certificado SSL/TLS de AWS Certificate Manager (ACM).

Servidores de aplicaciones (EC2): Instancias EC2 ubicadas en subredes privadas para los siguientes microservicios:

- frontsite 
- backoffice
- webapi
- gameapi

### Bases de datos:

RDS (Transaccional): En la VPC principal para las operaciones diarias.

RDS o Redshift (Data Vault): En la VPC secundaria para datos históricos y análisis.

Caché: Amazon ElastiCache para Redis para reducir la latencia y mejorar el rendimiento de las aplicaciones.

### CDN y almacenamiento:

Amazon S3: Para almacenar contenido estático, como imágenes y recursos.

Amazon CloudFront: Actúa como CDN para distribuir contenido estático desde S3 globalmente y con baja latencia.

## Aspectos destacados de seguridad

La seguridad es un pilar fundamental de este proyecto, siguiendo el principio del mínimo privilegio.

**Aislamiento de red:** Uso estricto de grupos de seguridad y listas de control de acceso (ACL) de red para aislar las capas del balanceador de carga, EC2, Redis y la base de datos.

**Acceso privado a S3:** El bucket de S3 que almacena contenido estático está configurado como privado. El acceso se otorga exclusivamente a CloudFront a través del control de acceso de origen (OAC), lo que garantiza que no se pueda acceder directamente al contenido.

**Puntos finales de VPC:** Para aumentar la seguridad y reducir los costos de transferencia de datos, se implementaron puntos finales de VPC:

**Puerta de enlace de puntos finales para S3:** Permite que las instancias de EC2 accedan a S3 sin necesidad de acceder a la red pública de internet.

**Interfaz de punto final para Secrets Manager:** Garantiza que las aplicaciones accedan a las credenciales y los secretos de forma privada.

**Cifrado:** El bucket de S3 tiene habilitado el cifrado SSE-S3 para proteger los datos en reposo.

### Monitoreo y Registros

Para garantizar la observabilidad y auditabilidad, se implementó el siguiente marco de monitoreo:

Grupos de Registros de CloudWatch: Grupos de registros centralizados para recopilar registros de instancias y aplicaciones de EC2.

Registros de Acceso ALB: Los registros de acceso del Balanceador de Carga de Aplicaciones (ALB) se habilitan y almacenan en S3 o CloudWatch, lo que permite un análisis detallado de todo el tráfico HTTP/HTTPS.

## Estructura del proyecto

El código de Terraform está organizado de forma modular para facilitar la reutilización y el mantenimiento.

```
.
├── main.tf          # Orquesta los módulos
├── variables.tf     # Variables de entrada
├── outputs.tf       # Salidas de infraestructura
├── network.tf       # Módulo de red (VPC, subredes, etc.)
├── instances.tf     # Módulo de instancias de EC2
├── s3.tf            # Módulo de bucket de S3
├── cloudfront.tf    # Módulo de distribución de CloudFront
├── endpoints.tf     # Módulo de endpoints de VPC
└── monitoring.tf    # Módulo de monitorización (CloudWatch)
```

## Cómo implementar la infraestructura

**Requisitos previos**

**Cuenta de AWS:** Acceso a una cuenta de AWS con los permisos necesarios.

**Terraform:** Terraform CLI instalado (versión 1.0.0 o superior).

**AWS CLI:** AWS CLI instalado y configurado con sus credenciales (aws configure).

## Pasos de implementación

Clonar el repositorio:

```
git clone https://github.com/haranakag/Casino-Online.git
cd Casino-Online
```
Inicializar Terraform: este comando inicializa el directorio de trabajo y descarga los proveedores necesarios.

```
terraform init
```

Planifique la implementación: Terraform generará un plan de ejecución que muestra los recursos que se crearán. Se recomienda revisar este plan antes de aplicar.

```
terraform plan
```

Aplicar configuración: este comando aprovisionará todos los recursos definidos en los archivos .tf.

```
terraform apply
```

Escriba "Yes" cuando se le solicite para confirmar la creación de la infraestructura.

Destruir la infraestructura: Para eliminar todos los recursos creados por este proyecto y evitar costos, ejecute:

```
terraform destroy
```

## Entregables adicionales

Como se solicitó en el desafío, este proyecto incluye:

**Código Terraform completo:** Todos los archivos .tf necesarios para aprovisionar la infraestructura.

**Diagrama de arquitectura:** El diagrama visualiza todos los componentes descritos, incluyendo VPC, peering, servicios y flujos de comunicación.

**[Estimación de costo mensual:](Costos.md)** Un desglose detallado de los costos mensuales estimados para ejecutar esta infraestructura en AWS, según los servicios aprovisionados.
