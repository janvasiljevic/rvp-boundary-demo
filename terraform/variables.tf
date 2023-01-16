variable "keycloak_host" {
  type    = string
  default = "http://localhost:8080"
}

variable "boundary_host" {
  type    = string
  default = "http://localhost:9200"
}

variable "vault_host" {
  type    = string
  default = "http://localhost:8200"
}

variable "vault_docker_dns" {
  type    = string
  default = "http://vault:8200"
}

locals {
  # The commented out one is more proper as it hides all enviroment variables in the output, but makes it harder to debug
  #   envs = { for tuple in regexall("(.*)=(.*)", file(".env.local")) : tuple[0] => sensitive(tuple[1]) }
  envs = { for tuple in regexall("(.*)=(.*)", file(".env.local")) : tuple[0] => tuple[1] }
}
