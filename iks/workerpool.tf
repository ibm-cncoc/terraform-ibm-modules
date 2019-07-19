resource "ibm_container_worker_pool" "pool" {
  count             = "${var.worker_pools_num}"
  region            = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  cluster           = "${ibm_container_cluster.cluster.name}"

  worker_pool_name  = "${var.pfx}-${element(var.worker_pool_params["tag"], count.index)}-${count.index}"
  machine_type      = "${element(var.worker_pool_params["machine_flavor"], count.index)}"
  hardware          = "${element(var.worker_pool_params["hardware"], count.index)}"
  size_per_zone     = "${element(var.worker_pool_params["workers"], count.index)}"
  disk_encryption   = "${element(var.worker_pool_params["disk_encryption"], count.index)}"
  depends_on        =
  [
    "ibm_container_cluster.cluster"
  ]
}


resource "ibm_container_worker_pool_zone_attachment" "zones_pool" {
  count             =  "${length(var.zones) * var.worker_pools_num}"
  region            = "${var.region}"
  zone              = "${element(var.zones, count.index)}" 
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  cluster           = "${ibm_container_cluster.cluster.name}"
  worker_pool       = "${element(split("/",element(ibm_container_worker_pool.pool.*.id, count.index / length(var.zones))),1)}"

  private_vlan_id   = "${element(local.private_vlan_ids,count.index)}"
  public_vlan_id    = "${element(local.public_vlan_ids,count.index)}"

  timeouts {
    create = "90m"
    update = "3h"
    delete = "30m"
  }
  depends_on        =
  [
    "ibm_network_vlan.private_vlan_new",
    "ibm_network_vlan.public_vlan_new",
    "ibm_container_cluster.cluster",
    "ibm_container_worker_pool.pool"
  ]
}

output "created-worker-pools" {
  value         =  ["${ibm_container_worker_pool.pool.*.worker_pool_name}"]
  description   =  "Created worker pools"
  
}

