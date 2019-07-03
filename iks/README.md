# IBM Cloud IKS Instance Terraform module

Terraform module which creates an IKS Cluster on IBM Cloud along with an optional Key Protect (KP) instance for encrypting the cluster.

Reference: [ibm_container_cluster](https://ibm-cloud.github.io/tf-ibm-docs/v0.16.1/r/container_cluster.html)
For more info on getting started with IKS, [IBM Cloud Kubernetes Service](https://cloud.ibm.com/docs/containers?topic=containers-getting-started)

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
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//iks"
}
```

Alternatively, you can clone this repository and create your own "main.tf" in the root folder and give `source=iks` , where source refers to local path of iks folder"

```hcl
module "iks" {
  source = "iks"
}
```
Refer to [sample_main.tf](../sample_main.tf), for a sample file

## Usage

You can call the module with literal values:

### Example of Single-Zone cluster:

```hcl
module "iks" {
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//iks"

  account_guid      = "123456789"
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
  ibm_bx_api_key    = "abc123"
  
}
```

### Example of Multi-Zone cluster

```hcl
module "iks" {
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//iks"

  account_guid      = "123456789"
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
  ibm_bx_api_key    = "abc123"

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

#### Important Info
Note that when a Key Protect Instance is created through this module, on `terraform destroy`, all the keys inside the KP instance are deleted before the instance is destroyed. Look into the script [keyprotect-destroy.sh](/scripts/keyprotect-destroy.sh) to see how it's done. 

### Limitations
- Module always creates the default worker pool on the first zone that you pass in your `zones = ["dal10","dal12"]` array [cluster.tf](cluster.tf#L6) . 

- Workers from all workerpools are distributed across the same set of zones. 



Call the module with variable arguments:

```hcl
module "iks" {
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//iks"

  account_guid      = "${data.ibm_account.account.id}"
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
  ibm_bx_api_key    = "${var.ibm_bx_api_key}"
  
}
```

## Examples

* [sample main.tf is provided here](../sample_main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account_guid | The GUID for the IBM Cloud account associated with the cluster. | string | `""` | yes |
| billing | The billing type for the instance. Accepted values are hourly or monthly. | string | `"hourly"` | no |
| cluster_name | The name of the cluster. | string | `dev` | no |
| create_private_vlan | Create new private vlans if set true or use existing ones if set false. | boolean | true | no |
| create_public_vlan | Create new public vlans if set true or use existing ones if set false. | boolean | true | no |
| default_pool_size | The number of workers created under the default worker pool. | int | `1` | yes |
| disk_encryption | Boolean value to determine if disk encryption is enabled for the worker nodes. | bool | `true` | no |
| hardware | The level of hardware isolation for your worker node. Accepted values are dedicated or shared. | string | `shared` | no |
| ibm_bx_api_key | IBM Cloud API key used to provision resources. | string | `""` | yes |
| kp_name | Name of KP resource to be created. | string | `"keyprotect"` | no |
| kp_plan | KP plan type. | string | `"tiered-pricing"` | no |
| kp_rootkey | User defined KP root key to be created. If not defined, then a random root key will be generated. | `<map>` | `{"description" = "root key", "payload" = ""}` | no |
| kube_version | The desired Kubernetes version of the created cluster. | string | `1.13.6` | yes |
| machine_type | The machine type of the worker nodes. | string | `"u2c.2x4"` | yes |
| pfx | Prefix appended to start of the IKS cluster name. | string | `""` | no |
| public_vlan | If you chose not to create VLANs, provide a list of public vlans on the zones your workers are distributed on (the list of vlans you provide here should have a one to one mapping with the zones list. | `<map>` | `""` | no |
| private_vlan | If you chose not to create VLANs, provide a list of private vlans on the zones your workers are distributed on (the list of vlans you provide here should have a one to one mapping with the zones list. | `<map>` | `""` | no |
| region |  Region for the cluster to be created in.  | string | `""` | yes |
| resource_group_id | The ID of the resource group. | string | `""` | yes |
| tags | List of associated tags for the created cluster. | `<list>` | `["terraform"]` | no |
| worker_pools_num | Enter the number of additional worker pools you want to create. (Enter 0 if you only need the default pool created) | int | `0` | no |
| worker_pool_params | This is a map for the worker specs. | `<map>` | `{ tag=["small"], machine_flavor=["u2c.2x4"], hardware=["shared"], workers=["1"], disk_encryption=["false"]}` | no |
| zones | List of zones attached to the worker pools. | `<list>` | `["dal10"]` | yes |



## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ID of created cluster. |
| cluster_name | Name of created cluster. |
| keyprotect_id | ID of created KP instance. |
| keyprotect_name | Name of created KP instance. |

## Authors

Module managed by [Huy Ngo](mailto:hdngo@us.ibm.com), [Hitesh Verma](mailto:hitesh.verma@ibm.com) and [Poojitha Bikki](mailto:poojitha.bikki@ibm.com) .
