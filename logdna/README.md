## IBM Cloud Resource Instance Terraform module

Terraform module which creates LogDNA log analysis service to add log management capabilities to your IBM Cloud cluster

Reference: [ibm_resource_instance](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.0/r/resource_instance.html)

Module creates a LogDNA service and provides optional installation of logdna agent on the provided IKS cluster

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
  cluster_name      = "name-of-your-cluster"
}
```

or call the module with variable arguments.

```hcl
module "logdna" {
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdna"
  pfx               = "${var.pfx}"
  region            = "${var.region}"
  resource_group    = "${var.resource_group}"
  tags              = ["${var.tags}"]
  logdna_details    = "${var.logdna_details}"
  cluster_name      = "${var.cluster_name}"
}
```

## Examples

* [Example of main.tf is provided here](../examples/logdna/main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_name | name of the cluster from where you want to ships logs. Giving cluster name will install the logdna-agent in your cluster. Giving it as empty ("") will not install logdna-agent." | string | `""` | no |
| logdna_details | LogDNA instance details | `<map>` | `{"name"="logdna", "plan"="lite"}` | no |
| pfx | Prefix appended to start of the logdna instance name | string | `"tf"` | no |
| resource_group | resource group name where you want to create the resource. If not provided it creates the resource in default resource group. | string |`"default"` | no |
| region |  Region for the instance to be created in  | string | `"us-south"` | yes |
| tags | List of associated tags for the created instance. | `<list>` | `["terraform"]` | no |

## Outputs

| Name | Description |
|------|-------------|
| logDNA-instance | name of the logdna instance|


#### Additional Info
To Add agents to log sources like (Linux Ubuntu/Debian |Linux RPM-based |Linux Gentoo | Kubernetes) manually, [follow the individual instructions to install the LogDNA agents](https://cloud.ibm.com/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-config_agent)

After you configure a log source, launch the LogDNA UI by selecting View LogDNA in IBM Cloud. It may take a few minutes before you start seeing logs.


## Authors

Module managed by [Hitesh Verma](mailto:hitesh.verma@ibm.com)
