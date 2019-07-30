output "logDNA_instance_name" {
  value = "${ibm_resource_instance.logdna.name}"
  description = "logDNA instance name"
}


output "logDNA_instance_id" {
  value = "${ibm_resource_instance.logdna.id}"
  description = "logDNA instance id"
}