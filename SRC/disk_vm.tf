resource "yandex_compute_disk" "disks" {
  name  = "disk-${count.index+1}"
  type  = "network-hdd"
  size  = 1
  count = 3
  block_size  = 4096
}

resource "yandex_compute_instance" "storage" {
  name = "storage"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type     = "network-hdd"
      size     = 5
    }
  }
      metadata = {
      ssh-keys           = "ubuntu:${local.ssh-keys}"
      serial-port-enable = "1"
    }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks.*.id
    content {
      disk_id = secondary_disk.value
  }
  }
}