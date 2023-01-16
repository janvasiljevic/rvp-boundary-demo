path "rk/data/*" {
  capabilities = ["read"]
}

# To list SSH secrets paths
path "rk-ssh/*" {
  capabilities = [ "list" ]
}

# To use the configured SSH secrets engine otp_key_role role
path "rk-ssh/creds/otp_key_role" {
  capabilities = ["create", "read", "update"]
}