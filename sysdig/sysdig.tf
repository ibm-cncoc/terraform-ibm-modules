data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}

resource "ibm_resource_instance" "sysdig" {
  name              = "${var.pfx}-${var.sysdig["name"]}"
  service           = "sysdig-monitor"
  plan              = "${var.sysdig["plan"]}"
  location          = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  tags              = ["${var.tags}"]
}

resource "ibm_resource_key" "sysdig_resourceKey" {
  name                 = "${ibm_resource_instance.sysdig.name}-key"
  role                 = "Administrator"
  resource_instance_id = "${ibm_resource_instance.sysdig.id}"

  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

locals {
  sysdig_access_key = "${replace(lookup(ibm_resource_key.sysdig_resourceKey.credentials, "Sysdig Access Key"), "/((.|\n)*)Sysdig Access Key = (.*)((.|\n)*)/", "$3")}"
  sysdig_ingestion_endpoint = "${replace(lookup(ibm_resource_key.sysdig_resourceKey.credentials, "Sysdig Endpoint"), "/((.|\n)*)Sysdig Endpoint = (.*)((.|\n)*)/", "$3")}"
}

data "ibm_container_cluster_config" "ibmcluster_config" {
  count             = "${var.install_agent ? 1 : 0}" 
  cluster_name_id   = "${var.cluster_name}" # Use cluster name. Using "id" may give errors while initializing the kube provider, because "id" is a computed value
  config_dir        = "${path.module}"
  download          = true
  resource_group_id = "${data.ibm_resource_group.rg.id}"
}

resource "null_resource" "sysdig_agent_install" {
  count             = "${var.install_agent ? 1 : 0}" 
  provisioner "local-exec" {
    command = "chmod +x ${path.module}/scripts/sysdig.sh && ${path.module}/scripts/sysdig.sh"

    environment {
      CONFIG    = "${data.ibm_container_cluster_config.ibmcluster_config.0.config_dir}/${sha1("${data.ibm_container_cluster_config.ibmcluster_config.0.cluster_name_id}")}_${data.ibm_container_cluster_config.ibmcluster_config.0.cluster_name_id}_k8sconfig/config.yml"
      ACCESS_KEY    = "${local.sysdig_access_key}"
      INGESTION_ENDPOINT    = "${local.sysdig_ingestion_endpoint}"
      NAMESPACE = "${var.sysdig["namespace"]}"
    }
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "chmod +x ${path.module}/scripts/sysdig-destroy.sh && ${path.module}/scripts/sysdig-destroy.sh"

    environment {
      CONFIG    = "${data.ibm_container_cluster_config.ibmcluster_config.0.config_dir}/${sha1("${data.ibm_container_cluster_config.ibmcluster_config.0.cluster_name_id}")}_${data.ibm_container_cluster_config.ibmcluster_config.0.cluster_name_id}_k8sconfig/config.yml"
      NAMESPACE = "${var.sysdig["namespace"]}"
    }
  }

  depends_on        =
  [
    "ibm_resource_key.sysdig_resourceKey"
  ]
}
