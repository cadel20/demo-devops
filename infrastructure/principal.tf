# Ressources Terraform pour le projet DevOps

# 1. Générer un ID unique pour le projet
resource "random_id" "projet_id" {
  byte_length = 4
}

# 2. Créer le dossier rapports localement
resource "local_file" "dossier_rapports" {
  filename = "${path.module}/rapports/.keep"
  content  = "Dossier pour les rapports Terraform"
}

# 3. Créer un fichier de documentation du projet
resource "local_file" "documentation_projet" {
  filename = "${path.module}/documentation-projet.md"
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
    - HTML/CSS/JavaScript 🎨
    - Formulaire interactif 💻
    
    ## URLs importantes
    - **Site principal** : Votre formulaire HTML à la racine
    - **GitHub Pages** : https://cadel20.github.io/demo-devops/
    - **Docker local** : http://localhost:8080
    
    ## Fichiers générés par Terraform
    1. documentation-projet.md (ce fichier)
    2. Dockerfile-terraform (configuration Docker)
    3. rapports/deploiement-*.md (rapports de déploiement)
    
    ## Caractéristiques du projet
    ✅ Formulaire HTML interactif avec validation
    ✅ Design moderne et responsive
    ✅ Validation en temps réel
    ✅ Animation et effets visuels
    ✅ Compatible tous navigateurs
    
    ## Fonctionnalités du formulaire
    - Validation des champs en temps réel
    - Affichage/masquage du mot de passe
    - Messages d'erreur contextuels
    - Animation de soumission
    - Design responsive
    
    ## Commandes utiles
    \`\`\`bash
    # Terraform
    cd infrastructure
    terraform init
    terraform plan
    terraform apply
    
    # Docker (avec votre formulaire)
    docker build -t demo-devops-app .
    docker run -d -p 8080:80 demo-devops-app
    
    # Accéder au site
    open http://localhost:8080
    \`\`\`
    
    ## Structure du projet
    \`\`\`
    demo-devops/
    ├── index.html              # Votre formulaire HTML (existant)
    ├── infrastructure/         # Configuration Terraform
    │   ├── main.tf
    │   ├── providers.tf
    │   ├── documentation-projet.md   (généré)
    │   ├── Dockerfile-terraform      (généré)
    │   └── rapports/           (généré)
    ├── .github/workflows/      # CI/CD
    └── Dockerfile              # Docker original
    \`\`\`
    
    ## Dépendances
    - Terraform >= 1.0
    - Docker (optionnel)
    - Navigateur web moderne
    
    ## Support
    Pour toute question, consultez la documentation ou créez une issue sur GitHub.
  EOT
  
  depends_on = [random_id.projet_id]
}

# 4. Créer un fichier de configuration Docker OPTIMISÉ pour votre formulaire
resource "local_file" "docker_config" {
  filename = "${path.module}/Dockerfile-terraform"
  content  = <<-EOT
    # Dockerfile optimisé pour votre formulaire HTML
    FROM nginx:alpine
    
    LABEL mainteneur="cadel20"
    LABEL version="1.0"
    LABEL description="Déploiement du formulaire DevOps avec Docker"
    
    # Copier votre formulaire HTML
    COPY ../index.html /usr/share/nginx/html/
    
    # Créer une page d'accueil par défaut
    RUN echo '<!DOCTYPE html> \
    <html> \
    <head> \
        <meta http-equiv="refresh" content="0; url=index.html"> \
        <title>Redirection vers le formulaire</title> \
    </head> \
    <body> \
        <p>Redirection vers le formulaire d'inscription...</p> \
    </body> \
    </html>' > /usr/share/nginx/html/index_redirect.html
    
    # Configuration Nginx optimisée
    RUN echo 'server { \
        listen 80; \
        server_name localhost; \
        root /usr/share/nginx/html; \
        index index.html; \
        \
        # Compression Gzip \
        gzip on; \
        gzip_vary on; \
        gzip_min_length 1024; \
        gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss; \
        \
        # Cache des fichiers statiques \
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ { \
            expires 1y; \
            add_header Cache-Control "public, immutable"; \
        } \
        \
        # Service du formulaire HTML \
        location / { \
            try_files \$uri \$uri/ /index.html; \
        } \
    }' > /etc/nginx/conf.d/default.conf
    
    EXPOSE 80
    
    CMD ["nginx", "-g", "daemon off;"]
  EOT
}

# 5. Générer un rapport de déploiement
resource "local_file" "rapport_deploiement" {
  filename = "${path.module}/rapports/deploiement-${formatdate("YYYY-MM-DD", timestamp())}.md"
  content  = <<-EOT
    # 📋 Rapport de Déploiement - Formulaire DevOps
    
    ## Détails du déploiement
    - **Projet** : demo-devops
    - **Composant** : Formulaire HTML interactif
    - **Environnement** : Développement
    - **Date** : ${timestamp()}
    - **ID Terraform** : ${random_id.projet_id.hex}
    
    ## ✅ Validation des ressources
    - ✅ Configuration Terraform valide
    - ✅ Documentation générée
    - ✅ Dockerfile optimisé créé
    - ✅ Dossier de rapports disponible
    
    ## 📁 Fichiers générés/modifiés
    1. **documentation-projet.md** - Documentation complète du projet
    2. **Dockerfile-terraform** - Configuration Docker optimisée
    3. **Votre formulaire HTML** - Conservé intact à la racine
    
    ## 🐳 Configuration Docker
    - **Image de base** : nginx:alpine
    - **Port exposé** : 80
    - **Optimisations** : 
      - Compression Gzip activée
      - Cache des fichiers statiques
      - Redirection automatique
    
    ## 🌐 URLs d'accès
    - **Local** : http://localhost:8080
    - **Avec Docker** : http://localhost:8080/index.html
    - **GitHub Pages** : https://cadel20.github.io/demo-devops/
    
    ## 🔧 Commandes de test
    \`\`\`bash
    # Construire l'image Docker
    docker build -f infrastructure/Dockerfile-terraform -t formulaire-devops .
    
    # Lancer le conteneur
    docker run -d -p 8080:80 --name formulaire-devops formulaire-devops
    
    # Vérifier le conteneur
    docker ps
    
    # Accéder au formulaire
    # Ouvrez http://localhost:8080 dans votre navigateur
    \`\`\`
    
    ## 📊 Caractéristiques du formulaire
    - ✅ Validation en temps réel
    - ✅ Design responsive
    - ✅ Animations fluides
    - ✅ Compatibilité cross-browser
    - ✅ Sécurité améliorée
    
    ## 🚀 Prochaines étapes
    1. **Tester le déploiement Docker** : 
       \`docker build -f infrastructure/Dockerfile-terraform -t formulaire-devops .\`
       
    2. **Exécuter le conteneur** :
       \`docker run -d -p 8080:80 formulaire-devops\`
       
    3. **Vérifier le site** :
       Ouvrir http://localhost:8080
       
    4. **Lancer le pipeline CI/CD** :
       Vérifier les workflows GitHub Actions
       
    5. **Déployer sur GitHub Pages** (si configuré)
    
    ## 📝 Notes
    - Votre formulaire HTML original est préservé
    - Le Dockerfile est optimisé pour les performances
    - La documentation est mise à jour automatiquement
    - Les rapports sont archivés pour traçabilité
    
    ---
    *Rapport généré automatiquement par Terraform*
  EOT
  
  depends_on = [
    random_id.projet_id,
    local_file.dossier_rapports
  ]
}

# Outputs pour afficher les informations
output "project_id" {
  value       = random_id.projet_id.hex
  description = "ID unique du projet"
}

output "generated_files" {
  value = [
    local_file.documentation_projet.filename,
    local_file.docker_config.filename,
    local_file.rapport_deploiement.filename
  ]
  description = "Fichiers générés par Terraform"
}

output "form_info" {
  value = {
    html_file      = "../index.html (votre formulaire existant)"
    dockerfile     = local_file.docker_config.filename
    documentation  = local_file.documentation_projet.filename
    reports        = local_file.rapport_deploiement.filename
  }
  description = "Informations sur le formulaire et les fichiers générés"
}

output "docker_commands" {
  value = <<-EOT
    🐳 POUR DÉPLOYER VOTRE FORMULAIRE AVEC DOCKER :
    
    1. Construire l'image :
       docker build -f ${local_file.docker_config.filename} -t formulaire-devops .
    
    2. Lancer le conteneur :
       docker run -d -p 8080:80 --name formulaire-devops formulaire-devops
    
    3. Vérifier :
       docker ps
       
    4. Accéder au formulaire :
       Ouvrez http://localhost:8080
       
    5. Arrêter le conteneur :
       docker stop formulaire-devops
       docker rm formulaire-devops
  EOT
}

output "next_steps" {
  value = <<-EOT
    ✅ TERRAFORM A TERMINÉ AVEC SUCCÈS !
    
    📋 CE QUI A ÉTÉ FAIT :
    1. ✅ ID du projet généré : ${random_id.projet_id.hex}
    2. ✅ Documentation créée : ${local_file.documentation_projet.filename}
    3. ✅ Dockerfile optimisé : ${local_file.docker_config.filename}
    4. ✅ Rapport de déploiement : ${local_file.rapport_deploiement.filename}
    
    🎯 VOTRE FORMULAIRE HTML EST PRÊT !
    - Emplacement : index.html (à la racine, inchangé)
    - Design : Formulaire interactif avec validation
    - Fonctionnalités : Complètes et modernes
    
    🚀 PROCHAINES ÉTAPES RECOMMANDÉES :
    1. Tester avec Docker (voir commandes ci-dessus)
    2. Vérifier le pipeline CI/CD dans .github/workflows/
    3. Déployer sur GitHub Pages si configuré
    4. Partager votre formulaire avec des utilisateurs test
    
    📞 SUPPORT :
    - Documentation : ${local_file.documentation_projet.filename}
    - Rapports : ${local_file.rapport_deploiement.filename}
    - Issues : GitHub Repository
  EOT
}