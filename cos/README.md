## IBM Cloud Resource Instance Terraform module

Terraform module which creates a cloud object storage (COS) instance on IBM Cloud.

Reference: [ibm_resource_instance](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.0/r/resource_instance.html)
For more info on getting started with IBM COS, [Cloud Object Storage](https://cloud.ibm.com/docs/services/cloud-object-storage?topic=cloud-object-storage-getting-started)

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
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//cos"
}
```

Alternatively, you can clone this repository and create your own "main.tf" in the root folder and give `source=cos` , where source refers to local path of cos folder"

```hcl
module "cos" {
  source = "cos"
}
```
Refer to [sample_main.tf](../sample_main.tf), for a sample file

## Usage

You can call the module with literal values

```hcl
module "cos" {
    source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//cos"
  
    cos_name              = "test"
    cos_plan              = "lite"
    cos_location          = "global"
    cos_tags              = ["tf-test"]
    resource_group_id     = "12345"
}
output "cos_instance_status" {
    value = "${module.cos.cos_instance_status}"
}
output "cos_instance_id" {
    value = "${module.cos.cos_instance_id}"
}
```

or call the module with variable arguments.

```hcl
module "cos" {
    source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//cos"
  
    cos_name         = "${var.cos-name}"
    cos_plan          = "${var.cos-plan}"
    cos_location      = "${var.cos-location}"
    cos_tags          = ["${var.cos-tags}"]
    resource_group_id = "${data.ibm_resource_group.group.id}"
}
output "cos_instance_status" {
    value = "${module.cos.cos_instance_status}"
}
output "cos_instance_id" {
    value = "${module.cos.cos_instance_id}"
}
```

## Examples

* [sample main.tf is provided here](../sample_main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ibm_bx_api_key | IBM cloud API key used to provision resources | string | `""` | yes |
| cos_name | name of the cloud object storage instance | string | `cos` | yes |
| cos_location |  region for the instance to be created in  | string | `""` | yes |
| cos_plan |  current plan for COS  | string | `standard` | yes |
| resource_group_id | The ID of the resource group where you want to create the service. You can retrieve the value from data source ibm_resource_group. If not provided it creates the service in default resource group | string | `""` | no |
| cos_tags | List of associated tags for the created instance | `<list>` | `["tf-test"]` | no |


## Outputs

| Name | Description |
|------|-------------|
| cos_instance_id | ID of the resource instance created |
| cos_instance_status | Status of resource instance |


## Authors

Module managed by [Hitesh Verma](mailto:hitesh.verma@ibm.com)
