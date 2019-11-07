# Existing infrastructure

data "azuread_users" "users" {
  user_principal_names = "${var.group_members_user_principal_name}"
}

# New infrastructure

resource "azuread_group" "group" {
  name    = "${local.azuread_group_name}"
  members = ["${data.azuread_users.users.object_ids}"]
}
