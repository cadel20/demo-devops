# Configuration minimale et sécurisée
terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
}

provider "random" {}
provider "local" {}