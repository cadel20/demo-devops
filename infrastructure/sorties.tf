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

# ⭐ NOUVEAU : Informations Docker
output "docker_info" {
  value = <<-EOT
    🐳 Informations Docker :
    
    Conteneur créé : ${docker_container.mon_site.name}
    Image utilisée : ${docker_container.mon_site.image}
    Port exposé : ${docker_container.mon_site.ports[0].external}
    
    🌐 Site accessible sur : http://localhost:${docker_container.mon_site.ports[0].external}
    
    Commandes Docker :
    - Voir les logs : docker logs ${docker_container.mon_site.name}
    - Arrêter : docker stop ${docker_container.mon_site.name}
    - Redémarrer : docker restart ${docker_container.mon_site.name}
    - Inspecter : docker inspect ${docker_container.mon_site.name}
  EOT
  
  description = "Informations sur le conteneur Docker créé"
  
  # Ne s'affiche que si le conteneur Docker est créé
  depends_on = [docker_container.mon_site]
}

output "site_url" {
  value       = "http://localhost:${docker_container.mon_site.ports[0].external}"
  description = "URL d'accès au site dans Docker"
  
  depends_on = [docker_container.mon_site]
}

output "docker_container_name" {
  value       = docker_container.mon_site.name
  description = "Nom du conteneur Docker"
}

output "docker_container_status" {
  value       = "✅ Conteneur Docker en cours d'exécution"
  description = "Statut du conteneur"
}

output "instructions_completes" {
  value = <<-EOT
    📋 Instructions complètes :
    
    1. Vérifiez le conteneur :
       docker ps | grep "${docker_container.mon_site.name}"
    
    2. Accédez au site :
       Ouvrez http://localhost:${docker_container.mon_site.ports[0].external}
       Ou exécutez : curl http://localhost:${docker_container.mon_site.ports[0].external}
    
    3. Pour nettoyer :
       terraform destroy -auto-approve
       Ou : docker stop ${docker_container.mon_site.name} && docker rm ${docker_container.mon_site.name}
    
    4. Pour reconstruire :
       terraform apply -auto-approve
  EOT
  
  depends_on = [docker_container.mon_site]
}