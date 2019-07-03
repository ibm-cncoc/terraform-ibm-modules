# Resource for creating key protect instance
resource "ibm_resource_instance" "key_protect" {
  count             = "${var.create_keyprotect ? 1 : 0}"
  name              = "${var.pfx}-${var.kp_name}"
  service           = "kms"
  plan              = "${var.kp_plan}"
  location          = "${var.region}"
  resource_group_id = "${var.resource_group_id}"
  tags              = ["${var.tags}"]
}

##################### Key management  ####################

resource "null_resource" "key_management" {

  count             = "${var.create_keyprotect ? 1 : 0}"
  provisioner "local-exec" {
    command = "bash ./iks/scripts/keyprotect.sh"

    environment {
      APIKEY          = "${var.ibm_bx_api_key}"
      KEYPROTECT      = "${ibm_resource_instance.key_protect.0.id}"
      KEY_NAME        = "${var.pfx}-${var.kp_name}-key"
      KEY_DESCRIPTION = "${var.kp_rootkey["description"]}"
      KEY_PAYLOAD     = "${var.kp_rootkey["payload"]}"
      REGION          = "${var.region}"
    }
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "bash ./iks/scripts/keyprotect-destroy.sh"

    environment {
      APIKEY     = "${var.ibm_bx_api_key}"
      KEYPROTECT = "${ibm_resource_instance.key_protect.0.id}"
      REGION     = "${var.region}"
    }
  }
  depends_on = [
    "ibm_resource_instance.key_protect",
  ]
}

# Enables KP on the Cluster
resource null_resource "keyprotect_enable" {
  count             = "${var.create_keyprotect ? 1 : 0}"
  provisioner "local-exec" {
    command = "bash ./iks/scripts/enable-keyprotect.sh"

    environment {
      APIKEY          = "${var.ibm_bx_api_key}"
      KEYPROTECT      = "${ibm_resource_instance.key_protect.0.id}"
      CLUSTER         = "${ibm_container_cluster.cluster.name}"
      REGION          = "${var.region}"
    }
  }
    depends_on = [
    "null_resource.key_management",
    "ibm_container_cluster.cluster"

  ]
}