## IBM Cloud Resource Instance Terraform module

Terraform module which creates a cloud object storage (COS) instance on IBM Cloud.
- Creates a COS instance
- Creates service credentials for the COS instance created

Reference: [ibm_resource_instance](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.0/r/resource_instance.html)

## Source of Module using Github URL / Local Path

Terraform will recognize unprefixed github.com URLs and interpret them automatically as Git repository sources.

The below address scheme will clone over HTTPS.

```hcl
module "cos" {
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//cos"
}
```

To clone over SSH, use the following form:

```hcl
module "cos" {
  "source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//cos"
}
```

Alternatively, You can clone this repository and create your own "main.tf" in the root folder, like main.tf in examples folder, and give the local path as "cos" 

```hcl
module "cos" {
  "source = "cos"
}
```

## Usage

You can call the module with literal values

```hcl
module "cos" {
    source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//cos"
    pfx                   = "tf"
    cos_name              = "test"
    cos_plan              = "lite"
    cos_location          = "global"
    cos_tags              = ["terraform"]
    resource_group        = "default"
    cos_parameters        = { "HMAC" = true }
    cos_resource_key_parameters = { "HMAC" = true }
    cos_service_credentials_role    = "Reader"
}

output "cos_instance_status" {
    value = "${module.cos.cos_instance_status}"
}

output "cos_instance_name" {
    value = "${module.cos.cos_instance_name}"
}

output "cos_instance_id" {
    value = "${module.cos.cos_instance_id}"
}
```

or call the module with variable arguments.

```hcl
module "cos" {
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//cos"
  
  pfx                   = "${var.pfx}"
  cos_name              = "${var.cos_name}"
  cos_plan              = "${var.cos_plan}"
  cos_location          = "${var.cos_location}"
  cos_tags              = ["${var.tags}"]
  resource_group        = "${var.resource_group}"
  cos_parameters        = "${var.cos_parameters}"
  cos_resource_key_parameters = "${var.cos_resource_key_parameters}"
  cos_service_credentials_role    = "${var.cos_service_credentials_role}"
}

output "cos_instance_status" {
    value = "${module.cos.cos_instance_status}"
}

output "cos_instance_name" {
    value = "${module.cos.cos_instance_name}"
}

output "cos_instance_id" {
    value = "${module.cos.cos_instance_id}"
}
```

## Examples

* [example of main.tf is provided here](../examples/cos/main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cos_name | name of the cloud object storage instance. | string | `N/A` | yes |
| cos_location |  region for the instance to be created in.  | string | `global` | no |
| cos_plan |  current plan for COS.  | string | `standard` | no |
| cos_tags | List of associated tags for the created instance. | `<list>` | `["terraform"]` | no |
| cos_parameters | Arbitrary parameters to create instance. Creates a set of HMAC credentials by default. If set to `{}`, it'll create normal sevice credentials |  `<map>` | `{ "HMAC" = true }` | no |
| cos_resource_key_parameters | Arbitrary parameters to create resource key. | `<map>` | `{ "HMAC" = true }` | no |
| cos_service_credentials_role | The role defines permitted actions when accessing the COS service. | string | `"Reader"` | no |
| pfx | Prefix appended to start of the cos name. | string | `"tf"` | no |
| resource_group | resource group name where you want to create the resource. If not provided it creates the resource in default resource group. | string | `"default"` | no |



## Outputs

| Name | Description |
|------|-------------|
| cos_instance_id | ID of the resource instance created |
| cos_instance_status | Status of resource instance |
| cos_instance_name | name of the cos instance |

## Authors

Module managed by [Hitesh Verma](mailto:hitesh.verma@ibm.com)
