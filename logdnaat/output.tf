
output "logDNA_AT_instance_name" {
  value = "${ibm_resource_instance.logdnaat.name}"
  description = "Created logDNA-AT instance name"
}

output "logDNA_AT_instance_id" {
  value = "${ibm_resource_instance.logdnaat.id}"
  description = "Created logDNA-AT instance id"
}