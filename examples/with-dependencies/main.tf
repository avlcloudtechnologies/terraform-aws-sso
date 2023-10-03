provider "aws" {
  region = "eu-west-1"
}

data "aws_organizations_organization" "this" {}

locals {
  all_active_accounts_map            = { for account in toset(data.aws_organizations_organization.this.accounts) : account.name => account if account.status == "ACTIVE" }
  non_management_active_accounts_map = { for account in toset(data.aws_organizations_organization.this.non_master_accounts) : account.name => account if account.status == "ACTIVE" }
  sso_groups = {
    management = {
      description = "Group with Administrator access to all accounts including Management account"
    },
    admins = {
      description = "Group with Administrator access to all accounts excluding Management account"
    },
    readonly = {
      description = "Group for Read only access"
    }
  }
  sso_users = {
    aurimas = {
      display_name = "aurimas"
      given_name   = "Aurimas"
      family_name  = "Mickevicius"
      sso_groups   = ["management", "readonly"]
    },
    john = {
      display_name = "john"
      given_name   = "John"
      family_name  = "Smith"
      sso_groups   = ["admins", "readonly"]
    }
  }
}

module "sso" {
  source = "avlcloudtechnologies/sso/aws"

  permission_sets = {
    AdministratorAccess = {
      description      = "Provides full access to AWS services and resources.",
      session_duration = "PT2H",
      managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    },
    ViewOnlyAccess = {
      description      = "View resources and basic metadata across all AWS services.",
      session_duration = "PT2H",
      managed_policies = ["arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"]
    },
  }
  account_assignments = [
    {
      principal_name = "management"
      principal_type = "GROUP"
      permission_set = "AdministratorAccess"
      account_ids    = [for account in local.all_active_accounts_map : account.id]
    },
    {
      principal_name = "admins"
      principal_type = "GROUP"
      permission_set = "AdministratorAccess"
      account_ids    = [for account in local.non_management_active_accounts_map : account.id]
    },
    {
      principal_name = "readonly"
      principal_type = "GROUP"
      permission_set = "ViewOnlyAccess"
      account_ids    = [for account in local.non_management_active_accounts_map : account.id]
    },
  ]
  identitystore_group_data_source_depends_on = [for group in module.aws_identitystore.groups : group.group_id]
}

module "aws_identitystore" {
  source  = "avlcloudtechnologies/identitystore/aws"
  version = "0.1.1"

  sso_users  = var.sso_users
  sso_groups = var.sso_groups
}