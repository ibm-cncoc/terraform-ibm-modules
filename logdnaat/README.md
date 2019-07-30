## IBM Cloud Resource Instance Terraform module

Terraform module which creates an IBM Cloud LogDNA Activity Tracker instance to monitor the user-initiated activities in IBM Cloud Account and administrative activity events made in the cluster using audit logs.

Reference: [ibm_resource_instance](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.0/r/resource_instance.html)

### Pre-requisites
This module makes use of local-exec provisoners to execute bash scripts locally. The scripts use the following tools:
- [IBM Cloud CLI plug-ins](https://cloud.ibm.com/docs/cli/reference/ibmcloud?topic=cloud-cli-getting-started)

## Source of Module using Github URL / Local Path

Terraform will recognize unprefixed github.com URLs and interpret them automatically as Git repository sources.

The below address scheme will clone over HTTPS.

```hcl
module "logdnaat" {
  source = "github.com/ibm-client-success/terraform-ibm-modules.git//logdnaat"
}
```

To clone over SSH, use the following form:

```hcl
module "logdnaat" {
  "source = "git::github.com:ibm-client-success/terraform-ibm-modules.git//logdnaat"
}
```

Alternatively, You can clone this repository and create your own "main.tf" in the root folder, like main.tf in examples folder , and give the local path as "logdnaat" 

```hcl
module "logdnaat" {
  "source = "logdnaat"
}
```

## Usage

You can call the module with literal values:

```hcl
module "logdnaat" {
  source            = "github.com/ibm-client-success/terraform-ibm-modules.git//logdnaat"
  pfx               = "tf-test"
  region            = "us-south"
  resource_group    = "default"
  tags              = ["terraform"]
  logdnaat_details  = {"name":"at-logdna","plan":"lite"}
  cf_org            = "org-name"
  cf_space          = "team-name"
  cluster_name      = "name-of-your-cluster"
  install_agent     = true
}

output "logDNA_AT_instance_name" {
  value = "${module.logdnaat.logDNA_AT_instance_name}"
}

output "logDNA_AT_instance_id" {
  value = "${module.logdnaat.logDNA_AT_instance_id}"
}
```

## Examples

* [Example of main.tf is provided here](../examples/logdnaat/main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_name | Name of the cluster from which you want to ship logs. Provide the cluster name and give `install_agent` as true to install the agent in your cluster. | string | `""` | no |
| cf_org |ibm cloud cloud foundry org name | string | `N/A` | yes |
| cf_space |ibm cloud cloud foundry space | string | `N/A` | yes |
| install_agent | Setting it to true will install the agent on the cluster (mentioned in `cluster_name`) or otherwise. | string | `false` | no
| logdnaat_details | LogDNA with Activity Tracker instance details | `<map>` | `{"name" = "at-logdna", "plan" = "lite" }` | no |
| pfx | Prefix appended to start of the logdna-at instance name | string | `"tf"` | no |
| region |  Region for the instance to be created in  | string | `"us-south"` | no |
| resource_group | resource group name where you want to create the resource. If not provided it creates the resource in default resource group. | string | `"default"` | no |
| tags | List of associated tags for the created instance. | `<list>` | `["terraform"]` | no |



## Outputs

| Name | Description |
|------|-------------|
| logDNA_AT_instance_name | name of the logdna-at instance|
| logDNA_AT_instance_id | id of the logdna-at instance


#### Additional Info
To Add agents to log sources like (Linux | Docker | Kubernetes) manually, [follow the individual instructions to install the LogDNA-AT agents](https://cloud.ibm.com/docs/services/Log-Analysis-with-LogDNA?topic=LogDNA-config_agent)

To monitor user-initiated administrative activity made in your cluster, you can collect and forward audit logs to IBM Cloud Activity Tracker.
Cluster management events are automatically generated and forwarded to Activity Tracker.

Kubernetes API server audit events are automatically generated, but you must create a logging configuration so that Fluentd can forward these logs to Activity Tracker.
(https://cloud.ibm.com/docs/containers?topic=containers-health#enable-forwarding)

After you configure a log source, launch the LogDNA-AT UI by selecting View LogDNA-AT in IBM Cloud. It may take a few minutes before you start seeing logs.

## Authors

Module managed by [Hitesh Verma](mailto:hitesh.verma@ibm.com)