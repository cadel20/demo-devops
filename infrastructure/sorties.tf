# Variables de sortie

output "message_bienvenue" {
  value = <<-EOT
    🎉 Terraform configuré avec succès !
    
    Projet: demo-devops
    Auteur: ${var.auteur}
    Environnement: ${var.environnement}
    
    Commandes disponibles:
    - terraform init    # Initialiser
    - terraform plan    # Voir le plan
    - terraform apply   # Appliquer
  EOT
}

output "fichiers_crees" {
  value = [
    local_file.documentation_projet.filename,
    local_file.docker_config.filename,
    local_file.rapport_deploiement.filename
  ]
  description = "Liste des fichiers créés par Terraform"
}

output "id_projet" {
  value       = random_id.projet_id.hex
  description = "ID unique du projet"
}