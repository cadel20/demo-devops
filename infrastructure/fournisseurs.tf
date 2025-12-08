# Configuration avec les versions DÉJÀ installées sur votre système
terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"  # Version déjà installée sur votre système
    }
    
    local = {
      source  = "hashicorp/local"
      version = "2.6.1"  # Version déjà installée sur votre système
    }
    
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"  # Version déjà installée
    }
  }
}

provider "random" {}
provider "local" {}
provider "null" {}