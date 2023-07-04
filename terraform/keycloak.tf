resource "keycloak_realm" "realm" {
  realm   = "boundary"
  enabled = true
}

resource "keycloak_realm_events" "events" {
  realm_id = keycloak_realm.realm.id

  admin_events_enabled         = true
  admin_events_details_enabled = true

  events_listeners = ["jboss-logging"]

  events_enabled = true
}

resource "keycloak_openid_client" "openid_client" {
  realm_id  = keycloak_realm.realm.id
  client_id = "boundary_client"

  name                  = "vault"
  enabled               = true
  standard_flow_enabled = true

  access_type = "CONFIDENTIAL"

  root_url = var.boundary_host

  valid_redirect_uris = [
    "${var.boundary_host}/v1/auth-methods/oidc:authenticate:callback"
  ]

  web_origins = [var.boundary_host]
}

resource "keycloak_user" "name" {
  username = "test"
  realm_id = keycloak_realm.realm.id
  initial_password {
    value     = "12345678"
    temporary = false
  }
}

# Settings found here: https://github.com/keycloak/keycloak/blob/bfce612641a70e106b20b136431f0e4046b5c37f/services/src/main/java/org/keycloak/social/github/GitHubIdentityProvider.java
resource "keycloak_oidc_identity_provider" "github_idp" {
  realm = keycloak_realm.realm.id
  alias = "github"

  provider_id = "github"

  display_name = "GitHub"

  enabled = true

  client_id     = local.envs["GH_CLIENT_ID"]
  client_secret = local.envs["GH_CLIENT_SECRET"]

  authorization_url = "https://github.com/login/oauth/authorize"
  token_url         = "https://github.com/login/oauth/access_token"
  user_info_url     = "https://api.github.com/user"
  default_scopes    = "user:email"
}


# Settings found here: https://github.com/keycloak/keycloak/blob/bfce612641a70e106b20b136431f0e4046b5c37f/services/src/main/java/org/keycloak/social/gitlab/GitLabIdentityProvider.java
resource "keycloak_oidc_identity_provider" "gitlab_idp" {
  realm = keycloak_realm.realm.id
  alias = "gitlab"

  provider_id = "gitlab"

  display_name = "GitLab"

  enabled = true

  client_id     = local.envs["GL_CLIENT_ID"]
  client_secret = local.envs["GL_CLIENT_SECRET"]

  authorization_url = "https://gitlab.com/oauth/authorize"
  token_url         = "https://gitlab.com/oauth/token"
  user_info_url     = "https://gitlab.com/api/v4/user"
  default_scopes    = "openid read_user email"
}
