locals {
  vpn_connection_arn = [for my_arn in aws_vpn_connection.main: my_arn.arn]
}

resource "aws_vpn_connection" "main" {
  for_each = var.create_VPN_connection ? var.vpn_connections : {}
  customer_gateway_id = each.value["customer_gateway_id"]
  type                = var.type
  static_routes_only  = each.value["static_routes_only"]
  tunnel1_inside_cidr = each.value["tunnel1_inside_cidr"]
  tunnel2_inside_cidr = each.value["tunnel2_inside_cidr"]
  tags = var.tags
}


resource "aws_networkmanager_site_to_site_vpn_attachment" "test" {
  depends_on = [
    resource.aws_vpn_connection.main
  ]
  count = var.create_VPN_connection ? length(local.vpn_connection_arn) : 0
  vpn_connection_arn = local.vpn_connection_arn[count.index]
  core_network_id    = var.core_network_id
  tags = merge(var.tags, {
    env = var.segment_name
  })
}