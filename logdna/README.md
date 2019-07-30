## IBM Cloud Resource Instance Terraform module

Terraform module which creates LogDNA log analysis service to add log management capabilities to your IBM Cloud cluster

Reference: [ibm_resource_instance](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.0/r/resource_instance.html)

Module creates a LogDNA service and provides optional installation of logdna agent on the provided IKS cluster

### Pre-requisites
This module makes use of local-exec provisoners to execute bash scripts locally. The scripts use the following tools:
- [IBM Cloud CLI plug-ins](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-getting-started)

## Source of Module using Github URL / Local Path

Terraform will recognize unprefixed github.com URLs and interpret them automatically as Git repository sources.

The below address scheme will clone over HTTPS.

```hcl
module "logdna" {
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//logdna"
}
```

To clone over SSH, use the following form:

```hcl
module "logdna" {
  source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//logdna"
}
```

Alternatively, You can clone this repository and create your own "main.tf" in the root folder, like main.tf in examples folder , and give the local path as "logdna" 

```hcl
module "logdna" {
  "source = "logdna"
}
```

## Usage

You can call the module with literal values

```hcl
module "logdna" {
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdna"
  pfx               = "tf"
  region            = "us-south"
  resource_group    = "default"
  tags              = ["terraform"]
  logdna_details    = {"name"="logdna", "plan"="lite"}
  cluster_name      = "name-of-cluster"
  install_agent     = true
}
```

## Examples

* [Example of main.tf is provided here](../examples/logdna/main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_name | Name of the cluster from which you want to ship logs. Provide the cluster name and give `install_agent` as true to install the agent in your cluster. | string | `""` | no |
| install_agent | Setting it to true will install the agent on the cluster (mentioned in `cluster_name`) or otherwise. | string | `false` | no
| logdna_details | LogDNA instance details | `<map>` | `{"name"="logdna", "plan"="lite"}` | no |
| pfx | Prefix appended to start of the logdna instance name | string | `"tf"` | no |
| resource_group | resource group name where you want to create the resource. If not provided it creates the resource in default resource group. | string |`"default"` | no |
| region |  Region for the instance to be created in  | string | `"us-south"` | yes |
| tags | List of associated tags for the created instance. | `<list>` | `["terraform"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| logDNA_instance_name | name of the logdna instance|
| logDNA_instance_id | id of the logdna instance|


#### Additional Info
To Add agents to log sources like (Linux Ubuntu/Debian |Linux RPM-based |Linux Gentoo | Kubernetes) manually, [follow the individual instructions to install the LogDNA agents](https://cloud.ibm.com/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-config_agent)

After you configure a log source, launch the LogDNA UI by selecting View LogDNA in IBM Cloud. It may take a few minutes before you start seeing logs.


## Authors

Module managed by [Hitesh Verma](mailto:hitesh.verma@ibm.com)
