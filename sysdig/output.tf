output "sysdig_instance_name" {
  value = "${ibm_resource_instance.sysdig.name}"
  description = "Created Sysdig instance"
}