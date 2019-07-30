data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}

resource "ibm_container_cluster" "cluster" {
  name              = "${var.pfx}-${var.cluster_name}"
  region            = "${var.region}"
  datacenter        = "${var.zones[0]}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"

  private_vlan_id = "${element(local.private_vlan_ids,0)}"
  public_vlan_id  = "${element(local.public_vlan_ids,0)}"

  hardware          = "${var.hardware}"
  machine_type      = "${var.machine_type}"
  default_pool_size = "${var.default_pool_size}"
  disk_encryption   = "${var.disk_encryption}"
  kube_version      = "${var.kube_version}"
  billing           = "${var.billing}"
  tags              = ["${var.tags}"]

  depends_on = [
    "ibm_network_vlan.private_vlan_new",
    "ibm_network_vlan.public_vlan_new",
    "null_resource.key_management"
  ]
}



data "ibm_container_cluster_config" "ibmcluster_config" {
  cluster_name_id   = "${ibm_container_cluster.cluster.name}" # Use cluster name. Using "id" may give errors while initializing the kube provider, because "id" is a computed value
  config_dir        = "${path.module}"
  download          = true
  resource_group_id = "${data.ibm_resource_group.rg.id}"
}

locals {
  cluster_config_path = "${data.ibm_container_cluster_config.ibmcluster_config.config_dir}/${sha1("${data.ibm_container_cluster_config.ibmcluster_config.cluster_name_id}")}_${data.ibm_container_cluster_config.ibmcluster_config.cluster_name_id}_k8sconfig/config.yml"
}

output "cluster-config-path" {
  value       = "${data.ibm_container_cluster_config.ibmcluster_config.config_file_path}"
  description = "Path of cluster config file"
}

output "cluster-name" {
  value       = "${data.ibm_container_cluster_config.ibmcluster_config.cluster_name_id}"
  description = "Name of IKS cluster created"
}




resource "null_resource" "check_cluster_status" {
  # sleep 30 to wait for any other operation (like kp enable) to take effect and change the Master Status
  # pip install python packages that script uses
  # Execute Script to check Master status of Cluster. 
  # If KP is enabled, the enabling process takes about 30 mins. So the script waits for the enabling to be done.
    # This script has a 1 hr timeout (specified inside the script) for the KP enabling to finish. It times out if the Cluster doesn't reach a `Ready state` within the hour. In this case, monitor your cluster and wait for it to be `Ready` before you use it.


  provisioner "local-exec" {
    command = <<EOT
    sleep 30
    pip3 install requests
    pip3 install datetime
    python3 ${path.module}/scripts/check_clusterstatus.py --apikey "${var.ibm_bx_api_key}" --rgid "${data.ibm_resource_group.rg.id}" --region "${var.region}" --cluster "${ibm_container_cluster.cluster.name}"
EOT
  }

  depends_on = [
    "null_resource.key_management",
    "ibm_container_cluster.cluster",
    "null_resource.keyprotect_enable"
  ]
}
















