# principal.tf - Version CORRIGÉE
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "npipe:////./pipe/docker_engine"  # Pour Windows
}

# 1. CRÉER un Dockerfile SIMPLE (obligatoire)
resource "local_file" "dockerfile" {
  filename = "Dockerfile"
  content  = <<-EOT
# Utiliser une image nginx légère
FROM nginx:alpine

# Page HTML simple
RUN echo '<!DOCTYPE html><html><head><title>Demo DevOps</title><style>body{background:#667eea;color:white;text-align:center;padding:50px;font-family:Arial}</style></head><body><h1>✅ Terraform + Docker</h1><p>Déployé avec succès!</p><p>Port: 8080</p></body></html>' > /usr/share/nginx/html/index.html

# Exposer le port 80
EXPOSE 80

# Démarrer nginx
CMD ["nginx", "-g", "daemon off;"]
  EOT
}

# 2. CONSTRUIRE l'image LOCALEMENT (pas pull!)
resource "docker_image" "app" {
  name = "demo-devops:latest"  # Nom LOCAL d'abord
  
  # IMPORTANT: Construire depuis Dockerfile
  build {
    context    = "."  # Dossier courant
    dockerfile = "Dockerfile"
  }
  
  # Garder l'image localement
  keep_locally = true
  
  depends_on = [local_file.dockerfile]
}

# 3. LANCER le conteneur
resource "docker_container" "web" {
  name  = "site-cadel-auto"
  image = docker_image.app.image_id  # Utiliser l'image construite
  
  ports {
    internal = 80
    external = 8080
  }
  
  # Redémarrer automatiquement
  restart = "unless-stopped"
  
  depends_on = [docker_image.app]
}

# 4. OPTIONNEL: Tag et push vers Docker Hub
resource "null_resource" "push_to_dockerhub" {
  depends_on = [docker_image.app]
  
  provisioner "local-exec" {
    command = <<-EOT
      @echo off
      echo 📦 Tagging image pour Docker Hub...
      
      # Tag l'image locale pour Docker Hub
      docker tag demo-devops:latest cadel2/demo-devops:latest
      
      echo ✅ Image taggée: cadel2/demo-devops:latest
      echo.
      echo 💡 Pour pousser sur Docker Hub:
      echo   1. docker login
      echo   2. docker push cadel2/demo-devops:latest
    EOT
  }
}

# 5. Outputs
output "deployment_success" {
  value = <<-EOT
  🎉 DÉPLOIEMENT RÉUSSI!
  
  📊 Informations:
  - Conteneur: ${docker_container.web.name}
  - Image: ${docker_image.app.name} (construite localement)
  - Port: http://localhost:8080
  
  🐳 Vérification:
  docker ps --filter "name=site-cadel-auto"
  docker logs site-cadel-auto
  
  🌐 Ouvrez: http://localhost:8080
  
  📦 Pour Docker Hub:
  docker tag demo-devops:latest cadel2/demo-devops:latest
  docker login
  docker push cadel2/demo-devops:latest
  EOT
}