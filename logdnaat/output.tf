
output "logDNA-AT-instance" {
  value = "${ibm_resource_instance.logdnaat.name}"
  description = "Created logDNA-AT instance"
}