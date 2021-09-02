terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.11.1"
    }
  }
}

provider "digitalocean" {
  token = var.do-token
}

