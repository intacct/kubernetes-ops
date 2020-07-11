################
# subnet
################
resource "aws_subnet" "this" {
  count = var.create_subnet && length(var.subnets) > 0 ? length(var.subnets) : 0

  vpc_id                          = var.vpc_id
  cidr_block                      = element(concat(var.subnets, [""]), count.index)
  availability_zone               = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id            = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "%s-${var.subnet_suffix}-%s",
        var.name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.subnet_tags,
  )
}


########################
# Network ACLs
########################
resource "aws_network_acl" "this" {
  count = var.create_network_acl && (length(var.subnets) > 0 || length(var.subnet_ids) > 0) ? 1 : 0

  vpc_id     = var.vpc_id
  subnet_ids = var.create_subnet ? aws_subnet.this.*.id : var.subnet_ids


  tags = merge(
    {
      "Name" = format("%s-${var.subnet_suffix}", var.name)
    },
    var.tags,
    var.acl_tags,
  )
}

resource "aws_network_acl_rule" "inbound" {
  count = var.create_network_acl ? length(var.inbound_acl_rules) : 0

  network_acl_id = aws_network_acl.this[0].id

  egress          = false
  rule_number     = var.inbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.inbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.inbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.inbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.inbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.inbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.inbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.inbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.inbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "outbound" {
  count = var.create_network_acl ? length(var.outbound_acl_rules) : 0

  network_acl_id = aws_network_acl.this[0].id

  egress          = true
  rule_number     = var.outbound_acl_rules[count.index]["rule_number"]
  rule_action     = var.outbound_acl_rules[count.index]["rule_action"]
  from_port       = lookup(var.outbound_acl_rules[count.index], "from_port", null)
  to_port         = lookup(var.outbound_acl_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.outbound_acl_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.outbound_acl_rules[count.index], "icmp_type", null)
  protocol        = var.outbound_acl_rules[count.index]["protocol"]
  cidr_block      = lookup(var.outbound_acl_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.outbound_acl_rules[count.index], "ipv6_cidr_block", null)
}

