variable "create_table" {
    type = bool
}

variable "table_name" {
    type = string
}

variable "db_name" {
    type = string
}

variable "table_description" {
    type    = string
    default = ""
}

variable "partition_keys" {
    type = map
    default = {}
}

variable "table_type" {
    type    = string
    default = "EXTERNAL_TABLE"
}

variable "parameters" {
    type = any
    default = [
        {
            EXTERNAL = "TRUE"
        }
    ]
}

variable "location_url" {
    type = string
}

variable "columns" {
    description = "Table columns"
    type = "map"
}



