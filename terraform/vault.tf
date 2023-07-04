
resource "vault_policy" "boundary_controller" {
  name   = "boundary-controller"
  policy = file("${path.module}/vault/boundary-controller-policy.hcl")
}

resource "vault_policy" "kv-read" {
  name   = "kv-read"
  policy = file("${path.module}/vault/kv-policy.hcl")
}

resource "vault_mount" "rk" {
  path        = "rk"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount - For RK"
}

resource "vault_mount" "rk_ssh" {
  type        = "ssh"
  path        = "rk-ssh"
  description = "SSH secret engine mount - For RK"
}

resource "vault_ssh_secret_backend_role" "otp_key_role" {
  name          = "otp_key_role"
  key_type      = "otp"
  default_user  = "ubuntu"
  allowed_users = "ubuntu,jan"
  # cidr_list    = "10.1.0.0/24"
  cidr_list = "0.0.0.0/0"
  backend   = vault_mount.rk_ssh.path
}

# Key path is rk/data/my-secret
# This is just a test secret, not actually used
resource "vault_kv_secret_v2" "test_secret" {
  mount = vault_mount.rk.path
  name  = "my-secret"

  data_json = jsonencode({
    username    = "admin"
    private_key = "add_path_to_private_key"
  })
}

# Key path is rk/data/vm_01_username_password
resource "vault_kv_secret_v2" "vm_01_username_password" {
  mount = vault_mount.rk.path
  name  = "vm_01_username_password"

  data_json = jsonencode({
    username = "jan"
    password = "12345678"
  })
}

# Key path is rk/data/vm_02_username_private_key
resource "vault_kv_secret_v2" "vm_02_username_private_key" {
  mount = vault_mount.rk.path
  name  = "vm_02_username_private_key"

  data_json = jsonencode({
    username    = "vm02user"
    private_key = file("${path.module}/../configs/openssh/vm02/key")
  })
}

# Create a token for boundary controller
# And reading kv-v2 secrets
resource "vault_token" "boundary_token" {
  no_default_policy = true
  policies = [
    vault_policy.boundary_controller.name,
    vault_policy.kv-read.name
  ]
  period    = "20m"
  renewable = true
  no_parent = true
}

# https://github.com/hashicorp/boundary/issues/1764
