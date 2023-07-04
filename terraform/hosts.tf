# This represents a host catalog for virtual machiens in VMWare 
resource "boundary_host_catalog_static" "vmware" {
  name        = "VMWare"
  description = "VMWare virtual machines"
  scope_id    = boundary_scope.project_rk.id
}

# An array of the 4 "pcs" declared in the docker compose
# Each is an openssh server
variable "vmware_pcs" {
  type    = set(string)
  default = ["vm-01", "vm-02", "vm-03", "vm-04"]
}

# Create 4 hosts corresponding to "vmware_pcs" variable
resource "boundary_host_static" "vmware_pcs_host" {
  for_each = var.vmware_pcs

  name            = "PC: ${each.value}"
  type            = "static"
  description     = "${each.value} is a virtual machine"
  address         = each.value
  host_catalog_id = boundary_host_catalog_static.vmware.id
}

# Create 4 Host sets, each with 1 host
resource "boundary_host_set_static" "vmware_pcs_host_set" {
  for_each = var.vmware_pcs

  name        = "PC Host set: ${each.value}"
  type        = "static"
  description = "${each.value} is a virtual machine"
  host_ids = [
    boundary_host_static.vmware_pcs_host[each.value].id
  ]
  host_catalog_id = boundary_host_catalog_static.vmware.id
}


resource "boundary_target" "ssh_vm01" {

  type                     = "tcp"
  name                     = "SSH to: vm-01"
  description              = "SSH server"
  scope_id                 = boundary_scope.project_rk.id
  session_connection_limit = -1
  session_max_seconds      = 28800
  default_port             = 2222


  brokered_credential_source_ids = [boundary_credential_library_vault.vm_01_username_password.id]

  host_source_ids = [boundary_host_set_static.vmware_pcs_host_set["vm-01"].id]
}

resource "boundary_target" "ssh_vm02" {

  type                     = "tcp"
  name                     = "SSH to: vm-02"
  description              = "SSH server"
  scope_id                 = boundary_scope.project_rk.id
  session_connection_limit = -1
  session_max_seconds      = 28800
  default_port             = 2222


  brokered_credential_source_ids = [boundary_credential_library_vault.vm_02_username_private_key.id]

  host_source_ids = [boundary_host_set_static.vmware_pcs_host_set["vm-02"].id]
}


resource "boundary_target" "ssh_vm03" {

  type                     = "tcp"
  name                     = "SSH to: vm-03"
  description              = "SSH server"
  scope_id                 = boundary_scope.project_rk.id
  session_connection_limit = -1
  session_max_seconds      = 28800
  default_port             = 22

  brokered_credential_source_ids = [boundary_credential_library_vault.vm_03_otp.id]

  host_source_ids = [boundary_host_set_static.vmware_pcs_host_set["vm-03"].id]
}

resource "boundary_target" "ssh_vm04" {

  type                     = "tcp"
  name                     = "SSH to: vm-04"
  description              = "SSH server"
  scope_id                 = boundary_scope.project_rk.id
  session_connection_limit = -1
  session_max_seconds      = 28800
  default_port             = 22

  brokered_credential_source_ids = [boundary_credential_library_vault.vm_04_otp.id]

  host_source_ids = [boundary_host_set_static.vmware_pcs_host_set["vm-04"].id]
}


output "vm_01_connect" {
  value = "boundary connect ssh -target-id ${boundary_target.ssh_vm01.id}"
}

output "vm_02_connect" {
  value = "boundary connect ssh -target-id ${boundary_target.ssh_vm02.id}"
}

output "vm_03_connect" {
  value = "boundary connect ssh -target-id ${boundary_target.ssh_vm03.id}"
}

output "vm_04_connect" {
  value = "boundary connect ssh -target-id ${boundary_target.ssh_vm04.id}"
}
