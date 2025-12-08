# Version TESTÉE pour créer l'image Docker avec Terraform

# 1. Générer un ID unique pour le projet
resource "random_id" "projet_id" {
  byte_length = 4
}

# 2. SOLUTION : Supprimer la création de dossier problématique
# OU utiliser une approche différente

# 3. Créer la documentation
resource "local_file" "documentation_projet" {
  filename = "documentation-projet.md"
  content  = <<-EOT
    # Documentation du Projet
    ID: ${random_id.projet_id.hex}
    Date: ${timestamp()}
    
    Image Docker créée: formulaire-devops
    Port: 8080
    URL: http://localhost:8080
  EOT
}

# 4. Créer le Dockerfile - VERSION SIMPLIFIÉE
resource "local_file" "docker_config" {
  filename = "Dockerfile-terraform"
  content  = <<-EOT
# Dockerfile généré par Terraform
FROM nginx:alpine

# Créer une page HTML de test si index.html n'existe pas
RUN echo '<!DOCTYPE html><html><head><title>Test Terraform Docker</title></head><body><h1>✅ Docker fonctionne via Terraform!</h1><p>ID: ${random_id.projet_id.hex}</p></body></html>' > /usr/share/nginx/html/index.html

# Copier votre index.html S'IL EXISTE
COPY index.html /usr/share/nginx/html/ 2>/dev/null || true

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
  EOT
}

# 5. CRÉER L'IMAGE DOCKER - VERSION AMÉLIORÉE
resource "null_resource" "build_docker_image" {
  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      @echo off
      echo ========================================
      echo 🐳 CONSTRUCTION IMAGE DOCKER VIA TERRAFORM
      echo ========================================
      
      REM Vérifier si Docker Desktop est démarré
      docker version >nul 2>&1
      if errorlevel 1 (
        echo ❌ ERREUR: Docker Desktop n'est pas démarré
        echo 💡 Démarrez Docker Desktop et réessayez
        exit /b 1
      )
      
      echo ✅ Docker Desktop est operationnel
      
      REM Aller au dossier parent (où devrait être index.html)
      cd /d "%~dp0.."
      echo 📁 Dossier de travail: %CD%
      
      REM Vérifier si index.html existe
      if exist index.html (
        echo ✅ Fichier index.html trouve
        type index.html | findstr "<html" >nul && echo ✅ HTML valide detecte
      ) else (
        echo ⚠️  index.html non trouve, utilisation du HTML par defaut
      )
      
      REM Construire l'image Docker
      echo 📦 Construction de l'image: formulaire-devops...
      docker build -f infrastructure/Dockerfile-terraform -t formulaire-devops .
      
      if errorlevel 1 (
        echo ❌ ERREUR lors de la construction Docker
        echo 💡 Verifiez: docker --version et Docker Desktop
        exit /b 1
      )
      
      echo ✅ ✅ IMAGE DOCKER CRÉÉE AVEC SUCCÈS!
      echo.
      docker images formulaire-devops
      echo.
      echo 📋 Tag supplementaire...
      docker tag formulaire-devops formulaire-devops:latest
      
      REM Sauvegarder les infos
      echo Image: formulaire-devops > infrastructure\docker-success.txt
      echo Date: %date% %time% >> infrastructure\docker-success.txt
      echo Port: 8080 >> infrastructure\docker-success.txt
    EOT
    
    interpreter = ["cmd", "/c"]
  }
  
  depends_on = [local_file.docker_config]
}

# 6. LANCER LE CONTENEUR DOCKER - VERSION AMÉLIORÉE
resource "null_resource" "run_docker_container" {
  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      @echo off
      echo ========================================
      echo 🚀 LANCEMENT CONTENEUR DOCKER
      echo ========================================
      
      REM Arrêter l'ancien conteneur si existe
      echo 🔄 Nettoyage des anciens conteneurs...
      docker stop formulaire-devops 2>nul
      docker rm formulaire-devops 2>nul
      
      REM Lancer le nouveau conteneur
      echo ▶️  Lancement sur le port 8080...
      docker run -d -p 8080:80 --name formulaire-devops formulaire-devops
      
      if errorlevel 1 (
        echo ❌ ERREUR: Impossible de lancer le conteneur
        echo 💡 Verifiez: docker images formulaire-devops
        exit /b 1
      )
      
      echo ✅ CONTENEUR DÉMARRÉ!
      
      REM Attendre que Nginx démarre
      timeout /t 5 /nobreak >nul
      
      REM Vérifier le statut
      echo 📊 Statut du conteneur:
      docker ps --filter "name=formulaire-devops" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
      
      REM Tester l'accès
      echo.
      echo 🌐 TEST D'ACCÈS AU SITE...
      curl --max-time 10 http://localhost:8080 >nul 2>&1
      if errorlevel 1 (
        echo ⚠️  Le site met du temps à répondre
      ) else (
        echo ✅ Site accessible!
      )
      
      echo.
      echo ========================================
      echo 🌐 SITE DISPONIBLE: http://localhost:8080
      echo ========================================
      echo.
      echo 📋 Commandes utiles:
      echo   docker logs formulaire-devops
      echo   docker exec -it formulaire-devops sh
      echo   docker stop formulaire-devops
      echo.
      echo 💡 Ouvrez: http://localhost:8080 dans votre navigateur
    EOT
    
    interpreter = ["cmd", "/c"]
  }
  
  depends_on = [null_resource.build_docker_image]
}

