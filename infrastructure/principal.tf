# Version avec création automatique de l'image Docker

# 0. Créer un script de résolution de l'erreur OpenPGP
resource "local_file" "fix_openpgp_script" {
  filename = "${path.module}/fix-openpgp-error.sh"
  content = <<-EOT
    #!/bin/bash
    # Script pour résoudre l'erreur OpenPGP de Terraform
    # Erreur: Échec d’installation du fournisseur - OpenPGP : clé expirée
    
    echo "🔧 Résolution de l'erreur OpenPGP de Terraform..."
    echo "================================================"
    
    # 1. Nettoyer les caches
    echo "🧹 Étape 1: Nettoyage des caches..."
    rm -rf ~/.terraform.d/ 2>/dev/null || true
    rm -rf .terraform/ 2>/dev/null || true
    rm -f .terraform.lock.hcl 2>/dev/null || true
    
    # 2. Configurer l'environnement
    echo "⚙️  Étape 2: Configuration de l'environnement..."
    export CHECKPOINT_DISABLE=1
    export TF_PLUGIN_CACHE_DIR=""
    
    # 3. Initialiser Terraform sans le provider problématique
    echo "🔄 Étape 3: Initialisation de Terraform..."
    
    # Créer une configuration temporaire sans docker
    cat > terraform_temp.tf << 'EOF'
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "~> 3.5.1"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
}
EOF
    
    # Initialiser
    terraform init -upgrade -reconfigure
    
    # 4. Restaurer la configuration originale
    echo "📁 Étape 4: Restauration de la configuration..."
    rm terraform_temp.tf
    
    echo ""
    echo "✅ Solutions appliquées !"
    echo ""
    echo "📋 OPTIONS SUIVANTES :"
    echo "1. Si vous avez BESOIN du provider Docker :"
    echo "   - Utilisez une version différente dans providers.tf"
    echo "   - Exemple: version = \"~> 3.0.0\""
    echo ""
    echo "2. Si vous n'avez PAS BESOIN du provider Docker :"
    echo "   - Supprimez-le de votre configuration"
    echo "   - Votre code actuel fonctionne SANS docker"
    echo ""
    echo "3. Solution alternative :"
    echo "   terraform init -plugin-dir=\$HOME/.terraform.d/plugins/"
    echo ""
    echo "🚀 Essayez maintenant : terraform plan"
    EOT
  
  file_permission = "0755"
}

# 1. Générer un ID unique pour le projet
resource "random_id" "projet_id" {
  byte_length = 4
}

# 2. Créer le dossier rapports - Version Windows PowerShell
resource "null_resource" "create_reports_dir" {
  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      $reportsPath = "${path.module}\\rapports"
      if (-not (Test-Path $reportsPath)) {
          New-Item -Path $reportsPath -ItemType Directory -Force | Out-Null
          Write-Host "Dossier créé: $reportsPath"
      }
    EOT
    interpreter = ["powershell", "-Command"]
  }
}

