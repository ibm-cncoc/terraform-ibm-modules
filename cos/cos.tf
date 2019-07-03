
# # Cloud Object Storage
resource "ibm_resource_instance" "cos" {
  name              =  "${var.pfx}-${var.cos_name}"
  service           = "cloud-object-storage"
  plan              = "${var.cos_plan}"
  location          = "${var.cos_location}"
  tags              = ["${var.cos_tags}"]
  resource_group_id = "${var.resource_group_id}"
  parameters = "${var.cos_parameters}"
  //User can increase timeouts 
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

# Create resource key for COS
resource "ibm_resource_key" "cos_resource_key" {
  name                 = "${ibm_resource_instance.cos.name}-key"
  role                 = "${var.cos_service_credentials_role}"
  resource_instance_id = "${ibm_resource_instance.cos.id}"
  parameters = "${var.cos_resource_key_parameters}"
  //User can increase timeouts 
  timeouts {
    create = "15m"
    delete = "15m"
  }
}





