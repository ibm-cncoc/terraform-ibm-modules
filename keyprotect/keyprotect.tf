
##############################################
# Creates KP instance
##############################################
resource "ibm_resource_instance" "key_protect" {
  name              = "${var.pfx}-${var.kp_name}"
  service           = "kms"
  plan              = "${var.kp_plan}"
  location          = "${var.region}"
  resource_group_id = "${data.ibm_resource_group.rg.id}"
  tags              = "${var.tags}"
}

data "ibm_resource_group" "rg" {
  name = "${var.resource_group}"
}

#####################################################################
# Executes a script that creates root key
# On destroy, executes a script that 
# > either deletes all the root keys in a KP instance or 
# > shows an error 
# > depending on whether the value of TF variable 'delete_keys' is true or false
######################################################################
resource "null_resource" "key_management" {
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/create-key.sh"

    environment {
      APIKEY          = "${var.ibm_bx_api_key}"
      KEYPROTECT      = "${ibm_resource_instance.key_protect.id}"
      KEY_NAME        = "${var.pfx}-${var.kp_name}-key"
      KEY_DESCRIPTION = "${var.kp_rootkey["description"]}"
      KEY_PAYLOAD     = "${var.kp_rootkey["payload"]}"
      REGION          = "${var.region}"
    }
  }
  provisioner "local-exec" {
    when    = "destroy"
    command = "bash ${path.module}/scripts/delete-keys.sh"

    environment {
      APIKEY     = "${var.ibm_bx_api_key}"
      KEYPROTECT = "${ibm_resource_instance.key_protect.id}"
      REGION     = "${var.region}"
      DELETE_KEYS     = "${var.delete_keys}"
    }
  }
  depends_on = [
    "ibm_resource_instance.key_protect",
  ]
}

