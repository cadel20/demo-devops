# Configuration Terraform avec Docker - Mode développement
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
      version = "3.0.2"  # Version FIXE sans ~
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "docker" {
  # Laisser vide pour auto-détection
}

provider "local" {}
provider "random" {}