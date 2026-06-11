resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  family = var.vms_resources["web"].image_family # Было  var.vm_web_image_family
}

resource "yandex_compute_instance" "platform" {
  name        = local.vm_web_name
  platform_id = var.vms_resources["web"].platform_id
  zone        = var.vms_resources["web"].zone
  
  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu.image_id
      size        = var.vms_resources["web"].hdd_size
      type        = var.vms_resources["web"].hdd_type
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = merge(var.metadata, {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  })
}

# Создаем вторую подсеть в зоне ru-central1-b
resource "yandex_vpc_subnet" "develop-b" {
  name           = "develop-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.2.0/24"] # Обязательно другой CIDR, не пересекающийся с первой подсетью!
}

# Создаем вторую ВМ (базу данных)
resource "yandex_compute_instance" "platform-db" {
  name        = local.vm_db_name
  platform_id = var.vms_resources["db"].platform_id
  zone        = var.vms_resources["db"].zone
  
  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu.image_id
      size        = var.vms_resources["db"].hdd_size
      type        = var.vms_resources["db"].hdd_type
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = true
  }

  metadata = merge(var.metadata, {
    ssh-keys = "ubuntu:${var.vms_ssh_root_key}"
  })
}