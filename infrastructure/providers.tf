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
