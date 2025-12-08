# principal.tf - Version corrigée
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Configuration du provider Docker
provider "docker" {
  # Sur Windows avec Docker Desktop
  host = "npipe:////./pipe/docker_engine"
  
  # Sur Linux/Mac, utiliser:
  # host = "unix:///var/run/docker.sock"
}

# 1. Construire l'image depuis un Dockerfile local
resource "docker_image" "app" {
  name = "demo-devops:latest"
  
  # Option 1: Build depuis Dockerfile
  build {
    context    = "."  # Dossier courant
    dockerfile = "Dockerfile"
    tag        = ["demo-devops:latest", "cadel2/demo-devops:latest"]
    
    # Labels pour l'image
    label = {
      author = "Terraform"
      built  = timestamp()
    }
  }
  
  # Garder l'image localement
  keep_locally = true
}

# 2. Lancer le conteneur
resource "docker_container" "web" {
  name  = "site-cadel-auto"
  image = docker_image.app.image_id
  
  # Ports
  ports {
    internal = 80
    external = 8080
  }
  
  # Redémarrage automatique
  restart = "unless-stopped"
  
  # Santé du conteneur
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost:80"]
    interval = "30s"
    timeout  = "3s"
    retries  = 3
  }
}

# 3. Outputs
output "deployment_complete" {
  value = <<-EOT
  ✅ DÉPLOIEMENT RÉUSSI!
  
  📊 Détails:
  - Conteneur: ${docker_container.web.name}
  - Image: ${docker_image.app.name}
  - Port: http://localhost:8080
  
  🐳 Vérification:
  docker ps --filter "name=site-cadel-auto"
  docker logs site-cadel-auto
  
  🌐 Accès:
  Ouvrez http://localhost:8080 dans votre navigateur
  EOT
}