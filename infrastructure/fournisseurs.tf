# Configuration Terraform
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    # Pour les ressources locales
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    
    # Pour générer des données aléatoires
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
  
  # Configuration du backend (état) - Local
  backend "local" {
    path = "terraform.tfstate"
  }
}