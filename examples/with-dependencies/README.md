# Simple
Example showing how to create SSO users and groups in the same state file as `terraform-aws-sso` module resources and without adding `depends_on` argument at the module level. Using null resource, it will only recreate account assignments, when new SSO group is added. It will NOT re-create all module resources, after a new AWS Account is added. 

## Pre-requisites
Before this example can be used, please ensure that the following pre-requisites are met:
- Enable AWS Organizations and add AWS Accounts you want to be managed by SSO. [Documentation](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_tutorials_basic.html)
- Enable AWS SSO. [Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/step1.html).
- Ensure that Terraform is using a role with permissions required for AWS SSO management. [Documentation](https://docs.aws.amazon.com/singlesignon/latest/userguide/iam-auth-access-using-id-policies.html#requiredpermissionsconsole).


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.23 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.27 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_identitystore"></a> [aws\_identitystore](#module\_aws\_identitystore) | avlcloudtechnologies/identitystore/aws | 0.1.1 |
| <a name="module_sso"></a> [sso](#module\_sso) | avlcloudtechnologies/sso/aws |  |

## Resources

| Name | Type |
|------|------|
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_ssoadmin_permission_sets"></a> [aws\_ssoadmin\_permission\_sets](#output\_aws\_ssoadmin\_permission\_sets) | Maps of permission sets with attributes listed in Terraform resource aws\_ssoadmin\_permission\_set documentation. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->