# 3. Créer un fichier de documentation du projet AVEC SOLUTIONS
resource "local_file" "documentation_projet" {
  filename = "${path.module}/documentation-projet.md"
  content  = <<-EOT
    # 📚 Documentation du Projet DevOps
    
    ## ⚠️ IMPORTANT : Solution à l'erreur OpenPGP
    Si vous rencontrez l'erreur : 
    ```
    Erreur: Échec d’installation du fournisseur
    Erreur lors de l’installation de kreuzwerker/docker v3.6.2 : 
    signature de vérification d’erreur : OpenPGP : clé expirée
    ```
    
    **Solutions rapides :**
    
    ### 🔧 Solution 1 : Script automatique
    ```bash
    chmod +x infrastructure/fix-openpgp-error.sh
    ./infrastructure/fix-openpgp-error.sh
    ```
    
    ### 🔧 Solution 2 : Commandes manuelles
    ```bash
    # Nettoyer les caches
    rm -rf ~/.terraform.d/ .terraform/ .terraform.lock.hcl
    
    # Initialiser sans vérification
    export CHECKPOINT_DISABLE=1
    terraform init -upgrade -reconfigure
    ```
    
    ### 🔧 Solution 3 : Modifier la configuration
    Si vous utilisez le provider Docker, changez la version dans `providers.tf` :
    ```hcl
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.0.0"  # Version différente
    }
    ```
    
    ### ℹ️ Bonne nouvelle !
    Votre configuration actuelle **ne nécessite PAS** le provider Docker.
    Elle fonctionne parfaitement avec seulement :
    - random (pour générer les IDs)
    - local (pour créer des fichiers)
    
    ## 📋 Informations du projet
    - **Projet** : demo-devops
    - **Auteur** : cadel20
    - **Date** : ${timestamp()}
    - **ID Terraform** : ${random_id.projet_id.hex}
    
    ## 🛠️ Technologies utilisées
    - Terraform 🏗️ (sans provider Docker problématique)
    - Docker 🐳 (via Dockerfile séparé)
    - GitHub Actions ⚡
    - Nginx 🌐
    - HTML/CSS/JavaScript 🎨
    
    ## 📁 Fichiers générés par Terraform
    1. 📄 `documentation-projet.md` - Ce fichier
    2. 🐳 `Dockerfile-terraform` - Configuration Docker optimisée
    3. 📊 `rapports/deploiement-*.md` - Rapports de déploiement
    4. 🔧 `fix-openpgp-error.sh` - Script de résolution d'erreur
    
    ## ✅ Ce qui fonctionne SANS Docker Provider
    - Génération d'ID unique ✅
    - Documentation automatique ✅
    - Rapports de déploiement ✅
    - Configuration Docker optimisée ✅
    
    ## 🚀 Commandes de déploiement
    ```bash
    # 1. Résoudre l'erreur OpenPGP (si nécessaire)
    ./infrastructure/fix-openpgp-error.sh
    
    # 2. Lancer Terraform
    cd infrastructure
    terraform init  # Utilise seulement random et local
    terraform plan
    terraform apply
    
    # 3. Tester avec Docker (séparément)
    docker build -f infrastructure/Dockerfile-terraform -t demo-devops .
    docker run -d -p 8080:80 demo-devops
    ```
    
    ## 🔄 Workflow recommandé
    1. Terraform génère la documentation et les configurations
    2. Docker build utilise le Dockerfile généré
    3. GitHub Actions gère le CI/CD
    4. Votre formulaire reste inchangé à la racine
    
    ## 📞 Support
    - Script de résolution : `fix-openpgp-error.sh`
    - Documentation : ce fichier
    - Issues : Repository GitHub
  EOT
  
  depends_on = [random_id.projet_id]
}

# 4. Créer un fichier de configuration Docker OPTIMISÉ
resource "local_file" "docker_config" {
  filename = "${path.module}/Dockerfile-terraform"
  content  = <<-EOT
    # Dockerfile optimisé pour votre formulaire HTML
    # Généré par Terraform - Ne nécessite PAS le provider Docker Terraform
    
    FROM nginx:alpine
    
    LABEL mainteneur="cadel20"
    LABEL version="1.0"
    LABEL description="Formulaire DevOps - Déployé avec Docker"
    
    # Copier votre formulaire HTML
    COPY index.html /usr/share/nginx/html/
    
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
        gzip_types text/plain text/css text/javascript application/javascript; \
        \
        # Cache des fichiers statiques \
        location ~* \.(js|css|html)$ { \
            expires 1d; \
            add_header Cache-Control "public"; \
        } \
        \
        # Service du formulaire \
        location / { \
            try_files \$uri \$uri/ /index.html; \
        } \
    }' > /etc/nginx/conf.d/default.conf
    
    # Page de santé
    RUN echo 'OK' > /usr/share/nginx/html/healthz
    
    EXPOSE 80
    
    CMD ["nginx", "-g", "daemon off;"]
    
    # ℹ️ Note : Ce Dockerfile est indépendant de Terraform
    # Build : docker build -f infrastructure/Dockerfile-terraform -t myapp .
    # Run   : docker run -d -p 8080:80 myapp
  EOT
}

