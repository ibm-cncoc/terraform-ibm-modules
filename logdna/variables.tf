variable "resource_group" {
    type = "string"
    description = "resource group name where you want to create the resource"
    default = "default"
}

variable "region" {
  type        = "string"
  description = "ibm cloud region for the instance to be created in"
  default     = "us-south"
}

variable "pfx" {
  type        = "string"
  description = "add prefix to the name of the resource created by this module (This helps you identify the resources created using this module)"
  default     = "tf"
}

variable "tags" {
  type        = "list"
  description = "Tags for resource"
  default = ["terraform"]
}


variable "cluster_name" {
  type        = "string"
  description = "name of the cluster from where you want to ships logs. Giving cluster name will install the logdna-agent in your cluster. Giving it as empty will not install logdna-agent"
}

variable "logdna_details" {
  type = "map"
  description = "LogDNA instance details"

  default = {
    name = "logdna"
    plan = "lite"   //This can also be "lite", "14-day" or "30-day"
  }
}
