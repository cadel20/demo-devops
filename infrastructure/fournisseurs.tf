# Configuration Terraform avec Docker - Version corrigée
terraform {
  required_version = ">= 1.0"
  
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
      version = "~> 3.0.2"  # Version spécifique sans problème GPG
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Provider Docker avec configuration sécurisée
provider "docker" {
  # Configuration par défaut - Terraform détectera automatiquement
  # Pas besoin de spécifier 'host' dans la plupart des cas
}

provider "local" {}
provider "random" {}