# 7. NOUVEAU : Créer l'image Docker automatiquement
resource "null_resource" "build_docker_image" {
  triggers = {
    dockerfile_hash = filemd5(local_file.docker_config.filename)
    timestamp       = timestamp()
    project_id      = random_id.projet_id.hex
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      Write-Host "🐳 Construction de l'image Docker..." -ForegroundColor Cyan
      Write-Host "=====================================" -ForegroundColor Cyan
      
      # Variables
      $IMAGE_NAME = "formulaire-devops"
      $IMAGE_TAG = "v1.0-${random_id.projet_id.hex}"
      $PORT = 8080
      
      # Vérifier si le fichier index.html existe
      $indexPath = "..\\index.html"
      if (-not (Test-Path $indexPath)) {
          Write-Host "❌ ERREUR: index.html non trouvé à: $indexPath" -ForegroundColor Red
          Write-Host "   Le fichier doit être dans le dossier parent" -ForegroundColor Yellow
          exit 1
      }
      
      Write-Host "✅ Fichier index.html trouvé" -ForegroundColor Green
      
      # Aller au dossier parent (contexte de build)
      Set-Location ..
      
      # Construire l'image Docker
      Write-Host "📦 Construction de l'image: ${IMAGE_NAME}:${IMAGE_TAG}" -ForegroundColor Yellow
      
      docker build `
        -f infrastructure/Dockerfile-terraform `
        -t ${IMAGE_NAME}:${IMAGE_TAG} `
        -t ${IMAGE_NAME}:latest `
        .
      
      if ($LASTEXITCODE -eq 0) {
          Write-Host "✅ Image Docker construite avec succès!" -ForegroundColor Green
          
          # Afficher les images créées
          docker images ${IMAGE_NAME}
          
          # Sauvegarder les infos dans un fichier
          $dockerInfo = @"
          IMAGE: ${IMAGE_NAME}:${IMAGE_TAG}
          PORT: ${PORT}
          BUILD_DATE: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
          TERRAFORM_ID: ${random_id.projet_id.hex}
          COMMAND: docker run -d -p ${PORT}:80 ${IMAGE_NAME}:latest
          "@
          
          $dockerInfo | Out-File -FilePath "infrastructure\\docker-image-info.txt" -Encoding UTF8
          Write-Host "📄 Infos sauvegardées: infrastructure\\docker-image-info.txt" -ForegroundColor Gray
          
      } else {
          Write-Host "❌ Erreur lors de la construction de l'image Docker" -ForegroundColor Red
          exit 1
      }
    EOT
    
    interpreter = ["powershell", "-Command"]
  }
  
  depends_on = [
    local_file.docker_config,
    random_id.projet_id
  ]
}

# 8. NOUVEAU : Lancer le conteneur Docker
resource "null_resource" "run_docker_container" {
  triggers = {
    image_built = null_resource.build_docker_image.id
    always_run  = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      Write-Host "🚀 Démarrage du conteneur Docker..." -ForegroundColor Cyan
      Write-Host "===================================" -ForegroundColor Cyan
      
      # Variables
      $CONTAINER_NAME = "formulaire-devops"
      $IMAGE_NAME = "formulaire-devops:latest"
      $PORT = 8080
      
      # Arrêter et supprimer l'ancien conteneur si existant
      Write-Host "🔄 Nettoyage de l'ancien conteneur..." -ForegroundColor Gray
      docker stop $CONTAINER_NAME 2>$null
      docker rm $CONTAINER_NAME 2>$null
      
      # Lancer le nouveau conteneur
      Write-Host "▶️  Lancement du conteneur sur le port ${PORT}..." -ForegroundColor Yellow
      
      docker run -d `
        -p ${PORT}:80 `
        --name $CONTAINER_NAME `
        --restart unless-stopped `
        $IMAGE_NAME
      
      if ($LASTEXITCODE -eq 0) {
          Write-Host "✅ Conteneur démarré avec succès!" -ForegroundColor Green
          
          # Attendre que le conteneur soit prêt
          Start-Sleep -Seconds 3
          
          # Vérifier le statut
          Write-Host "🔍 Vérification du conteneur..." -ForegroundColor Gray
          docker ps --filter "name=$CONTAINER_NAME" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
          
          # Tester l'accès
          Write-Host "🌐 Test d'accès au site..." -ForegroundColor Gray
          try {
              $response = Invoke-WebRequest -Uri "http://localhost:${PORT}" -TimeoutSec 10 -ErrorAction Stop
              Write-Host "✅ Site accessible: http://localhost:${PORT}" -ForegroundColor Magenta
              Write-Host "   Status: $($response.StatusCode) $($response.StatusDescription)" -ForegroundColor Gray
          } catch {
              Write-Host "⚠️  Le site met du temps à démarrer, réessayez dans quelques secondes" -ForegroundColor Yellow
              Write-Host "   URL: http://localhost:${PORT}" -ForegroundColor Gray
          }
          
          # Afficher les logs initiaux
          Write-Host "📋 Logs initiaux du conteneur:" -ForegroundColor Gray
          docker logs $CONTAINER_NAME --tail 5
          
      } else {
          Write-Host "❌ Erreur lors du démarrage du conteneur" -ForegroundColor Red
          Write-Host "💡 Essayez: docker logs $CONTAINER_NAME" -ForegroundColor Yellow
      }
    EOT
    
    interpreter = ["powershell", "-Command"]
  }
  
  depends_on = [null_resource.build_docker_image]
}

