resource "aws_glue_catalog_table" "this" {
    count          = "${var.create_table ? 1 : 0}"

    name           = var.table_name
    database_name  = var.db_name
    description    = var.table_description
    table_type     = var.table_type
    parameters     = {        
        EXTERNAL = "TRUE"    
    }

    storage_descriptor {
        location      = var.location_url
        # location      = "s3://ia-audittrailbucket/AuditData/"
        input_format  = "org.apache.hadoop.mapred.TextInputFormat"
        output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

        ser_de_info {
            name                  = "trail-logs"
            serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
            parameters            = {
                "serialization.format" = 1
            }
        }

        dynamic "columns" {
            for_each = var.columns
            content {
                name = "${columns.key}"
                type = "${columns.value}"
            }
        }
    }

    dynamic "partition_keys" {
        for_each = var.partition_keys
        content {
            name = "${partition_keys.key}"
            type = "${partition_keys.value}"
        }
    }
}

