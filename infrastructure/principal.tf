# terraform-docker-hub.tf
# Version pour créer l'image et pousser sur Docker Hub

# 1. Générer un ID unique pour le projet
resource "random_id" "projet_id" {
  byte_length = 4
}

# 2. Variables pour Docker Hub
variable "dockerhub_username" {
  description = "Votre nom d'utilisateur Docker Hub"
  type        = string
  sensitive   = true
}

variable "dockerhub_token" {
  description = "Votre token d'accès Docker Hub"
  type        = string
  sensitive   = true
}

# 3. Créer le Dockerfile optimisé
resource "local_file" "dockerfile_complet" {
  filename = "Dockerfile"
  content  = <<-EOT
# Multi-stage build pour une image plus petite
FROM node:18-alpine as builder

WORKDIR /app

# Copier les fichiers package
COPY package*.json ./
RUN npm ci --only=production

# Copier le code source
COPY . .

# Stage final
FROM nginx:alpine

# Copier les fichiers statiques
COPY --from=builder /app /usr/share/nginx/html
COPY index.html /usr/share/nginx/html/

# Configuration Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Santé check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:80 || exit 1

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
  EOT
}

# 4. Créer la configuration nginx
resource "local_file" "nginx_config" {
  filename = "nginx.conf"
  content  = <<-EOT
server {
    listen 80;
    server_name localhost;
    
    root /usr/share/nginx/html;
    index index.html;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
    
    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
}
  EOT
}

# 5. BUILD de l'image Docker localement
resource "null_resource" "docker_build_local" {
  triggers = {
    dockerfile_hash = md5(file("${path.module}/Dockerfile"))
    timestamp       = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "🐳 Construction de l'image Docker localement..."
      
      # Construire l'image
      docker build -t formulaire-devops:local -t ${var.dockerhub_username}/formulaire-devops:latest .
      
      # Tagger pour Docker Hub
      docker tag formulaire-devops:local ${var.dockerhub_username}/formulaire-devops:${random_id.projet_id.hex}
      docker tag formulaire-devops:local ${var.dockerhub_username}/formulaire-devops:latest
      
      echo "✅ Image taggée pour Docker Hub: ${var.dockerhub_username}/formulaire-devops"
    EOT
  }
  
  depends_on = [local_file.dockerfile_complet, local_file.nginx_config]
}

# 6. LOGIN à Docker Hub et PUSH
resource "null_resource" "docker_push_to_hub" {
  triggers = {
    image_id = random_id.projet_id.hex
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "🔐 Connexion à Docker Hub..."
      
      # Login avec token
      echo "${var.dockerhub_token}" | docker login -u "${var.dockerhub_username}" --password-stdin
      
      if [ $? -eq 0 ]; then
        echo "✅ Connecté à Docker Hub en tant que ${var.dockerhub_username}"
        
        # Pousser l'image
        echo "📤 Envoi de l'image vers Docker Hub..."
        docker push ${var.dockerhub_username}/formulaire-devops:latest
        docker push ${var.dockerhub_username}/formulaire-devops:${random_id.projet_id.hex}
        
        echo "🎉 Image poussée avec succès!"
        echo "📦 Tags disponibles:"
        echo "   - ${var.dockerhub_username}/formulaire-devops:latest"
        echo "   - ${var.dockerhub_username}/formulaire-devops:${random_id.projet_id.hex}"
      else
        echo "❌ Échec de la connexion à Docker Hub"
        echo "💡 Vérifiez votre token dans les secrets GitHub"
      fi
    EOT
    
    interpreter = ["bash", "-c"]
  }
  
  depends_on = [null_resource.docker_build_local]
}

# 7. Script de déploiement Docker Desktop
resource "local_file" "deploy_docker_desktop" {
  filename = "deploy-docker-desktop.sh"
  content  = <<-EOT
#!/bin/bash

echo "🚀 Déploiement sur Docker Desktop..."

# Arrêter et supprimer l'ancien conteneur
docker stop formulaire-devops 2>/dev/null || true
docker rm formulaire-devops 2>/dev/null || true

# Lancer le nouveau conteneur depuis Docker Hub
echo "📥 Téléchargement depuis Docker Hub..."
docker pull ${var.dockerhub_username}/formulaire-devops:latest

echo "▶️  Lancement du conteneur..."
docker run -d \
  -p 8080:80 \
  -p 8443:443 \
  --name formulaire-devops \
  --restart unless-stopped \
  ${var.dockerhub_username}/formulaire-devops:latest

echo "⏳ Attente du démarrage..."
sleep 5

# Vérifier le statut
echo "📊 Statut:"
docker ps --filter "name=formulaire-devops" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "✅ DÉPLOIEMENT TERMINÉ!"
echo "🌐 Accédez à: http://localhost:8080"
echo "📦 Image Docker Hub: ${var.dockerhub_username}/formulaire-devops"
  EOT
}

