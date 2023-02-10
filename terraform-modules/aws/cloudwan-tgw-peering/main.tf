
resource "aws_networkmanager_transit_gateway_registration" "tgw-register" {
  count = length(var.transit_gateway_arn)
  global_network_id   = var.global_network_id
  transit_gateway_arn = element(var.transit_gateway_arn, count.index)
}

resource "aws_networkmanager_transit_gateway_peering" "tgw-peering" {
  count = length(var.transit_gateway_arn) 
  core_network_id     = var.core_network_id
  transit_gateway_arn = element(var.transit_gateway_arn, count.index)
  #policy route table need to be added here
  depends_on = [aws_networkmanager_transit_gateway_registration.tgw-register]
  tags = var.tags
}

resource "aws_networkmanager_transit_gateway_route_table_attachment" "TGW-RT-attach" {
  count = length(var.route_table_arn)
  peering_id                      = "${resource.aws_networkmanager_transit_gateway_peering.tgw-peering[count.index].id}"
  transit_gateway_route_table_arn = element(var.route_table_arn, count.index)
  tags = merge(var.tags,{
     env = var.segment_name
  })
  depends_on = [
    aws_networkmanager_transit_gateway_peering.tgw-peering
  ]
}