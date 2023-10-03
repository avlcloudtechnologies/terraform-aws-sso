output "aws_ssoadmin_permission_sets" {
  description = "Maps of permission sets with attributes listed in Terraform resource aws_ssoadmin_permission_set documentation."
  value       = module.sso.aws_ssoadmin_permission_sets
}
