# Complete

## Pre-requisites
Before this example can be used, please ensure that the following pre-requisites are met:
- Enable AWS Organizations and add AWS Accounts you want to be managed by SSO. [Documentation](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tutorials_basic.html)
- Enable AWS SSO. [Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/step1.html).
- Create AWS SSO entities (Users and Groups). [Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/addusers.html).
- Ensure that Terraform is using a role with permissions required for AWS SSO management. [Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/iam-auth-access-using-id-policies.html#requiredpermissionsconsole).
- If using Customer Managed Policies in permission sets, please make sure that policy exists (pre-created) in target AWS account.

## Diagram
![Alt text](aws_sso_diagram.png?raw=true "Title")

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.23 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.30 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sso"></a> [sso](#module\_sso) | avlcloudtechnologies/sso/aws |  |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.EKSAdmin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_developer_readonly_accounts"></a> [developer\_readonly\_accounts](#input\_developer\_readonly\_accounts) | n/a | `list` | <pre>[<br>  "shared-services",<br>  "productA-eks-prod"<br>]</pre> | no |
| <a name="input_developer_workload_accounts"></a> [developer\_workload\_accounts](#input\_developer\_workload\_accounts) | n/a | `list` | <pre>[<br>  "productA-eks-staging",<br>  "productA-eks-dev"<br>]</pre> | no |
| <a name="input_security_accounts"></a> [security\_accounts](#input\_security\_accounts) | n/a | `list` | <pre>[<br>  "security"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_ssoadmin_account_assignments"></a> [aws\_ssoadmin\_account\_assignments](#output\_aws\_ssoadmin\_account\_assignments) | Maps of account assignments to permission sets with keys user/group\_name.permission\_set\_name.account\_id and attributes listed in Terraform resource aws\_ssoadmin\_account\_assignment documentation. |
| <a name="output_aws_ssoadmin_permission_sets"></a> [aws\_ssoadmin\_permission\_sets](#output\_aws\_ssoadmin\_permission\_sets) | Maps of permission sets with attributes listed in Terraform resource aws\_ssoadmin\_permission\_set documentation. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->