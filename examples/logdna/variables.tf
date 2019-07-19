variable ibm_bx_api_key {}


variable "region" {
  type        = "string"
  description = "region where to add the resource"
  default     = "us-south"
}

variable "resource_group" {
    type = "string"
    description = "ibm cloud resoure group"
    default = "phoenix"
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
}

variable "logdna_details" {
  type = "map"
  description = "LogDNA instance details"

  default = {
    name = "logdna"
    plan = "lite"   //This can also be "lite", "14-day" or "30-day"
  }
}
