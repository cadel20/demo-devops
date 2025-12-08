# Variables de sortie - Version SANS Provider Docker

output "message_bienvenue" {
  value = <<-EOT
    🎉 Terraform configuré avec succès !
    
    Projet: demo-devops
    Auteur: ${var.auteur}
    Environnement: ${var.environnement}
    
    ✅ CONFIGURATION SÉCURISÉE - Pas d'erreur OpenPGP
    
    Commandes disponibles:
    - terraform init    # Initialiser (fonctionne sans erreur)
    - terraform plan    # Voir le plan
    - terraform apply   # Appliquer
  EOT
}

output "fichiers_crees" {
  value = [
    "documentation-projet.md",
    "Dockerfile-terraform", 
    "fix-openpgp-error.sh",
    "providers.tf"
  ]
  description = "Liste des fichiers créés par Terraform"
}

output "id_projet" {
  value       = random_id.projet_id.hex
  description = "ID unique du projet"
}

# ⭐ SOLUTION : Docker séparé de Terraform
output "docker_info" {
  value = <<-EOT
    🐳 Informations Docker (GÉRÉ SÉPARÉMENT) :
    
    ✅ Solution alternative implémentée pour éviter l'erreur OpenPGP
    ❌ Provider Docker Terraform : NON UTILISÉ (clé GPG expirée)
    ✅ Docker CLI : UTILISÉ DIRECTEMENT
    
    📁 Dockerfile généré : Dockerfile-terraform
    🏷️ Nom recommandé : formulaire-devops
    
    🌐 Site accessible sur : http://localhost:8080
    
    Commandes Docker :
    - Construire : docker build -f Dockerfile-terraform -t formulaire-devops .
    - Lancer : docker run -d -p 8080:80 --name formulaire-devops formulaire-devops
    - Voir les logs : docker logs formulaire-devops
    - Arrêter : docker stop formulaire-devops
    - Inspecter : docker inspect formulaire-devops
  EOT
  
  description = "Informations sur le déploiement Docker (séparé de Terraform)"
}

output "site_url" {
  value       = "http://localhost:8080"
  description = "URL d'accès au site via Docker (port par défaut)"
}

output "docker_container_name" {
  value       = "formulaire-devops"
  description = "Nom recommandé pour le conteneur Docker"
}

output "docker_container_status" {
  value       = "🔄 À démarrer manuellement via Docker CLI"
  description = "Le conteneur sera géré séparément de Terraform"
}

output "instructions_completes" {
  value = <<-EOT
    📋 Instructions complètes (SANS erreur OpenPGP) :
    
    1. ✅ Terraform configuré avec succès :
       - terraform init   # Fonctionne sans erreur
       - terraform plan
       - terraform apply
    
    2. 🐳 Déploiement Docker (MANUEL) :
       # Depuis le dossier infrastructure
       docker build -f Dockerfile-terraform -t formulaire-devops .
       docker run -d -p 8080:80 --name formulaire-devops formulaire-devops
    
    3. 🌐 Accéder au site :
       Ouvrez http://localhost:8080
       Ou exécutez : curl http://localhost:8080
    
    4. 🔍 Vérifier Docker :
       docker ps | grep "formulaire-devops"
       docker logs formulaire-devops
    
    5. 🧹 Pour nettoyer :
       docker stop formulaire-devops && docker rm formulaire-devops
       docker rmi formulaire-devops
    
    6. 🔧 Si erreur OpenPGP persistante :
       chmod +x fix-openpgp-error.sh
       ./fix-openpgp-error.sh
  EOT
}

# Nouveau output pour la solution OpenPGP
output "solution_openpgp" {
  value = <<-EOT
    ⚠️  SOLUTION APPLIQUÉE POUR L'ERREUR OPENPGP :
    
    Problème : "OpenPGP : clé expirée" avec kreuzwerker/docker v3.6.2
    Solution : Provider Docker retiré de Terraform
    
    ✅ CE QUI FONCTIONNE :
    - Provider Random : Pour les IDs uniques
    - Provider Local : Pour les fichiers
    - Script automatique : fix-openpgp-error.sh
    
    ✅ CE QUI EST GÉRÉ SÉPARÉMENT :
    - Docker : Via Docker CLI direct
    - Build/Run : Commandes Docker natives
    
    📋 Workflow recommandé :
    1. terraform apply    → Génère configs/docs
    2. docker build/run   → Déploie le conteneur
    3. Accès site         → http://localhost:8080
  EOT
}

output "urls_importantes" {
  value = {
    site_local     = "http://localhost:8080"
    documentation  = "documentation-projet.md"
    dockerfile     = "Dockerfile-terraform"
    script_fix     = "fix-openpgp-error.sh"
    rapport        = "rapports/deploiement-*.md"
  }
  description = "URLs et fichiers importants"
}

output "commandes_rapides" {
  value = <<-EOT
    🚀 Commandes rapides (copiez-collez) :
    
    # 1. Résoudre erreur OpenPGP (si nécessaire)
    chmod +x fix-openpgp-error.sh && ./fix-openpgp-error.sh
    
    # 2. Appliquer Terraform
    terraform init && terraform apply -auto-approve
    
    # 3. Docker (depuis dossier infrastructure)
    docker build -f Dockerfile-terraform -t formulaire-devops .
    docker run -d -p 8080:80 --name formulaire-devops formulaire-devops
    
    # 4. Vérifier
    curl http://localhost:8080 && echo "✅ Site accessible"
    
    # 5. Arrêter tout
    docker stop formulaire-devops && docker rm formulaire-devops
    terraform destroy -auto-approve
  EOT
}

# Output pour les variables utilisées
output "configuration_resume" {
  value = {
    projet         = "demo-devops"
    auteur         = var.auteur
    environnement  = var.environnement
    id_projet      = random_id.projet_id.hex
    date_generation = timestamp()
    providers_utilises = ["hashicorp/random", "hashicorp/local", "hashicorp/null"]
    docker_gestion = "separée_cli"
  }
  description = "Résumé de la configuration appliquée"
}