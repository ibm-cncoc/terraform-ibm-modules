
variable ibm_bx_api_key {}
variable ibm_sl_username {}
variable ibm_sl_api_key {}

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
    type = "string"
    description = "provide a prefix to the name of the resource. If empty, it will use randomly generated prefix"
    default     = ""
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
