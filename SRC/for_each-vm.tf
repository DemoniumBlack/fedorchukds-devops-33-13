data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

variable "vm_resources" {
  type = list(object({
    vm_name = string
    cpu     = number
    ram     = number
    disk    = number
  }))
  default = [
    {
      vm_name = "main"
      cpu     = 2
      ram     = 2
      disk    = 5
    },
    {
      vm_name = "replica"
      cpu     = 2
      ram     = 2
      disk    = 10
    },
  ]
}

locals {
  ssh-keys = file("~/.ssh/id_ed25519.pub")
}

resource "yandex_compute_instance" "for_each" {
  depends_on = [yandex_compute_instance.web]
  for_each = { for i in var.vm_resources : i.vm_name => i }
  name          = each.value.vm_name

  platform_id = "standard-v1"
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram

  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = each.value.disk
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