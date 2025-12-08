# Configuration Terraform simplifiée pour le projet DevOps

# 1. Générer un ID unique pour le projet
resource "random_id" "projet_id" {
  byte_length = 4
}

# 2. Créer un Dockerfile simple pour votre formulaire
resource "local_file" "dockerfile" {
  filename = "${path.module}/Dockerfile-terraform"
  content  = <<-EOT
# Dockerfile généré par Terraform
FROM nginx:alpine

# Copier votre formulaire HTML
COPY ../index.html /usr/share/nginx/html/

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
  EOT
}

# 3. Créer un fichier de documentation simple
resource "local_file" "documentation" {
  filename = "${path.module}/README-terraform.md"
  content  = <<-EOT
# 🚀 Projet DevOps avec Terraform

**ID Projet:** ${random_id.projet_id.hex}
**Date:** ${timestamp()}

## Fichiers générés:
1. Dockerfile-terraform - Pour déployer votre formulaire
2. Ce fichier de documentation

## Commandes rapides:
\`\`\`bash
# Construire l'image Docker
docker build -f Dockerfile-terraform -t mon-formulaire .

# Lancer le conteneur
docker run -d -p 8080:80 mon-formulaire

# Accéder au formulaire
open http://localhost:8080
\`\`\`
  EOT
  
  depends_on = [random_id.projet_id]
}

# Outputs utiles
output "id_projet" {
  value       = random_id.projet_id.hex
  description = "ID unique du projet"
}

output "docker_commande" {
  value = "docker build -f ${local_file.dockerfile.filename} -t mon-formulaire . && docker run -d -p 8080:80 mon-formulaire"
  description = "Commande pour build et run Docker"
}

output "url_formulaire" {
  value       = "http://localhost:8080"
  description = "URL pour accéder au formulaire"
}    - name: 🏗️ Init & Validate
      if: steps.check-files.outputs.has_tf == 'true'
      working-directory: ./infrastructure
      env:
        CHECKPOINT_DISABLE: 1
        TF_SKIP_PROVIDER_VERIFY: 1  # Désactive vérification GPG
      run: |
        # Créer config pour ignorer GPG
        mkdir -p ~/.terraform.d
        echo 'plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"' > ~/.terraformrc
        echo 'disable_checkpoint = true' >> ~/.terraformrc
        echo 'skip_provider_verification = true' >> ~/.terraformrc
        
        echo "🔧 Initialisation Terraform (sans vérification GPG)..."
        terraform init -input=false
        
        echo "🐳 Construction image Docker via Terraform..."
        terraform apply -auto-approve