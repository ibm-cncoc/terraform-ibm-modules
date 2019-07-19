
variable "resource_group" {
    type = "string"
    description = "resource group name where you want to create the resource"
    default = "default"
}

variable "region" {
  type        = "string"
  description = "region"
  default     = "us-south"
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

variable "vpc_name" {
  type ="string"
  description = "name of the vpc"
}

variable "subnet_name" {
  type ="string"
  description = "name of the subnet"
}

variable "secgroup_name" {
  type ="string"
  description = "name of the security group"
}

variable "pubgateway_name" {
  type ="string"
  description = "name of the public gateway"
}

variable "zone_index" {
  type        = "string"
  description = "The subnet zone index (it can be 1,2, or 3). Default is 1"
  default     = "1"
}

variable "ipv4_cidr_block" {
  type = "string"
  description = "The IPv4 range of the subnet. Varies for different zone. Default one is for frankfurt zone"
}

variable "remote" {
  type = "string"
  description = "Security group id - an IP address, a CIDR block, or a single security group identifier"
  default = "127.0.0.1"
}

variable "direction" {
  type = "string"
  description = "The direction of the traffic: either ingress or egress"
  default = "ingress"
}

variable "udp_protocol" {
  type = "map"
  description = "A nested block describing the udp protocol of this security group rule. Valid values are from 1 to 65535"
  default =  {
        port_min = 805 #The inclusive lower bound of UDP port range. Valid values are from 1 to 65535
        port_max = 807 #The inclusive upper bound of UDP port range. Valid values are from 1 to 65535
    }
}

variable "tcp_protocol" {
  type = "map"
  description = "A nested block describing the tcp protocol of this security group rule.\n Valid values are from 1 to 65535"
  default = {
        port_min = 8080 #The inclusive lower bound of TCP port range. Valid values are from 1 to 65535.
        port_max = 8080 #The inclusive upper bound of TCP port range. Valid values are from 1 to 65535.
  }
}

variable "icmp_protocol" {
  type = "map"
  description = "A nested block describing the icmp protocol of this security group rule.\n The ICMP traffic code to allow. Valid values for code are from 0 to 255 and type are from 0 to 254"
  default =   {
        code = 20 #The ICMP traffic code to allow. Valid values from 0 to 255
        type = 30 #The ICMP traffic type to allow. Valid values from 0 to 254
    }
}

variable "create_gateway" {
  description = "if true then creates public gateway resource and attach it to the subnet"
  default = true
}

variable "protocols" {
    type = "list"
    description = "list of protocols for inbound rules to be added to the security group. Empty list creates a rule with protocol ALL"
    default = []
}

variable "ip_version" {
  type = "string"
  description = "IP version either IPv4 or IPv6"
  default = "ipv4"
}
