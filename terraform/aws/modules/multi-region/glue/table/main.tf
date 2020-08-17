resource "aws_glue_catalog_table" "this" {
    count          = var.create_table ? 1 : 0

    name           = var.table_name
    database_name  = var.db_name
    description    = var.table_description
    table_type     = var.table_type
    parameters     = {        
        EXTERNAL = "TRUE"    
        "parquet.compression" = "SNAPPY"
    }

    storage_descriptor {
        # location      = var.location_url
        location      = var.location_url
        # STORED AS PARQUET
        # location      = "s3://ia-audittrailbucket/AuditData/"
        # input_format  = "org.apache.hadoop.mapred.TextInputFormat"
        # output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
        input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
        output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

        ser_de_info {
            name                  = "trail-logs"
            serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
            # serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
            # serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
            parameters            = {
                # "serialization.format" = 1
                # "field.delim"          = ","
                "separatorChar"        = ","
                "quoteChar"            = "\""
                "escapeChar"           = "\\"
            }
        }

        dynamic "columns" {
            for_each = [for s in var.columns: {
                name = s[0]
                type = s[1]
            }]

            content {
                name = columns.value.name
                type = columns.value.type
            }
        }
        # dynamic "columns" {
        #     for_each = var.columns
        #     content {
        #         name = "${columns.key}"
        #         type = "${columns.value}"
        #     }
        # }
        # dynamic "columns" {
        #     for_each = var.columns
        #     content {
        #         name = "${columns[0]}"
        #         type = "${columns[1]}"
        #     }
        # }
    }

    dynamic "partition_keys" {
        for_each = [for p in var.partition_keys: {
            name = p[0]
            type = p[1]
        }]
        
        content {
            name = partition_keys.value.name
            type = partition_keys.value.type
        }
    }
}

# resource "null_resource" this {}

# locals {
#   auditdata_cols = [
#     {"name" = "recordid", "type" = "string"},
#     {"name" = "objecttype", "type" = "string"},
#     {"name" = "objectkey", "type" = "string"},
#     {"name" = "objectdesc", "type" = "string"},
#     {"name" = "userid", "type" = "string"},
#     {"name" = "accesstime", "type" = "timestamp"},
#     {"name" = "accessmode", "type" = "string"},
#     {"name" = "ipaddress", "type" = "string"},
#     {"name" = "source", "type" = "string"},
#     {"name" = "workflowaction", "type" = "string"}
#   ]

#   audittrailfields_cols = "${list(
#     map("name", "recordid", "type", "string"),
#     map("name", "fieldname", "type", "string"),
#     map("name", "fieldtype", "type", "string"),
#     map("name", "oldval", "type", "string"),
#     map("name", "newval", "type", "string"),
#     map("name", "oldstrval", "type", "string"),
#     map("name", "newstrval", "type", "string"),
#     map("name", "oldintval", "type", "string"),
#     map("name", "newintval", "type", "string"),
#     map("name", "oldnumval", "type", "string"),
#     map("name", "newnumval", "type", "string"),
#     map("name", "olddateval", "type", "string"),
#     map("name", "newdateval", "type", "string"),
#   )}"
# }

# data "yaml_map_of_strings" "table_test" {
#   input = <<EOF
# columns:
#   - name: recordid
#     type: string
#   - name: objecttype
#     type: string
#   - name: objectkey
#     type: string
#   - name: objectdesc
#     type: string
#   - name: userid 
#     type: string
#   - name: accesstime 
#     type: timestamp
#   - name: accessmode
#     type: string
#   - name: ipaddress
#     type: string
#   - name: source
#     type: string
#   - name: workflowaction
#     type: string
# EOF
# }

# data "yaml_list_of_strings" "columns" {
#   input = "${data.yaml_map_of_strings.table_test.output["columns"]}"
# }

# data "yaml_map_of_strings" "columns" {
#   count = "${length(data.yaml_list_of_strings.columns.output)}"
#   input = "${element(data.yaml_list_of_strings.columns.output, count.index)}"
# }


