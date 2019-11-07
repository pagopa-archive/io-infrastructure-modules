output "azuread_group_name" {
  description = "The name of the group created."
  value       = "${local.azuread_group_name}"
}

output "azuread_group_object_id" {
  description = "The name of the group created."
  value       = "${azuread_group.group.id}"
}

output "azuread_group_members" {
  description = "The list of users added to the group."
  value       = "${data.azuread_users.users.user_principal_names}"
}
