resource "boundary_auth_method" "password" {
  name        = "Username and Password - Testing"
  description = "Password auth method for org"
  type        = "password"
  scope_id    = boundary_scope.org.id
}

resource "boundary_account_password" "test_account" {
  name           = "test_account"
  description    = "Test password account"
  type           = "password"
  login_name     = "tester01"
  password       = "supersecure"
  auth_method_id = boundary_auth_method.password.id
}

resource "boundary_user" "tester01" {
  name        = "tester01"
  description = "A test user"
  account_ids = [
    boundary_account_password.test_account.id
  ]
  scope_id = boundary_scope.org.id
}

output "sample_admin_login" {
  value = "export BOUNDARY_PASS=supersecure; export BOUNDARY_TOKEN=$(boundary authenticate password -auth-method-id=${boundary_auth_method.password.id} -login-name=${boundary_account_password.test_account.login_name} -password=env://BOUNDARY_PASS -keyring-type=none -format=json | jq -r '.item.attributes.token')"
}
