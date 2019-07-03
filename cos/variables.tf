
variable "resource_group_id" {
    type = "string"
    description = " The ID of the resource group where you want to create the service. You can retrieve the value from data source ibm_resource_group. If not provided it creates the service in default resource group"

}

variable "pfx" {
  type        = "string"
  description = "name prefix for resources created by this plan (This helps you identify the resources created using this plan)"
  default     = "tf"
}

variable "cos_name" {
    type = "string"
    description = "name of the cloud object storage instance"
}

variable "cos_plan" {
    type = "string"
    description = "Current plan for COS"
    default = "standard"
}

variable "cos_location" {
    type = "string"
    description ="Location for COS"
    default = "global"
}

variable "cos_tags" {
  type = "list"
  description = "Tags for service"  
  default = ["tf-test"]
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
  }
}

variable "cos_service_credentials_role" {
  type = "string"
  description = "The role defines permitted actions when accessing the COS service"
  default = "Reader" # possible values: Reader, Writer, Manager, Content Reader
}

