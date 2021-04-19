variable "developer_readonly_accounts" {
  default = ["shared-services", "productA-eks-prod"]
}
variable "developer_workload_accounts" {
  default = ["productA-eks-staging", "productA-eks-dev"]
}

variable "security_accounts" {
  default = ["security"]
}
