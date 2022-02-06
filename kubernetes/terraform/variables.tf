variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet"
}
variable service_account_key_file {
  description = "key .json"
}
variable private_key_path {
  description = "Path to the private key used for provision connection"
}

variable master_disk_image {
  description = "Disk image for master node K8S"
  default     = "K8S-master-base"
}
variable worker_disk_image {
  description = "Disk image for worker node K8S"
  default     = "K8S-worker-base"
}

variable master_tags {
  description = "K8S master VM tags"
}
variable master_name {
  description = "K8S master VM name"
}
variable master_cores {
  description = "K8S master cores sum"
}
variable master_memory {
  description = "K8S master memory sum"
}

variable worker_tags {
  description = "K8S worker VM tags"
}
variable worker_name {
  description = "K8S worker VM name"
}
variable worker_cores {
  description = "K8S worker cores sum"
}
variable worker_memory {
  description = "K8S worker memory sum"
}

#variable "instances" {
#  type = list(string)
#  default = [
#    "master",
#    "worker",
#  ]
#}

variable "instances" {
  type = map
  default = {
    "1" = "master"
    "2" = "worker"
#    "3" = "worker"
  }
}

variable "names" {
  type = map
  default = {
    "master" = "k8s-master"
    "worker" = "k8s-worker"
  }
}
variable "cores" {
  type = map
  default = {
    "master" = "4"
    "worker" = "4"
  }
}
variable "memory" {
  type = map
  default = {
    "master" = "4"
    "worker" = "4"
  }
}
variable "disk_image" {
  type = map
  default = {
    "master" = "fd80viupr3qjr5g6g9du"
    "worker" = "fd80viupr3qjr5g6g9du"
  }
}
variable "disk_size" {
  type = map
  default = {
    "master" = "40"
    "worker" = "40"
  }
}
variable "user" {
  type = string
  default = "ubuntu"
}
