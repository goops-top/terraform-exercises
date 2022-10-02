terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:1.23.1"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = "nginx:1.23.1"
  name  = "CloudNativeOps"
  ports {
    internal = 80
    external = 8000
  }
}

