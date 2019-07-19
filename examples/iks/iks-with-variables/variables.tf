variable ibm_bx_api_key {}
variable ibm_sl_username {}
variable ibm_sl_api_key {}

variable "region" {
  type        = "string"
  description = "region"
  default     = "us-south"
}

variable "resource_group" {
    type = "string"
    description = "ibm cloud resoure group"
    default     = "default"
}

variable "pfx" {
  type        = "string"
  description = "add prefix to the name of the resource created by this module (This helps you identify the resources created using this module)"
  default     = "tf"
}

variable "tags" {
  type        = "list"
  description = "Tags for service"
  default     = ["terraform"]
}

variable "cluster_name" {
  type        = "string"
  description = "name of the cluster"
}

variable "billing" {
  type        = "string"
  description = "billing type"
  default     = "hourly"
}

############### IKS ###############

variable "zones" {
  type        = "list"
  description = "provide a list of zones in provided region (Workers on your IKS cluster will be distributed across the zones you provide here)."
  default     = ["dal10"]
}


variable "kube_version" {
  type        = "string"
  description = "The Kubernetes version for the cluster master node. When the version is not specified, the cluster is created with the default of supported Kubernetes versions. To see available versions, run ibmcloud ks versions."
  default     = ""
}

variable "hardware" {
  type        = "string"
  description = "The level of hardware isolation for your worker node: Dedicated or shared"
  default     = "shared"
}

variable "machine_type" {
  type        = "string"
  description = "The machine type of the worker nodes."
  default     = "u2c.2x4"
}

variable "default_pool_size" {
  description = "Number of nodes in your default worker pool"
  default     = 1
}

variable "disk_encryption" {
  description = "Set to false to disable encryption on a worker."
  default     = true
}


############# VLANs ###############
variable "create_private_vlan" {
  default = true
  description = "Do want to create new VLANs. If yes, enter 'true'; otherwise, enter 'false'"
}

variable "create_public_vlan" {
  default = true
  description = "Do want to create new VLANs. If yes, enter 'true'; otherwise, enter 'false'"
}

variable "public_vlan" {
  type = "map"
  description = "If you chose not to create VLANs, provide a list of public vlans on the zones your workers are distributed on (the list of vlans you provide here should have a one to one mapping with the zones list). Eg: If you provide the vlan map to be {ids = [\"1111\",\"2222\"] router_hostnames = [\"fcr01a\"]} and your zones are [dal12,dal10] vlan 1111 should belong to dal12 and 2222 should belong to dal10"

  default {
    ids              = ["-1"]
    router_hostnames = [""]
  }
}

variable "private_vlan" {
  type = "map"
  description = "If you chose not to create VLANs, provide a list of private vlans on the zones your workers are distributed on (the list of vlans you provide here should have a one to one mapping with the zones list). Eg: If you provide the vlan map to be {ids = [\"1111\",\"2222\"] router_hostnames = [\"fcr01a\"]} and your zones are [dal12,dal10] vlan 1111 should belong to dal12 and 2222 should belong to dal10"

  default {
    ids              = ["-1"]
    router_hostnames = [""]
  }
}

############## Worker Pools ############
variable "worker_pools_num" {
  type    = "string"
  description = "Enter the number of additional worker pools you want to create. (Enter 0 if you only need the default pool created)"
  default = "0"
}

variable "worker_pool_params" {
  type = "map"
  description = "This is a map for the worker specs. Each key in the map has list of values. The list of length should typically be the number of additional worker pools created. Element 'i' in each list corresponds to worker pool 'i'. Eg: if the provided 'worker_pools_num' is 2, and the key 'workers' has value as a list of [\"2\",\"1\"], that would indicate that number of workers in worker pool1 = 2, and number of workers in worker pool2 = 1 "

  default = {
    tag             = ["small"]   // Name of worker pool will be {pfx}-{tag}-{index}
    machine_flavor  = ["u2c.2x4"] //List of flavors for worker pool you want to create
    hardware        = ["shared"]
    workers         = ["1"]       //List of Num of Workers per zone for each pool.
    disk_encryption = ["false"]   // Indicate 'True' or 'False' for each zone - "False" is disk enryption is not required. "True" if required
  }
}

############### KMS ###############
variable "create_keyprotect" {
  default = true
  description = "Flag to either create keyprotect or not (true/false). If set to true, it will create a kps instance with a root key that encrypts the data on your cluster"
}


variable "kp_name" {
  type        = "string"
  description = "Key Protect Service Name"
  default     = "keyprotect"
}

variable "kp_plan" {
  type        = "string"
  description = "Plan for Key Protect"
  default     = "tiered-pricing"
}

variable "kp_rootkey" {
  type        = "map"
  description = "key protect instance info"

  default = {
    "description" = "root key"

    # Leave payload blank to generate root key
    # set payload to BYO-key file with AES 128/192/256 bits
    "payload" = ""
  }
}

variable "delete_keys" {
  type = "string"
  default = false
  description = "Flag to choose if kp keys should be deleted or not "
}


