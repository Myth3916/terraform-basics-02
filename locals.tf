locals {
  # Генерируем имена, которые СЕЙЧАС в облаке, используя интерполяцию
  vm_web_name = "${var.vpc_name}-${var.default_zone}-web"
  vm_db_name  = "${var.vpc_name}-b-db"
}