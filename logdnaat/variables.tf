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
  description = "name of the cluster where you want to store activity tracker logs. Giving cluster name will install the logdnaAT-agent in your cluster. Giving it as empty will not install logdnaAT-agent"
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






