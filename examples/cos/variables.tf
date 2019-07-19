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


variable "cos_name"{
    type = "string"
    description = "name of the cloud object storage instance"
}

variable "cos_plan" {
    description = "Current plan"
    type = "string"
    default = "standard"
}

variable "cos_location" {
    type = "string"
    description = "location of your storage instance"
    default = "global"
}

variable "cos_parameters" {
  type        = "map"
  description = "Arbitrary parameters to create instance"
  default     = {
    "HMAC" = true
  }
}

variable "cos_resource_key_parameters" {
  type        = "map"
  description = "Arbitrary parameters to create resource key"
  default     = {
    "HMAC" = true
    "active" = true
  }
}

variable "cos_service_credentials_role" {
  type = "string"
  description = "The role defines permitted actions when accessing the COS service"
  default = "Reader" # possible values: Reader, Writer, Manager, Content Reader
}