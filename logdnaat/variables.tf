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
  description = "Setting it to true will install the agent on the cluster (mentioned in cluster_name) or otherwise."
  default = false
}






