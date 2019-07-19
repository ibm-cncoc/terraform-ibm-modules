# IBM Cloud Key Protect Instance Terraform module

Terraform module which creates a Key Protect (KP) instance on IBM Cloud. It also creates a root key in the KP instance.

Reference: [ibm_resource_instance](https://ibm-cloud.github.io/tf-ibm-docs/v0.16.1/r/resource_instance.html)

More info about the service, [Key Protect](https://cloud.ibm.com/docs/services/key-protect?topic=key-protect-getting-started-tutorial#getting-started-tutorial)

This module uses API calls to create a root key in KP instance. For more details, [API docs](https://cloud.ibm.com/apidocs/key-protect)

### Pre-requisites
This module makes use of local-exec provisoners to execute bash scripts locally. The scripts use the following tools:
- [curl](https://curl.haxx.se/)
- [jq](https://stedolan.github.io/jq/)

## Source of Module using Github URL / Local Path

Terraform will recognize unprefixed github.com URLs and interpret them automatically as Git repository sources.

The below address scheme will clone over HTTPS.

```hcl
module "keyprotect" {
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//keyprotect"
}
```

To clone over SSH, use the following form:

```hcl
module "keyprotect" {
  "source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//keyprotect"
}
```

Alternatively, You can clone this repository and create your own "main.tf" in the root folder, like main.tf in examples folder, and give the local path as "iks" 

```hcl
module "keyprotect" {
  "source = "keyprotect"
}
```

## Usage

You can call the module with literal values
```hcl
module "keyprotect" {
  source              = "git::github.com:ibm-client-success/terraform-ibm-modules.git//keyprotect"
  ibm_bx_api_key      = "******"
  resource_group_id   = "1234566"
  region              = "us-south"
  kp_name             = "keyprotect"
  tags                = ["test","module-example"]
  delete_keys         = true
}
```
or call the module with variable arguments.

```hcl
module "keyprotect" {
  source            = "git::github.com:ibm-client-success/terraform-ibm-modules.git//keyprotect"
  ibm_bx_api_key    = "${var.ibm_bx_api_key}"
  resource_group    = "${data.ibm_resource_group.rg.name}"
  region            = "${var.region}"
  pfx               = "${local.pfx}"
  tags              = ["${var.tags}"]
  kp_name           = "${var.kp_name}"
  kp_plan           = "${var.kp_plan}"
  kp_rootkey        = "${var.kp_rootkey}"
  delete_keys       = "${var.delete_keys}"
  
}
```

## Examples

* Basic example file for your reference, [delete-keys-example](../examples/keyprotect/example-delete-keys.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| delete_keys | Takes effect only during terraform destroy. Flag to choose if kp keys should be deleted or not. If set to true, during destroy, all root keys associated with the created KP instance will be deleted   | boolean | `false` | no |
| ibm\_bx\_api\_key | IBM Cloud API key used to generate token - Used in API call for root key creation | string | `N/A` | yes |
| kp\_name | Name of KP resource to be created. | string | `N/A` | yes |
| kp\_plan | KP plan type. | string | `"tiered-pricing"` | no |
| kp\_rootkey | Map of key description and payload. If payload is left empty, a root key will be created. To import your own key, provide the base64 encoded material of the key in the payload field | map(string) | `{"description" = "root key", "payload" = ""}` | no |
| pfx | Prefix appended to start of the KP resource name. | string | `tf` | no |
| region | Region for the KP instance to be created in. | string | `"us-south"` | no |
| resource_group | The name of the resource group. | string |`N/A`| yes |
| tags | List of associated tags for the created KP instance. | list(string) | `["terraform"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| keyprotect_id | ID of created KP instance. |
| keyprotect_name | Name of created KP instance. |

## Authors

Module managed by [Hitesh Verma](hitesh.verma@ibm.com), [Huy Ngo](mailto:hdngo@us.ibm.com) and [Poojitha Bikki](poojitha.bikki@ibm.com)