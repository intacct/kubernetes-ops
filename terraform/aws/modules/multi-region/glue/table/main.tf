resource "aws_glue_catalog_table" "this" {
    count          = var.create_table ? length(var.table_names) : 0

    name           = element(var.table_names, count.index)
    database_name  = var.db_name
    description    = element(var.table_descriptions, count.index)
    table_type     = element(var.table_types, count.index)
    parameters     = length(var.table_parameters) > 0 ? element(var.table_parameters, count.index) : {}

    storage_descriptor {
        # location      = var.location_url
        location      = element(var.location_urls, count.index)
        # STORED AS PARQUET
        input_format  = element(var.input_formats, count.index)
        output_format = element(var.output_formats, count.index)
        number_of_buckets = var.number_of_buckets
        parameters = element(var.table_storage_parameters, count.index)


        ser_de_info {
            name                  = "trail-logs"
            serialization_library = element(var.serialization_libs, count.index)
            parameters = element(var.serde_parameters, count.index)
        }

        dynamic "columns" {
            for_each = [for s in element(var.columns, count.index): {
                name = s[0]
                type = s[1]
            }]

            content {
                name = columns.value.name
                type = columns.value.type
            }
        }
    }

    dynamic "partition_keys" {
        for_each = [for p in element(var.partition_keys, count.index): {
            name = p[0]
            type = p[1]
        }]
        
        content {
            name = partition_keys.value.name
            type = partition_keys.value.type
        }
    }
}



