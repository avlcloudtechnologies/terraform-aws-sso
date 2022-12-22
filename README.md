# AWS SSO Terraform module
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/avlcloudtechnologies/terraform-aws-sso)

This module handles creation of AWS SSO permission sets and assignment to AWS SSO entities and AWS Accounts.

## Pre-requisites
Before this module can be used, please ensure that the following pre-requisites are met:
- Enable AWS Organizations and add AWS Accounts you want to be managed by SSO. [Documentation](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tutorials_basic.html)
- Enable AWS SSO. [Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/step1.html).
- Create AWS SSO entities (Users and Groups) [Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/addusers.html) or use identitystore [module](https://github.com/avlcloudtechnologies/terraform-aws-identitystore).
- Ensure that Terraform is using a role with permissions required for AWS SSO management. [Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/iam-auth-access-using-id-policies.html#requiredpermissionsconsole).

## Usage
More complex examples can be found in the [examples](https://github.com/avlcloudtechnologies/terraform-aws-sso/tree/master/examples) directory. Simple use case:


```hcl
module "sso" {
  source  = "avlcloudtechnologies/sso/aws"

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
      account_ids    = ["123456789", "234567890"]
    },
  ]
}
```

## `permission_sets` and `account_assignments`

`permission_sets` is a map of maps. Key is used as unique value for `for_each` resources. Inner map has the following keys/value pairs.

| Name | Description | Type | If unset |
|------|-------------|:----:|:-----:|
| description | (Optional) The description of the Permission Set. | string | Provider default behavior |
| relay\_state | (Optional) The relay state URL used to redirect users within the application during the federation authentication process | string | Provider default behavior. |
| session\_duration | (Optional) The length of time that the application user sessions are valid in the ISO-8601 standard | string | Provider default behavior. |
| tags | (Optional) Key-value map of resource tags. | string | Provider default behavior |
| managed\_policies | (Optional) List of Managed IAM policies that are attached to permission set. | list(string) | Managed Policies not set. |
| inline\_policy | (Optional) Inline policy that is attached to permission set. | string | Inline policy not set. |

`account_assignments` is a list of maps which have the following keys/value pairs.

| Name | Description | Type | If unset |
|------|-------------|:----:|:-----:|
| principal\_name | (Required) Name of the SSO entity that you want to assign the Permission Set. | string | Required |
| principal\_type | (Required) Type of the SSO entity that you want to assign the Permission Set. Valid values: USER, GROUP | string | Required |
| permission\_set | (Required) Name of the Permission Set which will be granted to SSO entity on specified AWS accounts. | string | Required | 
| account\_ids | (Required) AWS account IDs. | list | Required |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.23 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.34 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.34 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssoadmin_account_assignment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_customer_managed_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_customer_managed_policy_attachment) | resource |
| [aws_ssoadmin_managed_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [aws_identitystore_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_identitystore_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user) | data source |
| [aws_ssoadmin_instances.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_assignments"></a> [account\_assignments](#input\_account\_assignments) | List of maps containing mapping between user/group, permission set and assigned accounts list. See account\_assignments description in README for more information about map values. | <pre>list(object({<br>    principal_name = string,<br>    principal_type = string,<br>    permission_set = string,<br>    account_ids    = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_permission_sets"></a> [permission\_sets](#input\_permission\_sets) | Map of maps containing Permission Set names as keys. See permission\_sets description in README for information about map values. | `any` | <pre>{<br>  "AdministratorAccess": {<br>    "description": "Provides full access to AWS services and resources.",<br>    "managed_policies": [<br>      "arn:aws:iam::aws:policy/AdministratorAccess"<br>    ],<br>    "session_duration": "PT2H"<br>  }<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_ssoadmin_account_assignments"></a> [aws\_ssoadmin\_account\_assignments](#output\_aws\_ssoadmin\_account\_assignments) | Maps of account assignments to permission sets with keys user/group\_name.permission\_set\_name.account\_id and attributes listed in Terraform resource aws\_ssoadmin\_account\_assignment documentation. |
| <a name="output_aws_ssoadmin_permission_sets"></a> [aws\_ssoadmin\_permission\_sets](#output\_aws\_ssoadmin\_permission\_sets) | Maps of permission sets with attributes listed in Terraform resource aws\_ssoadmin\_permission\_set documentation. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->