# 8. Documentation complète
resource "local_file" "documentation_complete" {
  filename = "DEPLOYMENT_GUIDE.md"
  content  = <<-EOT
# Guide de Déploiement Docker Hub + GitHub

## 📋 PRÉREQUIS
1. Compte Docker Hub: https://hub.docker.com
2. Token Docker Hub (Classic) avec droits d'écriture
3. Docker Desktop installé et démarré
4. Terraform installé

## 🔧 CONFIGURATION

### 1. Créer les secrets GitHub (Settings > Secrets and variables > Actions):
- `DOCKERHUB_USERNAME` : Votre nom d'utilisateur Docker Hub
- `DOCKERHUB_TOKEN` : Votre token d'accès

### 2. Configurer Terraform:
\`\`\`bash
# Initialiser Terraform
terraform init

# Appliquer avec vos credentials
terraform apply -var="dockerhub_username=VOTRE_NOM" -var="dockerhub_token=VOTRE_TOKEN"
\`\`\`

## 🐳 COMMANDES MANUELLES

### Build local:
\`\`\`bash
docker build -t formulaire-devops .
\`\`\`

### Push vers Docker Hub:
\`\`\`bash
docker tag formulaire-devops VOTRE_NOM/formulaire-devops:latest
docker login -u VOTRE_NOM
docker push VOTRE_NOM/formulaire-devops:latest
\`\`\`

### Pull et run depuis Docker Hub:
\`\`\`bash
docker pull VOTRE_NOM/formulaire-devops:latest
docker run -d -p 8080:80 --name formulaire-devops VOTRE_NOM/formulaire-devops:latest
\`\`\`

## 🔗 LIENS UTILES
- **Docker Hub Repository**: https://hub.docker.com/r/${var.dockerhub_username}/formulaire-devops
- **GitHub Actions**: https://github.com/${var.github_repo}/actions
- **Site local**: http://localhost:8080

## 📊 VÉRIFICATION
\`\`\`bash
# Vérifier l'image sur Docker Hub
docker pull ${var.dockerhub_username}/formulaire-devops:latest

# Vérifier le conteneur
docker ps --filter "name=formulaire-devops"

# Voir les logs
docker logs formulaire-devops
\`\`\`
  EOT
}

# 9. Fichier .env example
resource "local_file" "env_example" {
  filename = ".env.example"
  content  = <<-EOT
# Configuration Docker Hub
DOCKERHUB_USERNAME=votre_nom_dockerhub
DOCKERHUB_TOKEN=votre_token_ici

# Configuration application
APP_PORT=8080
APP_NAME=formulaire-devops
APP_VERSION=1.0.0
  EOT
}

# Outputs
output "dockerhub_repository" {
  value = "https://hub.docker.com/r/${var.dockerhub_username}/formulaire-devops"
  description = "URL du repository Docker Hub"
}

output "local_deployment" {
  value = <<-EOT
  🚀 DÉPLOIEMENT LOCAL:
  
  1. Image construite: formulaire-devops:local
  2. Image poussée: ${var.dockerhub_username}/formulaire-devops
  
  Commandes:
    docker run -d -p 8080:80 --name formulaire-devops formulaire-devops:local
    OU
    docker run -d -p 8080:80 --name formulaire-devops ${var.dockerhub_username}/formulaire-devops:latest
    
  Accès: http://localhost:8080
  EOT
}

output "github_actions_setup" {
  value = <<-EOT
  ⚙️  CONFIGURATION GITHUB ACTIONS:
  
  1. Allez dans: Settings > Secrets and variables > Actions
  2. Ajoutez ces secrets:
     - DOCKERHUB_USERNAME: ${var.dockerhub_username}
     - DOCKERHUB_TOKEN: [votre token]
  
  3. Poussez sur main pour déclencher le workflow
  4. Vérifiez: https://github.com/[votre-repo]/actions
  EOT
}