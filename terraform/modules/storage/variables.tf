variable "environment" {
  description = "This is the environment where your container is deployed. desarrollo, test and prod"
}

variable "customer" {}

variable "project" {}

variable "az" {}

variable "location" {
  description = "azure location to deploy resources"
}

#variable "container_name" {
#  description = "Container name"
#}

variable "resource_group_name" {
  description = "name of the resource group to deploy storage account"
}

variable "account_tier" {}

variable "container_name" {
  description = "The list of names of the Container Names."
  type        = list(string)
  default     = []
}
