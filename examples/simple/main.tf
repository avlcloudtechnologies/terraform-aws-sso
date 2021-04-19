provider "aws" {
  region = "eu-west-1"
}

data "aws_organizations_organization" "this" {}

locals {
  all_accounts_names            = [for account in toset(data.aws_organizations_organization.this.accounts) : account.name]
  all_accounts_map              = zipmap(local.all_accounts_names, tolist(toset(data.aws_organizations_organization.this.accounts)))
  non_management_accounts_names = [for account in toset(data.aws_organizations_organization.this.non_master_accounts) : account.name]
  non_management_accounts_map   = zipmap(local.non_management_accounts_names, tolist(toset(data.aws_organizations_organization.this.non_master_accounts)))
}

module "sso" {
  source = "avlcloudtechnologies/sso/aws"

  permission_sets = {
    AdministratorAccess = {
      description      = "Provides full access to AWS services and resources.",
      session_duration = "PT2H",
      managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    },
  }
  account_assignments = [
    {
      principal_name = "management"
      principal_type = "GROUP"
      permission_set = "AdministratorAccess"
      account_ids    = [for account in local.all_accounts_map : account.id]
    },
  ]
}
