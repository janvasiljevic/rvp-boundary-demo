# An Admin in the RVP Org
resource "boundary_role" "global_admin" {
  name           = "admin"
  description    = "A role with admin permissions"
  scope_id       = "global"
  grant_scope_id = boundary_scope.org.id
  principal_ids = [
    boundary_user.tester01.id,                 # Include the test user as admin  
    boundary_managed_group.oidc_group_admin.id # Include janvasiljevic as admin
  ]
  grant_strings = ["id=*;type=*;actions=*"]
}

# Administrataor Role for the RK Project
resource "boundary_role" "proj_admin" {
  scope_id       = boundary_scope.org.id
  grant_scope_id = boundary_scope.project_rk.id
  grant_strings  = ["id=*;type=*;actions=*"]
  principal_ids = [
    boundary_user.tester01.id,                 # Include the test user as admin  
    boundary_managed_group.oidc_group_admin.id # Include janvasiljevic as admin
  ]
}

# Give everyone connecting from Keycloak read-only access to the RK ORG
resource "boundary_role" "read-only" {
  name          = "read-only"
  description   = "Role with read-only permission"
  scope_id      = boundary_scope.org.id
  principal_ids = [boundary_managed_group.oidc_group_all.id]
  grant_strings = ["id=*;type=*;actions=read,list"]
}

# A Managed Group for the OIDC Auth Method 
# Filter is based on the preferred_username claim
resource "boundary_managed_group" "oidc_group_admin" {
  name        = "managed_group_janv"
  description = "Managed Group for Keycloak - janvasiljevic"


  auth_method_id = boundary_auth_method_oidc.oidc.id

  filter = "\"/userinfo/preferred_username\" == \"janvasiljevic\""
}


# A Managed Group for the OIDC Auth Method
# Includes all users in the OIDC Auth Method
resource "boundary_managed_group" "oidc_group_all" {
  name        = "managed_group_all"
  description = "Managed Group for Keycloak - Include all users"

  auth_method_id = boundary_auth_method_oidc.oidc.id

  filter = "\"/userinfo/preferred_username\" matches \".*\""
}


