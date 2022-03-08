variable "environment" {
  description = "This is the environment where your cluster is deployed. dev, test, or prod"
}

variable "az" {}

variable "resource_group_name" {
  description = "resource group that the vnet resides in"
}

variable "address_space" {}
variable "subnet_cidr" {
  description = "the subnet cidr range"
}

variable "location" {}

variable "customer" {}

variable "project" {}
