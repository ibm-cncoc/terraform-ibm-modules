data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}

resource "ibm_resource_instance" "logdnaat" {
  name              = "${var.pfx}-${var.logdnaat_details["name"]}"
  service           = "logdnaat"
  plan              = "${var.logdnaat_details["plan"]}"
  location          = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  tags              = ["${var.tags}"]
}

resource "null_resource" "logdnaat_agent_install" {
  count             = "${var.install_agent ? 1 : 0}" 
  provisioner "local-exec" {
  when = "create"
  command ="ibmcloud cs logging-config-create --cluster ${var.cluster_name} --logsource kube-audit --org '${var.cf_org}' --space ${var.cf_space}"
  }

  provisioner "local-exec" {
    when = "destroy"
    command = <<EOT
    logconfig_id=$(ibmcloud cs logging-config-get --cluster ${var.cluster_name} | grep kube-audit | awk '{print $1}');
    ibmcloud cs logging-config-rm --cluster ${var.cluster_name} --id $logconfig_id
    EOT
  }
}