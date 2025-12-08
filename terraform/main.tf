terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "app" {
  name         = "cadel2/demo-devops-app:latest"
  keep_locally = true
}

resource "docker_container" "web" {
  name  = "site-cadel-auto"
  image = docker_image.app.name
  ports {
    internal = 80
    external = 8080
  }
}