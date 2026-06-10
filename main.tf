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
  family = var.vm_web_image_family # Было "ubuntu-2004-lts"
}
resource "yandex_compute_instance" "platform" {
  name        = var.vm_web_name        # Было "netology-develop-platform-web"
  platform_id = var.vm_web_platform_id # Было "standard-v3"
  resources {
    cores         = var.vm_web_cores         # Было 2
    memory        = var.vm_web_memory        # Было 1
    core_fraction = var.vm_web_core_fraction # Было 20
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

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
  name        = var.vm_db_name
  platform_id = var.vm_db_platform_id
  zone        = "ru-central1-b" # Явно указываем зону
  
  resources {
    cores         = var.vm_db_cores
    memory        = var.vm_db_memory
    core_fraction = var.vm_db_core_fraction
  }
  
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  
  scheduling_policy {
    preemptible = true
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-b.id # Подключаем к новой подсети
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}