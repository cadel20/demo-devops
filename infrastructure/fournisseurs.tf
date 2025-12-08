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
    
    # ⭐ ALTERNATIVE : Provider Docker officieux sans problème GPG
    docker = {
      source  = "terraform.local/local/docker"  # Provider local
      version = "1.0.0"
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}