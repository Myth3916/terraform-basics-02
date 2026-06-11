# Создаём NAT Gateway
resource "yandex_vpc_gateway" "nat" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# Создаём таблицу маршрутизации
resource "yandex_vpc_route_table" "nat_route" {
  name = "nat-route-table"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"  # Весь трафик
    gateway_id         = yandex_vpc_gateway.nat.id  # Через NAT
  }
}
