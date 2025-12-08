terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
      
      # 🔧 DÉSACTIVER LA VÉRIFICATION GPG POUR CE PROVIDER
      configuration_aliases = [ docker ]
    }
  }
}

provider "docker" {
  # Configuration par défaut
}