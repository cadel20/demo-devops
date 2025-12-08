# Version corrigée pour créer l'image Docker avec Terraform

# 1. Générer un ID unique pour le projet
resource "random_id" "projet_id" {
  byte_length = 4
}

# 2. Créer le dossier rapports - Version corrigée
resource "null_resource" "create_reports_dir" {
  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      if not exist "rapports" mkdir rapports
      exit 0
    EOT
    interpreter = ["cmd", "/c"]
  }
}

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

# 4. Créer le Dockerfile
resource "local_file" "docker_config" {
  filename = "Dockerfile-terraform"
  content  = <<-EOT
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
  EOT
}

# 5. CRÉER L'IMAGE DOCKER - Version corrigée
resource "null_resource" "build_docker_image" {
  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      echo Construction de l'image Docker...
      
      # Vérifier si Docker est installé
      docker --version >nul 2>&1
      if errorlevel 1 (
        echo ERREUR: Docker n'est pas installe ou ne fonctionne pas
        exit 1
      )
      
      # Aller au dossier parent et construire l'image
      cd ..
      docker build -f infrastructure/Dockerfile-terraform -t formulaire-devops .
      
      if errorlevel 1 (
        echo ERREUR lors de la construction de l'image Docker
        exit 1
      )
      
      echo ✅ Image Docker creee: formulaire-devops
      docker images formulaire-devops
    EOT
    interpreter = ["cmd", "/c"]
  }
  
  depends_on = [local_file.docker_config]
}

# 6. LANCER LE CONTENEUR DOCKER - Version corrigée
resource "null_resource" "run_docker_container" {
  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      echo Demarrage du conteneur Docker...
      
      # Arreter l'ancien conteneur (silencieusement)
      docker stop formulaire-devops 2>nul
      docker rm formulaire-devops 2>nul
      
      # Lancer le conteneur sur le port 8080
      docker run -d -p 8080:80 --name formulaire-devops formulaire-devops
      
      # Attendre un peu
      timeout /t 3 /nobreak >nul
      
      # Vérifier le statut
      docker ps --filter "name=formulaire-devops"
      
      echo.
      echo 🌐 Site accessible sur: http://localhost:8080
      echo.
      echo Commandes utiles:
      echo   docker logs formulaire-devops
      echo   docker stop formulaire-devops
    EOT
    interpreter = ["cmd", "/c"]
  }
  
  depends_on = [null_resource.build_docker_image]
}

# 7. Générer un rapport
resource "local_file" "rapport_deploiement" {
  filename = "rapports/deploiement-${formatdate("YYYY-MM-DD", timestamp())}.md"
  content  = <<-EOT
    # Rapport de Déploiement
    
    Date: ${timestamp()}
    ID Projet: ${random_id.projet_id.hex}
    
    ✅ Image Docker créée: formulaire-devops
    ✅ Conteneur lancé sur le port 8080
    ✅ URL: http://localhost:8080
    
    Commandes Docker:
    - Vérifier: docker ps
    - Logs: docker logs formulaire-devops
    - Arrêter: docker stop formulaire-devops
  EOT
  
  depends_on = [
    null_resource.run_docker_container
  ]
}

# Outputs simples
output "id_projet" {
  value = random_id.projet_id.hex
}

output "site_url" {
  value = "http://localhost:8080"
}

output "docker_info" {
  value = <<-EOT
    ✅ Docker déployé avec succès !
    
    Image: formulaire-devops
    Port: 8080
    URL: http://localhost:8080
    
    Pour vérifier:
    1. docker images formulaire-devops
    2. docker ps
    3. Ouvrez: http://localhost:8080
    
    Commandes:
    - Arrêter: docker stop formulaire-devops
    - Logs: docker logs formulaire-devops
    - Redémarrer: docker restart formulaire-devops
  EOT
}