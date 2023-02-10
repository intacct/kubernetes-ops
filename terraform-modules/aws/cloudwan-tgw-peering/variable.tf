variable "global_network_id" {
    type = string
    description = "Global Network ID"
  
}

variable "core_network_id" {
    type = string
    description = "Core Network ID"
  
}

variable "transit_gateway_arn" {
  type = list(string)
  default = [ ]
  description = "List of transit gateway arns"
}

variable "route_table_arn" {
  type = list(string)
  default = [ ]
  description = "list of TGW route tables arn's to attach"
  
}

variable "segment_name" {
  type = string
  description = "Segment that TGW-RT attached"
  
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}