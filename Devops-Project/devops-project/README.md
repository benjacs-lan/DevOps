☁️ AWS Cloud-Native Infrastructure: EKS, Terraform & CI/CDEste proyecto representa una implementación de infraestructura Production-Grade en AWS, diseñada para desplegar una aplicación web moderna mediante prácticas de Infrastructure as Code (IaC) y DevOps.El objetivo principal es demostrar un ciclo de desarrollo ágil con despliegues automatizados, alta disponibilidad y cero tiempo de inactividad (Zero Downtime Deployments).🏗️ Arquitectura de la SoluciónEl sistema se basa en tres pilares fundamentales que garantizan escalabilidad y resiliencia.Fragmento de códigograph TD
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
1. Aplicación (/app)Microservicio RESTful desarrollado en Python 3.12 (Flask).Containerización: Empaquetado optimizado con Docker (python:3.12-slim) para reducir la superficie de ataque y garantizar paridad entre entornos.12-Factor App: Configuración externa mediante variables de entorno (e.g., APP_MESSAGE).2. Infraestructura como Código (/terraform)Aprovisionamiento declarativo y reproducible.Networking: VPC personalizada en us-east-1 con segmentación de subredes (Públicas/Privadas) y Single NAT Gateway para optimización de costos en entornos no productivos1.Compute: Clúster EKS v1.29 con Managed Node Groups (instancias t3.medium).State Management: Backend remoto en S3 (us-west-1) con bloqueo de estado nativo para prevenir condiciones de carrera en equipos distribuidos2.3. Orquestación (/k8s)Gestión avanzada de cargas de trabajo.Alta Disponibilidad: Deployment configurado con 3 réplicas .Self-Healing: Implementación de Liveness y Readiness Probes para reiniciar automáticamente contenedores defectuosos .Service Discovery: Exposición externa mediante AWS Load Balancer .📂 Estructura del RepositorioPlaintext.
├── app/
│   ├── main.py             # Entrypoint de la aplicación Flask
│   ├── Dockerfile          # Definición multi-stage (opcional) del contenedor
│   └── requirements.txt    # Dependencias fijadas
├── terraform/
│   ├── main.tf             # Configuración de Backend S3 y Providers
│   ├── vpc.tf              # Definición de red (VPC, Subnets, IGW, NAT)
│   ├── eks.tf              # Control Plane y Worker Nodes
│   └── variables.tf        # Parametrización de entornos
├── k8s/
│   ├── deployment.yaml     # Definición de Pods, Réplicas y Probes
│   └── service.yaml        # Definición del LoadBalancer
└── .github/workflows/      # Pipelines de CI/CD
🚀 Guía de DesplieguePrerrequisitosTerraform CLIAWS CLI (configurado con credenciales)KubectlDockerPaso 1: Aprovisionar InfraestructuraDespliega la red y el clúster de Kubernetes.Bashcd terraform

# 1. Inicializar Terraform y descargar proveedores
# Nota: El bucket de estado reside en us-west-1, la infra en us-east-1
terraform init

# 2. Previsualizar cambios
terraform plan

# 3. Aplicar cambios (Tiempo estimado: ~15 mins)
terraform apply -auto-approve
Paso 2: Configurar Acceso al ClústerGenera el archivo kubeconfig para permitir la comunicación local con EKS.Bashaws eks update-kubeconfig --region us-east-1 --name devops-project-cluster
Paso 3: Despliegue de la AplicaciónUna vez que la imagen Docker esté en el registro (ECR/DockerHub), aplica los manifiestos:Bashkubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
🔄 CI/CD Pipeline (GitHub Actions)El flujo de DevOps está completamente automatizado:Trigger: Push a la rama main.Build: Construcción de la imagen Docker.Push: Publicación de la imagen en el Container Registry.Deploy: Actualización de imagen en EKS usando Rolling Update.Nota sobre Rolling Updates: Kubernetes reemplaza los pods progresivamente. El servicio nunca deja de responder peticiones durante la actualización.🛠️ Tech StackÁreaTecnologíaDescripciónCloud ProviderAWSEKS, VPC, S3, IAM, ELBIaCTerraformGestión de estado remoto y módulos oficialesContainerDockerImagen base python:3.12-slimOrchestrationKubernetesVersión 1.29, Deployment, ServicesLanguagePythonFramework FlaskCI/CDGitHub ActionsAutomatización del ciclo de vida
