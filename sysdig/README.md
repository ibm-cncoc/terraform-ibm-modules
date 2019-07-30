# IBM Cloud Resource Instance Terraform module

Terraform module which creates Sysdig instance for monitoring your IBM Cloud architecture using IBM Cloud Monitoring Sysdig

Reference: [ibm_resource_instance](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.0/r/resource_instance.html)

Module has resources that
- Creates a Sysdig service on IBM Cloud
- Supports optional installation of sysdig agents on IKS Cluster. Agent installation script reference [install-agent-k8s.sh](https://raw.githubusercontent.com/draios/sysdig-cloud-scripts/master/agent_deploy/IBMCloud-Kubernetes-Service/install-agent-k8s.sh)

### Pre-requisites
This module makes use of local-exec provisoners to execute bash scripts locally. The scripts use the following tools:
- [curl](https://curl.haxx.se/)
- [IBM Cloud CLI plug-ins](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-getting-started)


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
  resource_group    = "default"
  tags              = ["terraform"]
  sysdig            = {name = "sysdig", plan ="lite", namespace = "ibm-observe-sysdig"}
  cluster_name      = "name-of-cluster"
  install_agent     = true
}

output "sysdig_instance_name" {
  value = "${module.sysdig.sysdig_instance_name}"
}

output "sysdig_instance_id" {
  value = "${module.sysdig.sysdig_instance_id}"
}
```


## Examples

* [example of main.tf is provided here](../examples/sysdig/main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_name | Name of the cluster from which you want to ship logs. Provide the cluster name and give `install_agent` as true to install the agent in your cluster. | string | `""` | no |
| pfx | Prefix appended to start of the sysdig instance name. | string | `"tf"` | no |
| region |  Region for the instance to be created in.  | string | `"us-south"` | no |
| resource_group | resource group name where you want to create the resource. If not provided it creates the resource in default resource group. | string | `"default"` | no |
| tags | List of associated tags for the created instance. | `<list>` | `["terraform"]` | no |
| sysdig | Sysdig instance details | map | `{name = "sysdig", plan = "lite", namespace = "ibm-observe-sysdig"}` | no |
| install_agent | Setting it to true will install the agent on the cluster (mentioned in `cluster_name`) or otherwise. | string | `false` | no

## Outputs

| Name | Description |
|------|-------------|
| sysdig_instance_name | Name of the sysdig instance |
|sysdig_instance_id | id of the sysdig instance |

## Authors

Module managed by [Hitesh Verma](mailto:hitesh.verma@ibm.com).
