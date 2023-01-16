terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "1.1.3"
    }

    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 4.0.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.12.0"
    }
  }
}

provider "boundary" {
  addr             = var.boundary_host
  recovery_kms_hcl = <<EOT
kms "aead" {
  purpose = "recovery"
  aead_type = "aes-gcm"
  key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
  key_id = "global_recovery"
}
EOT
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = "admin"
  password  = "admin"
  url       = var.keycloak_host
}

provider "vault" {
  address = var.vault_host
  token   = "root"
}
