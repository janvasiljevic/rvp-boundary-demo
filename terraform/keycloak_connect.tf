# Need to run: 
# socat TCP-LISTEN:8080,fork TCP:keycloak:8080 &
# On the following container
resource "boundary_auth_method_oidc" "oidc" {
  name        = "Keycloak"
  description = "OIDC auth method for Keycloak"
  scope_id    = boundary_scope.org.id

  issuer = "${var.keycloak_host}/realms/${keycloak_realm.realm.realm}"

  client_id     = keycloak_openid_client.openid_client.client_id
  client_secret = keycloak_openid_client.openid_client.client_secret

  callback_url       = "${var.boundary_host}/v1/auth-methods/oidc:authenticate:callback"
  signing_algorithms = ["RS256"]
  api_url_prefix     = var.boundary_host

  state                = "active-public"
  is_primary_for_scope = true
  max_age              = 0
}


output "keycloak_login" {
  value = "export BOUNDARY_TOKEN=$(boundary authenticate oidc -auth-method-id=${boundary_auth_method_oidc.oidc.id} -keyring-type=none -format=json | jq -r '.item.attributes.token')"
}
