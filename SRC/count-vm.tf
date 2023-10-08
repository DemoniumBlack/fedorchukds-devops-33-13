data "yandex_compute_image" "ubuntu-2004-lts" {
  family = "ubuntu-2004-lts"
}
variable "yandex_compute_instance_web" {
  type        = map(map(number))
  default = {
    web_resources = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    }
  }
}
resource "yandex_compute_instance" "web" {
  name        = "web-${count.index+1}"
  platform_id = "standard-v1"

  count = 2

  resources {
    cores         = var.yandex_compute_instance_web.web_resources.cores
    memory        = var.yandex_compute_instance_web.web_resources.memory
    core_fraction = var.yandex_compute_instance_web.web_resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh-keys}"
    serial-port-enable = "1"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }
  scheduling_policy {
    preemptible = true
  }
}