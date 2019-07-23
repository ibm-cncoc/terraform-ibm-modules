variable "resource_group" {
    type = "string"
    description = "resource group name where you want to create the resource"
    default = "default"
}

variable "pfx" {
  type        = "string"
  description = "add prefix to the name of the resource created by this module (This helps you identify the resources created using this module)"
  default     = "tf"
}

variable "region" {
  type        = "string"
  description = "location"
  default = "us-south"
}

variable "tags" {
  type        = "list"
  description = "Tags for service"
  default = ["terraform"]
}

variable "cluster_name" {
  type        = "string"
  description = "name of the cluster from where you want to ships logs. Giving cluster name will install the logDNA-AT agent in your cluster. Giving it as empty will not install logDNA-AT agent."
  default = ""
}

variable "sysdig" {
  type = "map"
  description = "Sysdig instance details"

  default = {
    name      = "sysdig"
    plan      = "graduated-tier"
    namespace = "ibm-observe-sysdig"
  }
}


