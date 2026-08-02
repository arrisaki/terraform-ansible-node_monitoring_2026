terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
provider "yandex" {
  folder_id = "b1gn4sgl8vappgda3lap"
  zone      = "ru-central1-d"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = "ru-central1-d"
  size     = "20"
  image_id = data.yandex_compute_image.ubuntu.id
}

resource "yandex_compute_instance" "vm-1" {
  name        = "terraform1"
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

resource "null_resource" "run_ansible" {
  depends_on = [yandex_compute_instance.vm-1]

  triggers = {
    vm_ip         = yandex_compute_instance.vm-1.network_interface[0].nat_ip_address
    playbook_hash = filebase64sha256("/home/anna/ANSIBLE/playbook.yml")
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
    host        = yandex_compute_instance.vm-1.network_interface[0].nat_ip_address
    timeout     = "5m"
  }

  provisioner "local-exec" {
    working_dir = "/home/anna/ANSIBLE"
    command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ~/.ssh/id_ed25519 -i '${yandex_compute_instance.vm-1.network_interface[0].nat_ip_address},' playbook.yml -vv"
  }
}