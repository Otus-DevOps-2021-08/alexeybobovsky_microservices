provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

locals {
  names = values(yandex_compute_instance.vm-app)[*].name
  ips   = values(yandex_compute_instance.vm-app)[*].network_interface.0.nat_ip_address
}

resource "local_file" "generate_inventory" {
  content = templatefile("hosts.tpl", {
    names = local.names,
    addrs = local.ips,
    user  = var.user
  })
  filename = "../ansible/hosts"

  provisioner "local-exec" {
    command = "chmod a-x ../ansible/hosts"
  }

  provisioner "local-exec" {
    when = destroy
    command = "mv ../ansible/hosts ../ansible/hosts.backup"
    on_failure = continue
  }
}

resource "yandex_compute_instance" "vm-app" {
  for_each = (var.instances)
  name = "${var.names[each.value]}-${each.key}"
  allow_stopping_for_update = true
  scheduling_policy {
    preemptible = true
  }

  resources {
    cores  = var.cores[each.value]
    memory = var.memory[each.value]
  }

  boot_disk {
    initialize_params {
      image_id = var.disk_image[each.value]
      size = var.disk_size[each.value]
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}

#resource "yandex_compute_instance" "vm-app" {
#  for_each = toset(var.instances)
#  name = var.names[each.key]
#
#  allow_stopping_for_update = true
#  scheduling_policy {
#    preemptible = true
#  }
#
#  resources {
#    cores  = var.cores[each.key]
#    memory = var.memory[each.key]
#  }
#
#  boot_disk {
#    initialize_params {
#      image_id = var.disk_image[each.key]
#      size = var.disk_size[each.key]
#    }
#  }
#
#  network_interface {
#    subnet_id = var.subnet_id
#    nat       = true
#  }
#
#  metadata = {
#    ssh-keys = "ubuntu:${file(var.public_key_path)}"
#  }
#
#}


resource "null_resource" "deploy" {

  provisioner "local-exec" {
    command = <<-EOT
      sleep 60 &&
      cd ../ansible &&
      ansible-playbook play.yml
#      ansible-playbook join.yml
    EOT
  }

  triggers = {
    addrs = join(",", local.ips),
  }

  depends_on = [local_file.generate_inventory]
}