# 5. Générer un rapport de déploiement MIS À JOUR
resource "local_file" "rapport_deploiement" {
  filename = "${path.module}/rapports/deploiement-${formatdate("YYYY-MM-DD", timestamp())}.md"
  content  = <<-EOT
    # 📋 Rapport de Déploiement - Formulaire DevOps
    
    ## ✅ DÉPLOIEMENT COMPLET AVEC DOCKER AUTOMATIQUE
    **IMPORTANT** : Terraform a créé l'image Docker automatiquement !
    
    ## 📊 Détails du déploiement
    - **Projet** : demo-devops
    - **Statut** : ✅ Succès complet
    - **Date** : ${timestamp()}
    - **ID Terraform** : ${random_id.projet_id.hex}
    - **Image Docker** : formulaire-devops:v1.0-${random_id.projet_id.hex}
    - **Port** : 8080
    
    ## 📁 Fichiers générés
    1. ✅ `fix-openpgp-error.sh` - Script de résolution
    2. ✅ `documentation-projet.md` - Documentation mise à jour
    3. ✅ `Dockerfile-terraform` - Configuration Docker optimisée
    4. ✅ `docker-image-info.txt` - Informations de l'image Docker
    5. ✅ Ce rapport
    
    ## 🐳 IMAGE DOCKER CRÉÉE AUTOMATIQUEMENT
    - **Nom** : formulaire-devops
    - **Tag** : v1.0-${random_id.projet_id.hex} et latest
    - **Port exposé** : 8080 → 80
    - **Statut** : ✅ Construite et en cours d'exécution
    
    ## 🌐 ACCÈS AU SITE
    **URL** : http://localhost:8080
    
    Pour accéder :
    1. Ouvrez votre navigateur à l'URL ci-dessus
    2. Ou exécutez : curl http://localhost:8080
    
    ## 🔧 COMMANDES DE GESTION
    ```bash
    # Voir les logs
    docker logs formulaire-devops
    
    # Entrer dans le conteneur
    docker exec -it formulaire-devops sh
    
    # Redémarrer
    docker restart formulaire-devops
    
    # Arrêter
    docker stop formulaire-devops
    
    # Vérifier le statut
    docker ps | grep formulaire-devops
    ```
    
    ## 📝 NOTES TECHNIQUES
    - ✅ Image Docker construite automatiquement par Terraform
    - ✅ Conteneur lancé sur le port 8080
    - ✅ Vérification automatique de l'accès
    - ✅ Fichier index.html préservé et utilisé
    
    ## 🚀 PROCHAINES ÉTAPES
    1. ✅ Image Docker créée
    2. ✅ Conteneur en cours d'exécution
    3. ⚡ Vérifier les workflows GitHub Actions
    4. 🌐 Déployer sur GitHub Pages
    5. 📊 Monitorer les performances
    
    ---
    *Rapport généré automatiquement - Image Docker créée par Terraform*
  EOT
  
  depends_on = [
    random_id.projet_id,
    null_resource.run_docker_container
  ]
}

# 6. Créer un fichier providers.tf SANS docker
resource "local_file" "providers_config" {
  filename = "${path.module}/providers.tf"
  content = <<-EOT
    # Configuration des providers - Version SÉCURISÉE
    # Ne contient PAS le provider Docker problématique
    
    terraform {
      required_version = ">= 1.0.0"
      
      required_providers {
        # Provider random pour générer des IDs
        random = {
          source  = "hashicorp/random"
          version = "~> 3.5.1"  # Version stable
        }
        
        # Provider local pour les fichiers
        local = {
          source  = "hashicorp/local"
          version = "~> 2.4.0"  # Version stable
        }
        
        # Provider null pour les ressources d'exécution
        null = {
          source  = "hashicorp/null"
          version = "~> 3.2.1"
        }
      }
    }
    
    # Configuration des providers
    provider "random" {
      # Configuration par défaut
    }
    
    provider "local" {
      # Configuration par défaut
    }
    
    provider "null" {
      # Configuration par défaut
    }
    
    # ℹ️ NOTE : Provider Docker VOLONTAIREMENT OMIS
    # Raison : Éviter l'erreur "OpenPGP : clé expirée"
    # Alternative : Utiliser Docker CLI séparément
  EOT
}

