###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "<your_ssh_ed25519_key>"
  description = "ssh-keygen -t ed25519"
}

### Переменная с ресурсами для всех ВМ (map of objects)
variable "vms_resources" {
  type = map(object({
    platform_id    = string
    cores          = number
    memory         = number
    core_fraction  = number
    hdd_size       = number
    hdd_type       = string
    zone           = string
    image_family   = string
  }))
  
  description = "Resources configuration for all VMs"
  
  default = {
    web = {
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 1
      core_fraction = 20
      hdd_size      = 10
      hdd_type      = "network-hdd"
      zone          = "ru-central1-a"
      image_family  = "ubuntu-2004-lts"
    }
    db = {
      platform_id   = "standard-v3"
      cores         = 2
      memory        = 2
      core_fraction = 20
      hdd_size      = 10
      hdd_type      = "network-ssd"
      zone          = "ru-central1-b"
      image_family  = "ubuntu-2004-lts"
    }
  }
}

### Общая переменная metadata для всех ВМ
variable "metadata" {
  type = map(string)
  
  description = "Common metadata for all VMs"
  
  default = {
    serial-port-enable = "1"
    # SSH-ключ будет добавлен динамически
  }
}

### Переменная для задания 8* (сложная структура)
variable "test" {
  type = list(map(list(string)))
  description = "Complex data structure for task 8*"
  default = []
}