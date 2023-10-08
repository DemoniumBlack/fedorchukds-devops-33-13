/*
locals {
  vm_web = {
    name = yandex_compute_instance.web[*].name
    id   = yandex_compute_instance.web[*].id
    fqdn = yandex_compute_instance.web[*].fqdn
  }

  vm_storage = {
    name = yandex_compute_instance.storage.name
    id   = yandex_compute_instance.storage.id
    fqdn = yandex_compute_instance.storage.fqdn
  }

  vm_for_each_main = {
    name = yandex_compute_instance.for_each["main"].name
    id   = yandex_compute_instance.for_each["main"].id
    fqdn = yandex_compute_instance.for_each["main"].fqdn
  }

  vm_for_each_replica = {
    name = yandex_compute_instance.for_each["replica"].name
    id   = yandex_compute_instance.for_each["replica"].id
    fqdn = yandex_compute_instance.for_each["replica"].fqdn
  }

  all_vms = [
    {
      name = local.vm_web.name[0]
      id   = local.vm_web.id[0]
      fqdn = local.vm_web.fqdn[0]
    },
    {
      name = local.vm_web.name[1]
      id   = local.vm_web.id[1]
      fqdn = local.vm_web.fqdn[1]
    },
    {
      name = local.vm_for_each_main.name
      id   = local.vm_for_each_main.id
      fqdn = local.vm_for_each_main.fqdn
    },
    {
      name = local.vm_for_each_replica.name
      id   = local.vm_for_each_replica.id
      fqdn = local.vm_for_each_replica.fqdn
    },
    {
      name = local.vm_storage.name
      id   = local.vm_storage.id
      fqdn = local.vm_storage.fqdn
    }
  ]
}

output "hosts" {
  value = [
    for vm in local.all_vms : {
      name = vm.name
      id   = vm.id
      fqdn = vm.fqdn
    }
  ]
}
*/

output "all_vms" {
  value = flatten([
    [for i in yandex_compute_instance.web : {
      name = i.name
      id   = i.id
      fqdn = i.fqdn
    }],
    [for i in [yandex_compute_instance.storage] : {
      name = i.name
      id   = i.id
      fqdn = i.fqdn
    }],
    [for i in yandex_compute_instance.for_each : {
      name = i.name
      id   = i.id
      fqdn = i.fqdn
    }]
  ])
}