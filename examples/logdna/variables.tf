variable ibm_bx_api_key {}


variable "region" {
  type        = "string"
  description = "region where to add the resource"
  default     = "us-south"
}

variable "resource_group" {
    type = "string"
    description = "ibm cloud resoure group"
    default = "default"
}

variable "pfx" {
  type        = "string"
  description = "name prefix for resources created by this plan"
  default     = "tf"
}

variable "tags" {
  type        = "list"
  description = "Tags for service"
  default     = ["terraform"]
}

variable "cluster_name" {
  type        = "string"
  description = "provide name of the cluster from where you want to ships logs. This will automatically install a logdna-agent in your cluster. If given null, it will just create logdna-at resource."
  default = ""
}

variable "install_agent" {
  type = "string"
  description = "setting it to true will install the agent in the cluster (mentioned in cluster_name) or otherwise"
  default = true
}
