# Configuration Terraform SANS Docker (temporaire)
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
    
    # ⚠️ COMMENTÉ TEMPORAIREMENT - problème GPG
    # docker = {
    #   source  = "kreuzwerker/docker"
    #   version = "~> 3.0"
    # }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

# ⚠️ Provider Docker commenté temporairement
# provider "docker" {}

provider "local" {}
provider "random" {}