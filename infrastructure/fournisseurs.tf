# Configuration Terraform avec Docker
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
      version = "~> 3.0"
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Provider Docker avec détection automatique du système
provider "docker" {
  # Détection automatique pour Windows/Linux/Mac
  # Terraform choisira le bon host selon votre OS
}

provider "local" {}
provider "random" {}