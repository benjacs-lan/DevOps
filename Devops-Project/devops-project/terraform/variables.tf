# Variables 

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "devops-project"
}

variable "environment" {
  description = "Entorno de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Región o zona de despliegue"
  type        = string
  default     = "us-east-1" # Cambiar según necesidad
}
