# IBM Cloud VPC / Infrastructure Services Resources Terraform module

Terraform module which creates a VPC and related Infrastructure Services Resources on IBM Cloud.

Reference: [Infrastructure Services Resources](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.0/r/is_vpc.html)

Modules has resources to create
- VPC (Virtual Private Cloud on Classic)
- Subnet in the Virtual Private Cloud
- Public gateway (PGW) on a subnet if you want resources on your subnet to have access to the internet or vice-versa. (optional)
- Additional Security Group and associated rules

## Source of Module using Github URL / Local Path

Terraform will recognize unprefixed github.com URLs and interpret them automatically as Git repository sources.

The below address scheme will clone over HTTPS.

```hcl
module "vpc" {
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//vpc"
}
```

To clone over SSH, use the following form:

```hcl
module "vpc" {
  "source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//vpc"
}
```

Alternatively, You can clone this repository and create your own "main.tf" in the root folder, like main.tf, and give the local path as "vpc" 

```hcl
module "vpc" {
  "source = "vpc"
}
```

## Usage

You can call the module with literal values

```hcl
module "vpc" {
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//vpc"
  vpc_name          = "vpc"
  subnet_name       = "subnet"
  secgroup_name     = "secgroup"
  pubgateway_name   = "pubgateway"
  pfx               = "tf"
  resource_group    = "default"
  ipv4_cidr_block   = "10.243.0.0/24"
  region            = "us-south"
  zone_index        = "1"
  tags              = "["terraform"]"
  remote            = "127.0.0.1"
  direction         = "ingress"
  udp_protocol      = {
      port_min = 805
      port_max = 807
    }
  icmp_protocol     = {
      code = 20
      type = 30
    }
  tcp_protocol      = {
      port_min = 8080 
      port_max = 8080
  }
  create_gateway    = true
  protocols         = ["tcp","udp","icmp"]
  ip_version        = "ipv4"
}
```

or call the module with variable arguments.
```hcl
module "vpc" {
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//vpc"
  vpc_name          = "${var.vpc_name}"
  subnet_name       = "${var.subnet_name}"
  secgroup_name     = "${var.secgroup_name}"
  pubgateway_name   = "${var.pubgateway_name}"
  pfx               = "${var.pfx}"
  resource_group    = "${var.resource_group}"
  ipv4_cidr_block   = "${var.ipv4_cidr_block}"
  region            = "${var.region}"
  zone_index        = "${var.zone_index}"
  tags              = "${var.tags}"
  remote            = "${var.remote}"
  direction         = "${var.direction}"
  udp_protocol      = "${var.udp_protocol}"
  icmp_protocol     = "${var.icmp_protocol}"
  tcp_protocol      = "${var.tcp_protocol}"
  create_gateway    = "${var.create_gateway}"
  protocols         = "${var.protocols}"
  ip_version        = "${var.ip_version}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}
output "vpc_default_security_group" {
    value = "${module.vpc.vpc_default_security_group}"
}

output "vpc_status" {
    value = "${module.vpc.vpc_status}"
}

output "subnet_status"{
    value = "${module.vpc.subnet_status}"
}

output "public_gateway_status"{
    value = "${module.vpc.public_gateway_status}"
}
```

## Examples

* [example of main.tf is provided here](../examples/vpc/main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create_gateway | If true then creates public gateway resource, attaches it to the subnet. | boolean | true | no |
| direction      | The direction of the traffic: give either ingress or egress. | string | `"ingress"` | no |
| icmp_protocol   | The ICMP traffic code to allow. Valid values for code are from 0 to 255 and type are from 0 to 254. | `<list>` | {code = 20 type = 30} | no |
| ipv4_cidr_block | The IPv4 range of the subnet. It varies for the region and zone_index Eg: Default value for Dallas 1 (us-south-1) is "10.240.0.0/24" | string |`N/A`| yes |
| ip_version | IP version either IPv4 or IPv6 | string | `"ipv4"` | no |
| pfx | Prefix appended to start of the vpc name. | string |`"tf"`| no |
| protocols | List of protocols for inbound rules to be added to the security group. Empty list creates a rule with protocol ALL. | `<list>` | [] | no |
| pubgateway_name | Name of the public gateway resource| string | `N/A` | yes |
| region |  Region for the vpc to be created in.  | string |`N/A`| yes |
| remote | Security group id - you can provide an IP address, a CIDR block, or a single security group identifier. | string | "127.0.0.1" | no |
| resource_group | resource group name where you want to create the resource. If not provided it creates the resource in default resource group. | string | `"default"` | no |
| subnet_name | Name of the subnet resource | string | `N/A` | yes |
| secgroup_name | Name of the security group resource | string | `N/A` | yes |
| tags | List of associated tags for the created cluster. | `<list>` | `["terraform"]` | no |
| tcp_protocol | The TCP traffic code to allow. Valid values for port_min and port_max are from 1 to 65535. | `<list>` | { port_min = 8080 port_max = 8080 } | no |
| udp_protocol | The UDP traffic code to allow. Valid values for port_min and port_max are from 1 to 65535. | `<list>` | { port_min = 8080 port_max = 8080  } | no |
| zone_index | Zone of the region provided. It takes either 1 or 2 or 3. |`string` | `1` | no |
| vpc_name | Name of the vpc resource | string | `N/A` | yes |



## Outputs

| Name | Description |
|------|-------------|
|vpc_id | The unique identifier of the VPC |
|vpc_default_security_group | The unique identifier of the VPC default security group |
|vpc_status | The status of VPC |
|subnet_status | The status of the subnet |
|public_gateway_status| The status of the gateway |
|public_gateway_floating_ip_info| Info of the floating IP created (List of maps) |


## Additional Info
IBM Cloud Provider for Virtual Private Cloud currently supports classic infrastructure. 

| Variable | Value | Description |
|-------|:---:|-------------|
| generation | 1 | classic infrastructure |
| generation | 2 | next generation infrastructure |

This module assumes you are providing generation=1 for vpc


## Authors

Module managed by [Hitesh Verma](hitesh.verma@ibm.com) and [Poojitha Bikki](poojitha.bikki@ibm.com).
