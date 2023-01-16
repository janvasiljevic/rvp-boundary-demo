resource "boundary_credential_store_vault" "vault" {
  name        = "vault"
  description = "Vault credential store"
  scope_id    = boundary_scope.project_rk.id
  address     = var.vault_docker_dns
  token       = vault_token.boundary_token.client_token
}

resource "boundary_credential_library_vault" "vm_01_username_password" {
  name                = "vm_01_username_password"
  description         = "Vault credential library for VM01 Username Password access"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "rk/data/vm_01_username_password"
  http_method         = "GET"
  credential_type     = "username_password"
  # The secret needs an attribute username and password
}

resource "boundary_credential_library_vault" "vm_02_username_private_key" {
  name                = "vm_02_username_private_key"
  description         = "Vault credential library for VM02 Username + SSH access"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "rk/data/vm_02_username_private_key"
  http_method         = "GET"
  credential_type     = "ssh_private_key"

  # The secret needs an attribute username and private_key
}

resource "boundary_credential_library_vault" "vm_03_otp" {
  name                = "vm_03_otp"
  description         = "Vault credential library for VM03 OTP access"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "rk-ssh/creds/otp_key_role"
  http_method         = "POST"
  credential_type     = "username_password"
  http_request_body   = <<EOT
{
  "ip": "10.1.0.103"
}
EOT
  credential_mapping_overrides = {
    password_attribute = "key"
    username_attribute = "username"
  }
  # The secret needs an attribute username and password
}


resource "boundary_credential_library_vault" "vm_04_otp" {
  name                = "vm_04_otp"
  description         = "Vault credential library for VM04 OTP access"
  credential_store_id = boundary_credential_store_vault.vault.id
  path                = "rk-ssh/creds/otp_key_role"
  http_method         = "POST"
  credential_type     = "username_password"
  http_request_body   = <<EOT
{
  "ip": "10.1.0.104"
}
EOT
  credential_mapping_overrides = {
    password_attribute = "key"
    username_attribute = "username"
  }
  # The secret needs an attribute username and password
}


# Some additional stuff that might be useful:

# resource "boundary_credential_library_vault" "vault_store" {
#   for_each = {
#     for db_name, db in local.scope : format("%s-%s",db.scope_name,db.db_name) => db
#   }
#   name                = format("%s-%s",each.value.scope_name,each.value.db_name)
#   description         = each.value.description
#   credential_store_id = boundary_credential_store_vault.vault_store[each.value.scope_name].id
#   path                = format("database/creds/%s-%s",each.value.scope_name,each.value.db_name)
#   http_method         = "GET"
#   credential_type     = "username_password"
#   credential_mapping_overrides = {
#     username_attribute = "{{.Account.Name}}"
#   }
# }
