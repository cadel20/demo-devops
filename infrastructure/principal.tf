# Version minimale pour créer l'image Docker avec Terraform

# 1. Générer un ID unique pour le projet
resource "random_id" "projet_id" {
  byte_length = 4
}

# 2. Créer le dossier rapports
resource "null_resource" "create_reports_dir" {
  triggers = {
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      if not exist "rapports" mkdir rapports
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

# 5. CRÉER L'IMAGE DOCKER (La partie importante)
resource "null_resource" "build_docker_image" {
  triggers = {
    dockerfile = filemd5("Dockerfile-terraform")
    always_run = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "Construction de l'image Docker..."
      
      # Construire l'image depuis le dossier parent
      cd ..
      docker build -f infrastructure/Dockerfile-terraform -t formulaire-devops .
      
      if %ERRORLEVEL% EQU 0 (
        echo Image Docker creee: formulaire-devops
        docker images formulaire-devops
      ) else (
        echo Erreur lors de la construction
        exit 1
      )
    EOT
    interpreter = ["cmd", "/c"]
  }
  
  depends_on = [local_file.docker_config]
}

# 6. LANCER LE CONTENEUR DOCKER
resource "null_resource" "run_docker_container" {
  triggers = {
    image_built = null_resource.build_docker_image.id
    always_run  = timestamp()
  }
  
  provisioner "local-exec" {
    command = <<-EOT
      echo "Demarrage du conteneur Docker sur le port 8080..."
      
      # Arreter l'ancien conteneur si existe
      docker stop formulaire-devops 2>nul
      docker rm formulaire-devops 2>nul
      
      # Lancer le conteneur
      docker run -d -p 8080:80 --name formulaire-devops formulaire-devops
      
      # Verifier
      timeout /t 2 /nobreak >nul
      docker ps --filter "name=formulaire-devops"
      
      echo.
      echo Site accessible: http://localhost:8080
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
    - Vérifier: docker ps | findstr formulaire-devops
    - Logs: docker logs formulaire-devops
    - Arrêter: docker stop formulaire-devops
  EOT
  
  depends_on = [
    null_resource.run_docker_container,
    null_resource.create_reports_dir
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
    Image Docker: formulaire-devops
    Port: 8080
    URL: http://localhost:8080
    
    Pour vérifier:
    - docker images formulaire-devops
    - docker ps | findstr formulaire-devops
    - Accéder: http://localhost:8080
  EOT
}