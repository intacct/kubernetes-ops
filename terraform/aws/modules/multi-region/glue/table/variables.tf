variable "create_table" {
    type = bool
}
variable "table_names" {
    type = list(string)
}

variable "db_name" {
    type = string
}
variable "table_descriptions" {
    type    = list(string)
    default = [""]
}

variable "input_formats" {
  description = "Input format library to be used"
  type = list(string)
}

variable "output_formats" {
  type = list(string)
}

variable "serialization_libs" {
    description = "Serde serialization lib to be used to serialize data"
  type = list(string)
}
variable "serde_parameters" {
    description = "Map of serde parameters"
    type = list
    default = []
}
variable "table_types" {
    type    = list(string)
    default = ["EXTERNAL_TABLE"]
}
variable "table_parameters" {
    type = list
    default = [
        {
            EXTERNAL = "TRUE"
        }
    ]
}
variable "columns" {
    description = "Table columns"
    type = list
}
variable "partition_keys" {
    type = list
    default = []
}
variable "location_urls" {
    type = list(string)
}





