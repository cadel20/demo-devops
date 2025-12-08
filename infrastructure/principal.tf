# Ressources Terraform pour le projet DevOps

# 1. Créer un fichier de documentation du projet
resource "local_file" "documentation_projet" {
  filename = "../documentation-projet.md"
  content  = <<-EOT
    # 📚 Documentation du Projet DevOps
    
    ## Informations
    - **Projet** : demo-devops
    - **Auteur** : cadel20
    - **Date** : ${timestamp()}
    - **ID Terraform** : ${random_id.projet_id.hex}
    
    ## Technologies utilisées
    - Docker 🐳
    - GitHub Actions ⚡
    - Terraform 🏗️
    - Nginx 🌐
    - HTML/CSS 🎨
    
    ## URL du site
    - GitHub Pages : https://cadel20.github.io/demo-devops/
    - Docker local : http://localhost:8080
    
    ## Commandes utiles
    \`\`\`bash
    # Terraform
    terraform init
    terraform plan
    terraform apply
    
    # Docker
    docker-compose up --build
    docker-compose down
    \`\`\`
    
    ## Structure
    \`\`\`
    demo-devops/
    ├── infrastructure/    # Terraform
    ├── .github/          # CI/CD
    ├── index.html        # Site web
    └── Dockerfile        # Conteneurisation
    \`\`\`
  EOT
}

# 2. Générer un ID unique pour le projet
resource "random_id" "projet_id" {
  byte_length = 4
}

# 3. Créer un fichier de configuration Docker
resource "local_file" "docker_config" {
  filename = "../Dockerfile-terraform"
  content  = <<-EOT
    # Dockerfile généré par Terraform
    FROM nginx:alpine
    
    LABEL mainteneur="cadel20"
    LABEL version="1.0"
    LABEL description="Projet d'apprentissage DevOps"
    
    COPY index.html /usr/share/nginx/html/
    
    EXPOSE 80
    
    CMD ["nginx", "-g", "daemon off;"]
  EOT
}

# 4. Générer un rapport de déploiement
resource "local_file" "rapport_deploiement" {
  filename = "../rapports/deploiement-${formatdate("YYYY-MM-DD", timestamp())}.md"
  content  = <<-EOT
    # 📋 Rapport de Déploiement
    
    ## Détails
    - **Projet** : demo-devops
    - **Environnement** : Développement
    - **Date** : ${timestamp()}
    - **ID** : ${random_id.projet_id.hex}
    
    ## Statut
    ✅ Configuration Terraform valide
    ✅ Ressources locales prêtes
    ✅ Intégration CI/CD configurée
    ✅ Conteneur Docker créé
    
    ## Fichiers générés
    1. documentation-projet.md
    2. Dockerfile-terraform
    3. Ce rapport
    
    ## Conteneur Docker
    - Nom : mon-site-devops-${random_id.projet_id.hex}
    - Port : 8080
    - URL : http://localhost:8080
    
    ## Prochaines étapes
    1. Ouvrir http://localhost:8080
    2. Vérifier le site web
    3. Exécuter le pipeline CI/CD
  EOT
}

# 5. Créer le dossier rapports s'il n'existe pas
resource "local_file" "dossier_rapports" {
  filename = "../rapports/.keep"
  content  = "Dossier pour les rapports Terraform"
}

# ⭐⭐ NOUVEAU : Créer un conteneur Docker avec Terraform ⭐⭐
resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_container" "mon_site" {
  name  = "mon-site-devops-${random_id.projet_id.hex}"
  image = docker_image.nginx.image_id
  
  # Port mapping - votre site sera sur le port 8080
  ports {
    internal = 80
    external = 8080
  }
  
  # Monte votre HTML dans le conteneur
  volumes {
    container_path = "/usr/share/nginx/html"
    host_path      = abspath("..")  # Chemin absolu vers votre projet
    read_only      = true
  }
  
  # Redémarrage automatique
  restart = "unless-stopped"
  
  # Démarrage santé
  healthcheck {
    test     = ["CMD", "curl", "-f", "http://localhost"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
    start_period = "10s"
  }
  
  # Dépend des fichiers générés
  depends_on = [
    local_file.documentation_projet,
    local_file.rapport_deploiement
  ]
}

# ⚠️ COMMENTÉ car cause des erreurs - décommentez si besoin
# resource "null_resource" "docker_backup" {
#   triggers = {
#     always_run = timestamp()
#   }
#   
#   provisioner "local-exec" {
#     command = <<-EOT
#       echo "Alternative Docker container"
#       docker run -d -p 8081:80 --name backup-site nginx:alpine
#     EOT
#   }
# }