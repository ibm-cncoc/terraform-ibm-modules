variable ibm_bx_api_key {}



variable "resource_group" {
    type = "string"
    description = "ibm cloud resoure group"
    default = "default"

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
