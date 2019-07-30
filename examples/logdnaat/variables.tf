variable ibm_bx_api_key {}

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

variable "region" {
  type        = "string"
  description = "ibm cloud region for the instance to be created in"
  default     = "us-south"
}

variable "tags" {
  type        = "list"
  description = "Tags for service"
  default = ["terraform"]
}

variable "cf_org" {
  type    = "string"
  description = "ibm cloud cf org name"
}

variable "cf_space" {
  type = "string"
  description = "ibm cloud cf space name"
}

variable "cluster_name" {
  type        = "string"
  description = "Name of the cluster from where you want to ships logs. Provide the cluster name and give install_agent as true to install the agent in your cluster. Default is empty string"
  default = ""
}

variable "logdnaat_details" {
  type = "map"
  description = "LogDNA with Activity Tracker instance details"

  default = {
    name = "logdna-at"
    plan = "7-day"     //This can also be "lite", "14-day" or "30-day"
  }
}

variable "install_agent" {
  type = "string"
  description = "setting it to true will install the agent in the cluster (mentioned in cluster_name) or otherwise"
  default = false
}



