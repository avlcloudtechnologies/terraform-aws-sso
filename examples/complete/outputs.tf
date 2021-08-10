output "aws_ssoadmin_permission_sets" {
  description = "Maps of permission sets with attributes listed in Terraform resource aws_ssoadmin_permission_set documentation."
  value       = module.sso.aws_ssoadmin_permission_sets
}

output "aws_ssoadmin_account_assignments" {
  description = "Maps of account assignments to permission sets with keys user/group_name.permission_set_name.account_id and attributes listed in Terraform resource aws_ssoadmin_account_assignment documentation."
  value       = module.sso.aws_ssoadmin_account_assignments
}
