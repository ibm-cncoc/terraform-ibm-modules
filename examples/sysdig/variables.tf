variable ibm_bx_api_key {}


variable "region" {
  type        = "string"
  description = "region"
  default     = "us-south"
}

variable "resource_group" {
    type = "string"
    description = "ibm cloud resoure group"
    default     = "default"
}

variable "pfx" {
  type        = "string"
  description = "add prefix to the name of the resource created by this module (This helps you identify the resources created using this module)"
  default     = "tf"
}

variable "tags" {
  type        = "list"
  description = "Tags for service"
  default     = ["terraform"]
}


variable "cluster_name" {
  type        = "string"
  description = "Name of the cluster from where you want to ships logs. Provide the cluster name and give install_agent as true to install the agent in your cluster. Default is empty string"
  default = ""
}

variable "sysdig" {
  type = "map"
  description = "Sysdig instance details"

  default = {
    name      = "sysdig"
    plan      = "graduated-tier"
    namespace = "ibm-observe"
  }
}

variable "install_agent" {
  type = "string"
  description = "setting it to true will install the agent in the cluster (mentioned in cluster_name) or otherwise"
  default = false
}