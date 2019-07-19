variable ibm_bx_api_key {}

variable "resource_group" {
  type        = "string"
  description = "IBM Cloud Resource Group name to deploy Key Protect"
  default = "default"
  
  
}

variable "region" {
  type        = "string"
  description = "Region to deploy Key Protect (us-south, eu-de, etc.)"
  default     = "us-south"
}

variable "pfx" {
  type        = "string"
  description = " name prefix for resources created by this plan"
  default     = "tf"
}

######### KMS #########

variable "kp_name" {
  type        = "string"
  description = "Key Protect Service Name"
}

variable "kp_plan" {
  type        = "string"
  description = "Plan for Key Protect"
  default     = "tiered-pricing"
}

variable "delete_keys" {
  type = "string"
  default = false
  description = "Flag to choose if kp keys should be deleted or not "
}

variable "kp_rootkey" {
  type        = "map"
  description = "key protect key info"

  default = {
    "description" = "root key"
    # The key material that you want to store and manage in the service.
    # Leave payload blank to generate root key
    # If you are importing the key, provide a base64 encoded payload
    # AES key size should be 128, 192 or 256 bits
    "payload" = "" 
  }
}

variable "tags" {
  type        = "list"
  description = "Tags for service"
  default     = ["terraform"]
}
