variable "create_VPN_connection" {
  type = bool
  default = true
  description = "For creating VPN attachment to CloudWan"
}

variable "vpn_connections" {
  description = "Maps of vpn_connections attributes "
  type        = map(map(any))
  default     = {}
}

variable "type" {
  description = "The type of VPN connection. The only type AWS supports at this time is ipsec.1"
  default = "ipsec.1"
}

variable "core_network_id" {
  type =string
  description = "Core Network Id to be attached"
  
}

variable "segment_name" {
  type = string
  description = "To which segment the attachment need to be added"
  
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}