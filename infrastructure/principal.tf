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
    
    ## Fichiers générés
    1. documentation-projet.md
    2. Dockerfile-terraform
    3. Ce rapport
    
    ## Prochaines étapes
    1. Exécuter le pipeline CI/CD
    2. Vérifier le déploiement
    3. Tester le site web
  EOT
}

# 5. Créer le dossier rapports s'il n'existe pas
resource "local_file" "dossier_rapports" {
  filename = "../rapports/.keep"
  content  = "Dossier pour les rapports Terraform"
}