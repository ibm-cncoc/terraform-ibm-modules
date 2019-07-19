data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}

resource "ibm_resource_instance" "logdna" {
  name              = "${var.pfx}-${var.logdna_details["name"]}"
  service           = "logdna"
  plan              = "${var.logdna_details["plan"]}"
  location          = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  tags              = ["${var.tags}"]
}

resource "ibm_resource_key" "logdna_resourceKey" {
  name                 = "${ibm_resource_instance.logdna.name}-key"
  role                 = "Administrator"
  resource_instance_id = "${ibm_resource_instance.logdna.id}"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

data "ibm_container_cluster_config" "ibmcluster_config" {
  count             = "${var.cluster_name == "" ? 0 : 1}" 
  cluster_name_id   = "${var.cluster_name}" # Use cluster name. Using "id" may give errors while initializing the kube provider, because "id" is a computed value
  config_dir        =  "${path.module}"
  download          = true
  resource_group_id = "${data.ibm_resource_group.rg.id}"
}

locals {
    logdna_service_key = "${replace(lookup(ibm_resource_key.logdna_resourceKey.credentials, "ingestion_key"), "/((.|\n)*)ingestion_key = (.*)((.|\n)*)/", "$3")}"
}

resource "null_resource" "logdna_agent_install" {
  count             = "${var.cluster_name == "" ? 0 : 1}" 
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/logdna.sh"

    environment {
      CONFIG    = "${data.ibm_container_cluster_config.ibmcluster_config.0.config_dir}/${sha1("${data.ibm_container_cluster_config.ibmcluster_config.0.cluster_name_id}")}_${data.ibm_container_cluster_config.ibmcluster_config.0.cluster_name_id}_k8sconfig/config.yml"
      SERVICE_KEY    = "${local.logdna_service_key}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "bash ${path.module}/scripts/logdna-destroy.sh"

    environment {
      CONFIG    = "${data.ibm_container_cluster_config.ibmcluster_config.0.config_dir}/${sha1("${data.ibm_container_cluster_config.ibmcluster_config.0.cluster_name_id}")}_${data.ibm_container_cluster_config.ibmcluster_config.0.cluster_name_id}_k8sconfig/config.yml"
      SERVICE_KEY    = "${local.logdna_service_key}"
    }
  }

  depends_on        =
  [
    "ibm_resource_key.logdna_resourceKey"
  ]
}