☁️ DevOps Infrastructure Project: AWS EKS, Terraform & CI/CD
Este proyecto implementa una infraestructura de grado profesional en AWS para desplegar una aplicación web Python (Flask) contenerizada. Utiliza Infrastructure as Code (IaC) para el aprovisionamiento de recursos y un pipeline de CI/CD para despliegues automáticos y sin tiempo de inactividad (Zero Downtime).

🏗️ Arquitectura General
El objetivo es mantener un ciclo de desarrollo ágil donde cada cambio en el código se refleja automáticamente en la nube.

1. La Aplicación (/app)
Una API REST ligera desarrollada en Python 3.12 con Flask 3.0.0.



Contenedorización: Empaquetada mediante Docker (basada en python:3.12-slim) para garantizar consistencia entre entornos de desarrollo y producción.


Configuración: Sigue los principios 12-Factor App, manejando configuraciones mediante variables de entorno (ej: APP_MESSAGE).

2. Infraestructura como Código (/terraform)
Toda la infraestructura se define declarativamente usando Terraform, eliminando la configuración manual (ClickOps).


VPC: Red privada virtual en us-east-1 con subredes públicas/privadas y un Single NAT Gateway para optimización de costos en desarrollo.



EKS Cluster: Clúster de Kubernetes versión 1.29 con un grupo de nodos gestionados (Managed Node Group) usando instancias t3.medium.


State Management: El estado de Terraform se almacena de forma remota y segura en un bucket S3 (terraform-state-devops-project-benja) ubicado en us-west-1 con bloqueo nativo (use_lockfile) para trabajo colaborativo.

3. Orquestación (/k8s)
Kubernetes gestiona la disponibilidad y escalabilidad de la aplicación.

Deployment: Configurado con 3 réplicas para alta disponibilidad. Incluye Liveness y Readiness Probes para asegurar que solo los contenedores saludables reciban tráfico .

Service: Expone la aplicación mediante un LoadBalancer (AWS ELB) escuchando en el puerto 80 y redirigiendo al puerto 5000 del contenedor .

4. Automatización CI/CD
Flujo automatizado mediante GitHub Actions:

Build: Construye la imagen Docker al detectar un git push.

Push: Sube la imagen a un registro de contenedores (Docker Hub / ECR).

Deploy: Actualiza el despliegue en EKS usando una estrategia de Rolling Update para evitar caídas del servicio.

📂 Estructura del Proyecto
.
├── app/
│   ├── main.py             # Aplicación Flask
│   ├── Dockerfile          # Definición de la imagen
│   └── requirements.txt    # Dependencias Python
├── terraform/
│   ├── main.tf             # Configuración del proveedor y Backend S3
│   ├── vpc.tf              # Red, Subnets, NAT Gateway
│   ├── eks.tf              # Clúster EKS y Node Groups
│   └── variables.tf        # Variables configurables
├── k8s/
│   ├── deployment.yaml     # Estrategia de réplicas y health checks
│   └── service.yaml        # Exposición vía LoadBalancer
└── .github/workflows/      # Pipelines de CI/CD
🚀 Guía de Despliegue (Manual)
Prerrequisitos
Terraform CLI

AWS CLI configurado

Kubectl

Docker

Paso 1: Infraestructura
Inicializar y aplicar la configuración de Terraform.
cd terraform
# Inicializar backend y plugins (nota: bucket en us-west-1, infra en us-east-1)
terraform init 

# Revisar el plan de ejecución
terraform plan

# Crear la infraestructura (tarda ~15 mins)
terraform apply

Paso 2: Configurar Kubectl
Una vez creado el clúster, obtener las credenciales para administrarlo (el creador tiene permisos de admin por defecto ):
aws eks update-kubeconfig --region us-east-1 --name devops-project-cluster

Paso 3: Desplegar Aplicación
Aplicar los manifiestos de Kubernetes.
# Asegúrate de haber construido y subido tu imagen Docker primero
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

🔄 Flujo de Trabajo (DevOps Loop)
Code: El desarrollador modifica main.py y hace commit.

Trigger: GitHub Actions detecta el cambio.

Build & Ship: Se crea una nueva imagen Docker etiquetada y se sube al registro.

Run: Kubernetes detecta la nueva versión, baja los pods antiguos progresivamente y levanta los nuevos.

🛠️ Tech Stack
Nube: AWS (EKS, VPC, S3, IAM)

IaC: Terraform

Contenedores: Docker & Kubernetes

Lenguaje: Python (Flask)

CI/CD: GitHub Actions
