# IBM Cloud Resource Instance Terraform module

Terraform module which creates Sysdig instance for monitoring your IBM Cloud architecture using IBM Cloud Monitoring Sysdig

Reference: [ibm_resource_instance](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.0/r/resource_instance.html)

Module has resources that
- Creates a Sysdig service on IBM Cloud
- Supports optional installation of sysdig agents on IKS Cluster. Agent installation script reference [install-agent-k8s.sh](https://raw.githubusercontent.com/draios/sysdig-cloud-scripts/master/agent_deploy/IBMCloud-Kubernetes-Service/install-agent-k8s.sh)

## Source of Module using Github URL / Local Path

Terraform will recognize unprefixed github.com URLs and interpret them automatically as Git repository sources.

The below address scheme will clone over HTTPS.

```hcl
module "sysdig" {
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//sysdig"
}
```

To clone over SSH, use the following form:

```hcl
module "sysdig" {
  "source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//sysdig"
}
```

Alternatively, You can clone this repository and create your own "main.tf" in the root folder, like main.tf in examples folder , and give the local path as "sysdig" 

```hcl
module "sysdig" {
  "source = "sysdig"
}
```

## Usage

You can call the module with literal values:

```hcl
module "sysdig" {
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//sysdig"
  pfx               = "tf"
  region            = "us-south"
  resource_group        = "default"
  tags              = ["terraform"]
  sysdig            = {name = "sysdig", plan ="lite", namespace = "ibm-observe-sysdig"}
  cluster_name      = ""
}
```


or call the module with variable arguments:
```hcl
module "sysdig" {
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//sysdig"
  pfx               = "${var.pfx}"
  region            = "${var.region}"
  resource_group        = "${var.resource_group}"
  tags              = ["${var.tags}"]
  sysdig            = "${var.sysdig}"
  cluster_name      = "${var.cluster_name}"
}
```


## Examples

* [example of main.tf is provided here](../examples/sysdig/main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_name | name of the cluster from where you want to ships logs. Giving cluster name will install the logDNA-AT agent in your cluster. Giving it as empty ("") will not install logDNA-AT agent." | string | `""` | no |
| pfx | Prefix appended to start of the sysdig instance name. | string | `"tf"` | no |
| region |  Region for the instance to be created in.  | string | `"us-south"` | no |
| resource_group | resource group name where you want to create the resource. If not provided it creates the resource in default resource group. | string | `"default"` | no |
| tags | List of associated tags for the created instance. | `<list>` | `["terraform"]` | no |
| sysdig | Sysdig instance details | map | `{name = "sysdig", plan = "lite", namespace = "ibm-observe-sysdig"}` | no |


## Outputs

| Name | Description |
|------|-------------|
| sysdig_instance_name | Name of the sysdif instance |

## Authors

Module managed by [Hitesh Verma](mailto:hitesh.verma@ibm.com).
