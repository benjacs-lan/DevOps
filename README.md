☁️ AWS Cloud-Native Infrastructure: EKS, Terraform & CI/CD

Este proyecto implementa una arquitectura Cloud-Native Production-Grade en AWS, diseñada para desplegar una aplicación web moderna mediante prácticas de Infrastructure as Code (IaC), automatización CI/CD y Kubernetes.
El objetivo principal es habilitar un ciclo de desarrollo ágil con despliegues automatizados, alta disponibilidad y Zero Downtime Deployments.

🏗️ Arquitectura de la Solución

La infraestructura se construye sobre tres pilares fundamentales que garantizan escalabilidad, resiliencia y reproducibilidad.

🔹 Diagrama de Arquitectura
graph TD
    User((Internet User)) --> ALB(AWS Load Balancer)

    subgraph VPC [AWS Cloud (us-east-1)]
        ALB --> Service(K8s Service)

        subgraph EKS [EKS Cluster]
            Service --> Pod1[Flask App Replica 1]
            Service --> Pod2[Flask App Replica 2]
            Service --> Pod3[Flask App Replica 3]
        end
    end
    
    Terraform -->|State Locking| S3(S3 Backend us-west-1)
📦 Componentes Principales
1️⃣ Aplicación — /app

Microservicio RESTful desarrollado con Python 3.12 usando Flask.

Características:

Containerización mediante Docker (python:3.12-slim)

Cumplimiento del estándar 12-Factor App

Variables de entorno para configuración dinámica (e.g., APP_MESSAGE)

Imagen ligera y optimizada para producción

2️⃣ Infraestructura como Código — /terraform

Infraestructura declarativa, reproducible y auditable mediante Terraform.

🌐 Networking

VPC personalizada en us-east-1

Subredes públicas/privadas

Single NAT Gateway (optimización de costos)

🖥️ Compute

AWS EKS v1.29 con Managed Node Groups (t3.medium)

📦 State Management

Backend remoto en S3 (us-west-1)

State Locking utilizando DynamoDB (si aplica)

Prevención de condiciones de carrera para equipos distribuidos

3️⃣ Orquestación en Kubernetes — /k8s

Gestión avanzada de la aplicación mediante manifiestos YAML.

Deployment con 3 réplicas (alta disponibilidad)

Liveness y Readiness Probes (self-healing)

Service Type: LoadBalancer expuesto vía AWS ALB

Estrategia de despliegue: Rolling Updates
📂 Estructura del Repositorio
├── app/
│   ├── main.py             # Entrypoint de Flask
│   ├── Dockerfile          # Imagen optimizada
│   └── requirements.txt    # Dependencias
├── terraform/
│   ├── main.tf             # Backend, Providers
│   ├── vpc.tf              # Red: VPC, Subnets, IGW, NAT
│   ├── eks.tf              # Control Plane y Node Groups
│   └── variables.tf        # Variables de entorno
├── k8s/
│   ├── deployment.yaml     # Pods, réplicas y probes
│   └── service.yaml        # LoadBalancer Service
└── .github/workflows/      # Pipelines CI/CD

🚀 Guía de Despliegue
✔️ Prerrequisitos

Terraform CLI

AWS CLI configurado

Kubectl

Docker

🔹 Paso 1: Aprovisionar Infraestructura
cd terraform
# 1. Inicializar Terraform y descargar módulos/proveedores
terraform init

# 2. Revisar cambios
terraform plan

# 3. Aplicar infraestructura (~15 mins)
terraform apply -auto-approve

🔹 Paso 2: Configurar Acceso al Clúster
aws eks update-kubeconfig --region us-east-1 --name devops-project-cluster

🔹 Paso 3: Desplegar la Aplicación

Asegúrate de tener una imagen publicada en ECR o DockerHub.

kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

🔄 CI/CD Pipeline — GitHub Actions

Automatización completa del ciclo DevOps.

Flujo del pipeline:

Trigger: Push a la rama main

Build: Construcción de la imagen Docker

Push: Publicación en AWS ECR / DockerHub

Deploy: Rolling Update automático en EKS

Kubernetes reemplaza las réplicas gradualmente, evitando caídas del servicio (Zero Downtime).

🛠️ Tech Stack
Área	Tecnología	Descripción
Cloud Provider	AWS	EKS, VPC, S3, IAM, ALB
IaC	Terraform	State remoto en S3
Container	Docker	Imagen Python slim
Orchestration	Kubernetes	v1.29, Deployment, Services
Language	Python	Flask API
CI/CD	GitHub Actions	Build & Deploy automáticos
📘 Conclusión

Este proyecto demuestra una arquitectura Cloud-Native moderna enfocada en:

Automatización

Escalabilidad

Buenas prácticas DevOps

Despliegues sin interrupciones

Infraestructura reproducible y portable