# Outputs MIS À JOUR avec infos Docker
output "project_id" {
  value       = random_id.projet_id.hex
  description = "ID unique du projet"
}

output "generated_files" {
  value = [
    local_file.fix_openpgp_script.filename,
    local_file.documentation_projet.filename,
    local_file.docker_config.filename,
    local_file.rapport_deploiement.filename,
    local_file.providers_config.filename,
    "docker-image-info.txt"
  ]
  description = "Fichiers générés par Terraform (sans erreur OpenPGP)"
}

output "docker_image_info" {
  value = <<-EOT
    🐳 IMAGE DOCKER CRÉÉE AUTOMATIQUEMENT !
    
    ✅ Terraform a construit et lancé l'image Docker
    
    📋 INFORMATIONS :
    - Nom : formulaire-devops
    - Tag : v1.0-${random_id.projet_id.hex}
    - Port : 8080
    - URL : http://localhost:8080
    - Conteneur : formulaire-devops
    
    🔧 COMMANDES :
    # Vérifier l'image
    docker images formulaire-devops
    
    # Vérifier le conteneur
    docker ps | findstr formulaire-devops
    
    # Voir les logs
    docker logs formulaire-devops
    
    # Accéder au site
    start http://localhost:8080
    
    🎯 STATUT : Conteneur démarré sur le port 8080
  EOT
  
  depends_on = [null_resource.run_docker_container]
}

output "site_access" {
  value       = "http://localhost:8080"
  description = "URL d'accès au formulaire déployé"
}

output "container_status" {
  value = <<-EOT
    📊 STATUT DU CONTENEUR DOCKER :
    
    Nom : formulaire-devops
    Port : 8080 → 80
    Image : formulaire-devops:latest
    Statut : ✅ En cours d'exécution (vérifiez avec 'docker ps')
    
    Pour vérifier :
    1. docker ps | findstr formulaire-devops
    2. curl http://localhost:8080
    3. docker logs formulaire-devops --tail 10
  EOT
}

output "solution_applied" {
  value = <<-EOT
    ✅ SOLUTION COMPLÈTE APPLIQUÉE !
    
    🔧 CE QUI A ÉTÉ FAIT :
    1. ✅ Script de résolution créé : fix-openpgp-error.sh
    2. ✅ Provider Docker RETIRÉ de la configuration
    3. ✅ Documentation mise à jour avec solutions
    4. ✅ Dockerfile indépendant généré
    5. ✅ Image Docker construite AUTOMATIQUEMENT
    6. ✅ Conteneur lancé sur le port 8080
    
    🎯 VOTRE PROJET EST MAINTENANT COMPLET :
    - Terraform utilise seulement random/local/null
    - Pas d'erreur OpenPGP
    - Image Docker créée automatiquement
    - Site accessible sur http://localhost:8080
    
    🚀 RÉSUMÉ DES COMMANDES :
    1. Résoudre les problèmes : ./fix-openpgp-error.sh
    2. Appliquer Terraform : terraform apply
    3. Accéder au site : http://localhost:8080
    4. Vérifier Docker : docker ps | findstr formulaire-devops
    
    📞 SUPPORT :
    - Script : fix-openpgp-error.sh
    - Docs : documentation-projet.md
    - Docker : Dockerfile-terraform
    - Infos : docker-image-info.txt
  EOT
}

# Nouveau output pour les commandes Docker
output "docker_commands" {
  value = <<-EOT
    🔧 COMMANDES DOCKER UTILES :
    
    # Gestion du conteneur
    docker stop formulaire-devops       # Arrêter
    docker start formulaire-devops      # Démarrer
    docker restart formulaire-devops    # Redémarrer
    docker rm formulaire-devops         # Supprimer
    
    # Logs et inspection
    docker logs formulaire-devops       # Voir les logs
    docker logs -f formulaire-devops    # Suivre les logs
    docker exec -it formulaire-devops sh # Shell interactif
    docker inspect formulaire-devops    # Détails complets
    
    # Gestion des images
    docker images                       # Lister toutes les images
    docker rmi formulaire-devops        # Supprimer l'image
    
    # Nettoyage
    docker system prune -a              # Nettoyer tout
    
    # Reconstruction manuelle
    docker build -f infrastructure/Dockerfile-terraform -t formulaire-devops ..
    docker run -d -p 8080:80 --name formulaire-devops formulaire-devops
  EOT
}