variable "permission_sets" {
  description = "Map of maps containing Permission Set names as keys. See permission_sets description in README for information about map values."
  type        = any
  default = {
    AdministratorAccess = {
      description      = "Provides full access to AWS services and resources.",
      session_duration = "PT2H",
      managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
    }
  }
}

variable "account_assignments" {
  description = "List of maps containing mapping between user/group, permission set and assigned accounts list. See account_assignments description in README for more information about map values."
  type = list(object({
    principal_name = string,
    principal_type = string,
    permission_set = string,
    account_ids    = list(string)
  }))

  default = []
}

variable "identitystore_group_data_source_depends_on" {
  description = "List of parameters that identitystore group data sources depend on, for example new SSO group IDs."
  type        = list(string)
  default     = []
}

variable "identitystore_user_data_source_depends_on" {
  description = "List of parameters that identitystore user data sources depend on, for example new SSO user IDs."
  type        = list(string)
  default     = []
}