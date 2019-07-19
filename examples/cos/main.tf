provider "ibm" {
  ibmcloud_api_key    = "${var.ibm_bx_api_key}"
}


module "cos" {
    # source = "../../cos"  # use if module is cloned locally
    source = "github.com/ibm-client-success/terraform-ibm-modules.git//cos"
    pfx                   = "tf"
    cos_name              = "test"
    cos_plan              = "standard"
    cos_location          = "global"
    cos_tags              = ["terraform"]
    resource_group        = "default"
    cos_parameters        = { "HMAC" = true }
    cos_resource_key_parameters = { "HMAC" = true }
    cos_service_credentials_role    = "Reader"
}

output "cos_instance_status" {
    value = "${module.cos.cos_instance_status}"
}

output "cos_instance_name" {
    value = "${module.cos.cos_instance_name}"
}

output "cos_instance_id" {
    value = "${module.cos.cos_instance_id}"
}


#call the module with variable arguments

# module "cos" {
##  source = "../../cos"
# source = "github.com/ibm-client-success/terraform-ibm-modules.git//cos"
  
#   pfx                   = "${var.pfx}"
#   cos_name              = "${var.cos_name}"
#   cos_plan              = "${var.cos_plan}"
#   cos_location          = "${var.cos_location}"
#   cos_tags              = ["${var.tags}"]
#   resource_group        = "${var.resource_group}"
#   cos_parameters        = "${var.cos_parameters}"
#   cos_resource_key_parameters = "${var.cos_resource_key_parameters}"
#   cos_service_credentials_role    = "${var.cos_service_credentials_role}"
# }

# output "cos_instance_status" {
#     value = "${module.cos.cos_instance_status}"
# }

# output "cos_instance_name" {
#     value = "${module.cos.cos_instance_name}"
# }

# output "cos_instance_id" {
#     value = "${module.cos.cos_instance_id}"
# }