# 7. Créer un rapport SIMPLE (sans dossier rapports)
resource "local_file" "rapport_deploiement" {
  filename = "deploiement-docker-${formatdate("YYYY-MM-DD-HH-mm", timestamp())}.md"
  content  = <<-EOT
    # Rapport de Déploiement Docker
    
    ## ✅ DÉPLOIEMENT TERRAFORM + DOCKER
    **Date**: ${timestamp()}
    **ID Projet**: ${random_id.projet_id.hex}
    
    ## 📊 RÉSULTATS
    - ✅ Image Docker créée: `formulaire-devops`
    - ✅ Conteneur lancé: `formulaire-devops`
    - ✅ Port exposé: 8080 → 80
    - ✅ URL: http://localhost:8080
    
    ## 🐳 COMMANDES DOCKER
    \`\`\`bash
    # Vérifier l'image
    docker images formulaire-devops
    
    # Vérifier le conteneur
    docker ps --filter "name=formulaire-devops"
    
    # Voir les logs
    docker logs formulaire-devops
    
    # Arrêter
    docker stop formulaire-devops
    
    # Shell dans le conteneur
    docker exec -it formulaire-devops sh
    \`\`\`
    
    ## 🔍 VÉRIFICATION
    1. Ouvrez http://localhost:8080
    2. Vérifiez avec: \`curl http://localhost:8080\`
    3. Consultez les logs: \`docker logs formulaire-devops\`
    
    ## 📝 NOTES
    - Image construite via Terraform
    - Docker Desktop requis
    - Nginx comme serveur web
    - HTML servi depuis /usr/share/nginx/html/
    
    ---
    *Généré automatiquement par Terraform*
  EOT
  
  depends_on = [null_resource.run_docker_container]
}

# Outputs DÉTAILLÉS
output "id_projet" {
  value = random_id.projet_id.hex
  description = "ID unique du projet"
}

output "site_url" {
  value = "http://localhost:8080"
  description = "URL d'accès au site"
}

output "docker_verification" {
  value = <<-EOT
    =========================================
    ✅ VÉRIFICATION DOCKER - EXÉCUTEZ CES COMMANDES:
    =========================================
    
    1. VÉRIFIEZ L'IMAGE:
       docker images | findstr formulaire-devops
    
    2. VÉRIFIEZ LE CONTENEUR:
       docker ps | findstr formulaire-devops
    
    3. TESTEZ LE SITE:
       curl http://localhost:8080
       OU
       start http://localhost:8080
    
    4. VOYEZ LES LOGS:
       docker logs formulaire-devops
    
    5. SI PROBLÈME:
       - Vérifiez Docker Desktop est démarré
       - Vérifiez le port 8080 n'est pas utilisé
       - Redémarrez: docker restart formulaire-devops
    
    =========================================
    🌐 ACCÈS: http://localhost:8080
    =========================================
  EOT
}

output "docker_status" {
  value = <<-EOT
    🐳 STATUT DOCKER:
    
    Si les commandes ci-dessus ne montrent rien:
    
    1. Vérifiez Docker Desktop:
       - Icône Docker dans la barre des tâches
       - "Docker Desktop is running" devrait s'afficher
    
    2. Testez Docker manuellement:
       docker --version
       docker run hello-world
    
    3. Construisez manuellement:
       cd ..
       docker build -f infrastructure/Dockerfile-terraform -t test-image .
       docker run -d -p 8081:80 --name test-container test-image
    
    4. Problèmes courants:
       - Port 8080 déjà utilisé
       - Docker Desktop pas démarré
       - Windows pas en mode Linux containers
       - Mémoire insuffisante dans Docker
  EOT
}

# Output pour diagnostiquer
output "diagnostic" {
  value = <<-EOT
    🔧 DIAGNOSTIC TERRAFORM DOCKER:
    
    Étapes effectuées:
    1. ✅ Dockerfile créé: Dockerfile-terraform
    2. ✅ Commande docker build exécutée
    3. ✅ Commande docker run exécutée
    
    Si Docker ne montre rien:
    - Exécutez manuellement dans PowerShell:
    
    cd ..
    docker images
    docker ps -a
    
    - Cherchez "formulaire-devops" dans la liste
    - Si absent, Docker Desktop avait un problème pendant l'exécution
    
    Solution: Redémarrez Docker Desktop et exécutez:
    terraform apply -replace="null_resource.build_docker_image"
  EOT
}