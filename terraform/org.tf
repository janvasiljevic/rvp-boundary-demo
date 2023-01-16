resource "boundary_scope" "global" {
  global_scope = true
  name         = "global"
  scope_id     = "global"
}

resource "boundary_scope" "org" {
  scope_id    = boundary_scope.global.id
  name        = "RVP"
  description = "RVP organization scope"
}

resource "boundary_scope" "project_rk" {
  name        = "rk"
  description = "Racunalniske komunikacije"
  scope_id    = boundary_scope.org.id

  auto_create_admin_role   = false
  auto_create_default_role = false
}

# u_anon is a special user that isn't authenticated 
# we must allow him, to view the auth methods, scopes and his own account
# (global scope)
resource "boundary_role" "global_anon_listing" {
  scope_id = boundary_scope.global.id
  grant_strings = [
    "id=*;type=auth-method;actions=list,authenticate",
    "type=scope;actions=list",
    "id={{account.id}};actions=read,change-password"
  ]
  principal_ids = ["u_anon"]
}

# u_anon is a special user that isn't authenticated 
# we must allow him, to view the auth methods, scopes and his own account
# (RVP scope)
resource "boundary_role" "org_anon_listing" {
  scope_id = boundary_scope.org.id
  grant_strings = [
    "id=*;type=auth-method;actions=list,authenticate",
    "type=scope;actions=list",
    "id={{account.id}};actions=read,change-password"
  ]
  principal_ids = ["u_anon"]
}

