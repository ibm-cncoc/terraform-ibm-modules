output "sysdig_instance_name" {
  value = "${ibm_resource_instance.sysdig.name}"
  description = "Created Sysdig instance name"
}

output "sysdig_instance_id" {
  value = "${ibm_resource_instance.sysdig.id}"
  description = "Created Sysdig instance id"
}