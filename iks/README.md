# IBM Cloud IKS Instance Terraform module

Terraform module which creates an IKS Cluster on IBM Cloud along with an optional Key Protect (KP) instance for encrypting the cluster.

Module has the following Terraform resources
- IKS cluster with default pool
- VLANS (optional)
- KeyProtect and associated root key (optional)
- Additional Worker Pools and zone attachments for the workers (optional)

Reference: [ibm_container_cluster](https://ibm-cloud.github.io/tf-ibm-docs/v0.16.1/r/container_cluster.html)
For more info on getting started with IKS, [IBM Cloud Kubernetes Service](https://cloud.ibm.com/docs/containers?topic=containers-getting-started)

### Pre-requisites
This module makes use of local-exec provisoners to execute bash scripts locally. The scripts use the following tools:
- [curl](https://curl.haxx.se/)
- [jq](https://stedolan.github.io/jq/)
- [python](https://www.python.org/downloads/)

## Source of Module using Github URL / Local Path

Terraform will recognize unprefixed github.com URLs and interpret them automatically as Git repository sources.

The below address scheme will clone over HTTPS.

```hcl
module "iks" {
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//iks"
}
```

To clone over SSH, use the following form:

```hcl
module "iks" {
  "source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//iks"
}
```

Alternatively, You can clone this repository and create your own "main.tf" in the root folder, like main.tf in examples folder, and give the local path as "iks" 

```hcl
module "iks" {
  "source = "iks"
}
```


## Usage

You can call the module with literal values:

### Example of Single-Zone cluster:

```hcl
module "iks" {
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//iks"

  resource_group_id = "987654321"
  billing           = "hourly"
  cluster_name      = "my-cluster"
  default_pool_size = 1
  disk_encryption   = true
  hardware          = "shared"
  kube_version      = "1.13.7"
  machine_type      = "u2c.2x4"
  pfx               = "test"
  region            = "us-south"
  tags              = ["terraform"]
  zones             = ["dal10"]
  
  create_private_vlan = true
  create_public_vlan  = true
  public_vlan         = {}
  private_vlan        = {}

  worker_pools_num    = 0
  worker_pool_params  = {
  tag             = ["small"]
  machine_flavor  = ["u2c.2x4"]
  hardware        = ["shared"]
  workers         = ["1"]
  disk_encryption = ["false"]
  }
  create_keyprotect = true
  kp_name           = "keyprotect"
  kp_plan           = "tiered-pricing"
  kp_rootkey        = {description="", payload = ""} # payload = "<base64 encoded key>" to provide your own key
  delete_keys       = true
  ibm_bx_api_key    = "abc123"
  
}

output "cluster_id" {
  value       = "${module.iks.cluster_id}"
}

output "cluster_name" {
  value       = "${module.iks.cluster_name}"
}

output "keyprotect_id" {
  value       = "${module.iks.keyprotect_id}"
}

output "keyprotect_name" {
  value       = "${module.iks.keyprotect_name}"
}
```

### Example of Multi-Zone cluster

```hcl
module "iks" {
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//iks"

  resource_group_id = "987654321"
  billing           = "hourly"
  cluster_name      = "my-cluster"
  default_pool_size = 1
  disk_encryption   = true
  hardware          = "shared"
  kube_version      = "1.13.7"
  machine_type      = "u2c.2x4"
  pfx               = "module-test"
  region            = "us-south"
  tags              = ["terraform"]
  zones             = ["dal10","dal12"]
  
  create_private_vlan = false
  create_public_vlan  = false
  public_vlan{
        ids = ["0010","0012"]
        router_hostnames = ["xyz"]
    } 
  private_vlan{
        ids = ["0010","0012"]
        router_hostnames = ["abc"]
    }

  worker_pools_num    = 2
  worker_pool_params  = {
    tag             = ["small","medium]
    machine_flavor  = ["u2c.2x4","b2c.4x16"]
    hardware        = ["shared","shared"]
    workers         = ["2","1"]
    disk_encryption = ["false","false"]
  }
  create_keyprotect = true
  kp_name           = "keyprotect"
  kp_plan           = "tiered-pricing"
  kp_rootkey        = {description="", payload = ""} # payload = "<base64 encoded key>" to provide your own key
  delete_keys       = true
  ibm_bx_api_key    = "abc123"

}

output "cluster_id" {
  value       = "${module.iks.cluster_id}"
}

output "cluster_name" {
  value       = "${module.iks.cluster_name}"
}

output "keyprotect_id" {
  value       = "${module.iks.keyprotect_id}"
}

output "keyprotect_name" {
  value       = "${module.iks.keyprotect_name}"
}
```

Above module will provision IKS cluster with workers distributed across two zones and uses the respective private and public VLANs as provided in the variable lists. Make sure that the the VLAN ids you provide are valid, if you are using existing VLANs by setting the `create_private_vlan` and `create_public_vlan` to `False`. The VLANs should also have a one-to-one correspondence with the the list of zones you provide

An IKS cluster created using the example above will have the following:

- A default worker pool with one worker node (`default_pool_size = 1`) in `dal10` (first element in passed `zones = ["dal10","dal12"]` is used by default)
- Two additional worker pools (`worker_pools_num    = 2`)
- Specifications of each worker pool as provided in the map `worker_pool_params`. 
- First worker pool with `2` workers on each of the zones from `zones = ["dal10","dal12"]`
- Second worker pool with `1` worker on each zone from `zones = ["dal10","dal12"]`
- Uses VLANs as provided in the `public_vlan` and `private_vlan` maps


#### Additional Info
-  If you chose not to create VLANs, provide a list of public vlans on the zones you want your workers to be distributed on (the list of vlans you provide here should have a one to one mapping with the zones list). Eg: If your provided vlan map has `ids = ["0010","0012"]` and your zones are `["dal10","dal12"]` vlan `0010` should belong to `dal10` and `0012` should belong to `dal12`

- `worker_pool_params` is a map for the worker specs. Each key in the map has list of values. The length of list should typically be the number of additional worker pools created. Element 'i' in each list corresponds to worker pool 'i'. 
Eg: if the provided `worker_pools_num = 2`, and the key 'workers' has value as a list of `["2","1"]`, that would indicate that number of workers in `worker pool1 = 2`, and number of workers in `worker pool2 = 1`

- This module makes use of python scripts. Python packages that script uses are installed using `pip` in the script. 

#### Important Info
Note that when a Key Protect Instance is created through this module, on `terraform destroy`, all the keys inside the KP instance are deleted before the instance is destroyed. Look into the script [keyprotect-destroy.sh](/scripts/keyprotect-destroy.sh) to see how it's done. 

### Limitations
- Module always creates the default worker pool on the first zone that you pass in your `zones = ["dal10","dal12"]` array [cluster.tf](cluster.tf#L6) . 

- Workers from all workerpools are distributed across the same set of zones. 



Call the module with variable arguments:

```hcl
module "iks" {
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//iks"

  resource_group_id = "${data.ibm_resource_group.rg.id}"
  billing           = "${var.billing}"
  cluster_name      = "${var.cluster_name}"
  default_pool_size = "${var.default_pool_size}"
  disk_encryption   = "${var.disk_encryption}"
  hardware          = "${var.hardware}"
  kube_version      = "${var.kube_version}"
  machine_type      = "${var.machine_type}"
  pfx               = "${var.pfx}"
  region            = "${var.region}"
  tags              = ["${var.tags}"]
  zones             = "${var.zones}"
  
  create_private_vlan = "${var.create_private_vlan}"
  create_public_vlan  = "${var.create_public_vlan}"
  public_vlan         = "${var.public_vlan}"
  private_vlan        = "${var.private_vlan}"

  worker_pools_num    = "${var.worker_pools_num}"
  worker_pool_params  = "${var.worker_pool_params}"

  create_keyprotect = "${var.create_keyprotect}"
  kp_name           = "${var.kp_name}"
  kp_plan           = "${var.kp_plan}"
  kp_rootkey        = "${var.kp_rootkey}"
  delete_keys       = "${var.delete_keys}"
  ibm_bx_api_key    = "${var.ibm_bx_api_key}"

}

output "cluster_id" {
  value       = "${module.iks.cluster_id}"
}

output "cluster_name" {
  value       = "${module.iks.cluster_name}"
}

output "keyprotect_id" {
  value       = "${module.iks.keyprotect_id}"
}

output "keyprotect_name" {
  value       = "${module.iks.keyprotect_name}"
}
```

## Examples

* [Single-Zone cluster](../examples/iks/basic-iks/main.tf)
* [Multi-Zone cluster](../examples/iks/multi-zone-iks/main.tf)
* [General main.tf with variables](../examples/iks/iks-with-variables/main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| billing | The billing type for the instance. Accepted values are hourly or monthly. | string | `"hourly"` | no |
| cluster_name | The name of the cluster. | string | `N/A` | yes |
| create_private_vlan | Create new private vlans if set true or use existing ones if set false. | boolean | true | no |
| create_public_vlan | Create new public vlans if set true or use existing ones if set false. | boolean | true | no |
| default_pool_size | The number of workers created under the default worker pool. | int | `1` | no |
| delete_keys | Takes effect only during terraform destroy. Flag to choose if kp keys should be deleted or not. If set to true, during destroy, all root keys associated with the created KP instance will be deleted   | boolean | `false` | no |
| disk_encryption | Boolean value to determine if disk encryption is enabled for the worker nodes. | bool | `true` | no |
| hardware | The level of hardware isolation for your worker node. Accepted values are dedicated or shared. | string | `shared` | no |
| ibm_bx_api_key | IBM Cloud API key used to provision resources. | string | `N/A` | yes |
| kp_name | Name of KP resource to be created. | string | `"keyprotect"` | no |
| kp_plan | KP plan type. | string | `"tiered-pricing"` | no |
| kp_rootkey | User defined KP root key to be created. If not defined, then a random root key will be generated. | `<map>` | `{"description" = "root key", "payload" = ""}` | no |
| kube_version | The Kubernetes version for the cluster. This value is optional. When the version is not specified, the cluster is created with the default of supported Kubernetes version. To see available and default versions, run ibmcloud ks versions. | string | `N/A` | no |
| machine_type | The machine type of the worker nodes. | string | `"u2c.2x4"` | no |
| pfx | Prefix appended to start of the IKS cluster name. | string | `"tf"` | no |
| public_vlan | If you chose not to create VLANs, provide a list of public vlans on the zones your workers are distributed on (the list of vlans you provide here should have a one to one mapping with the zones list. | `<map>` | `{ids = ["-1"] router_hostnames = [""]}` | no |
| private_vlan | If you chose not to create VLANs, provide a list of private vlans on the zones your workers are distributed on (the list of vlans you provide here should have a one to one mapping with the zones list. | `<map>` | `{ids = ["-1"] router_hostnames = [""]}` | no |
| region |  Region for the cluster to be created in.  | string | `"us-south"` | no |
| resource_group | resource group name where you want to create the resource. If not provided it creates the resource in default resource group. | string | `"default"` | no |
| tags | List of associated tags for the created cluster. | `<list>` | `["terraform"]` | no |
| worker_pools_num | Enter the number of additional worker pools you want to create. (Enter 0 if you only need the default pool created) | int | `0` | no |
| worker_pool_params | This is a map for the worker specs. | `<map>` | `{ tag=["small"], machine_flavor=["u2c.2x4"], hardware=["shared"], workers=["1"], disk_encryption=["false"]}` | no |
| zones | List of zones attached to the worker pools. | `<list>` | `["dal10"]` | no |



## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ID of created cluster. |
| cluster_name | Name of created cluster. |
| keyprotect_id | ID of created KP instance. |
| keyprotect_name | Name of created KP instance. |

## Authors

Module managed by [Huy Ngo](mailto:hdngo@us.ibm.com), [Hitesh Verma](mailto:hitesh.verma@ibm.com) and [Poojitha Bikki](mailto:poojitha.bikki@ibm.com) .
