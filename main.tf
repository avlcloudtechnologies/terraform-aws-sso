locals {
  ssoadmin_instance_arn = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  managed_ps            = { for ps_name, ps_attrs in var.permission_sets : ps_name => ps_attrs if can(ps_attrs.managed_policies) }
  customer_managed_ps   = { for ps_name, ps_attrs in var.permission_sets : ps_name => ps_attrs if can(ps_attrs.customer_managed_policies) }
  # create ps_name and managed policy maps list
  ps_policy_maps = flatten([
    for ps_name, ps_attrs in local.managed_ps : [
      for policy in ps_attrs.managed_policies : {
        ps_name    = ps_name
        policy_arn = policy
      } if can(ps_attrs.managed_policies)
    ]
  ])
  # create ps_name and customer managed policy maps list
  customer_ps_policy_maps = flatten([
    for ps_name, ps_attrs in local.customer_managed_ps : [
      for policy in ps_attrs.customer_managed_policies : {
        ps_name     = ps_name
        policy_name = policy
      } if can(ps_attrs.customer_managed_policies)
    ]
  ])
  account_assignments = flatten([
    for assignment in var.account_assignments : [
      for account_id in assignment.account_ids : {
        principal_name = assignment.principal_name
        principal_type = assignment.principal_type
        permission_set = aws_ssoadmin_permission_set.this[assignment.permission_set]
        account_id     = account_id
      }
    ]
  ])
  groups = [for assignment in var.account_assignments : assignment.principal_name if assignment.principal_type == "GROUP"]
  users  = [for assignment in var.account_assignments : assignment.principal_name if assignment.principal_type == "USER"]
}

data "aws_ssoadmin_instances" "this" {}

data "aws_identitystore_group" "this" {
  for_each          = toset(local.groups)
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value
    }
  }
}

data "aws_identitystore_user" "this" {
  for_each          = toset(local.users)
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.value
    }
  }
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each = var.permission_sets

  name             = each.key
  description      = lookup(each.value, "description", null)
  instance_arn     = local.ssoadmin_instance_arn
  relay_state      = lookup(each.value, "relay_state", null)
  session_duration = lookup(each.value, "session_duration", null)
  tags             = lookup(each.value, "tags", {})
}

resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each = { for ps_name, ps_attrs in var.permission_sets : ps_name => ps_attrs if can(ps_attrs.inline_policy) }

  inline_policy      = each.value.inline_policy
  instance_arn       = local.ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
}

resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each = { for ps in local.ps_policy_maps : "${ps.ps_name}.${ps.policy_arn}" => ps }

  instance_arn       = local.ssoadmin_instance_arn
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.ps_name].arn
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "this" {
  for_each = { for ps in local.customer_ps_policy_maps : "${ps.ps_name}.${ps.policy_name}" => ps }

  instance_arn       = local.ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.ps_name].arn
  customer_managed_policy_reference {
    name = each.value.policy_name
    path = "/"
  }
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = { for assignment in local.account_assignments : "${assignment.principal_name}.${assignment.permission_set.name}.${assignment.account_id}" => assignment }

  instance_arn       = each.value.permission_set.instance_arn
  permission_set_arn = each.value.permission_set.arn
  principal_id       = each.value.principal_type == "GROUP" ? data.aws_identitystore_group.this[each.value.principal_name].id : data.aws_identitystore_user.this[each.value.principal_name].id
  principal_type     = each.value.principal_type

  target_id   = each.value.account_id
  target_type = "AWS_ACCOUNT"
}