### Переменные для первой ВМ (web)
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Name of the web VM"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform ID for the web VM"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores for the web VM"
}

variable "vm_web_memory" {
  type        = number
  default     = 1
  description = "Amount of RAM in GB for the web VM"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 20
  description = "CPU core fraction for the web VM"
}

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Image family for the web VM"
}

### Переменные для второй ВМ (db)
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
}

variable "vm_db_cores" {
  type        = number
  default     = 2
}

variable "vm_db_memory" {
  type        = number
  default     = 2
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
}

variable "vm_db_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
}