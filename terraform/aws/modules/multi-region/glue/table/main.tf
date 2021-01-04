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
        # location      = "s3://ia-audittrailbucket/AuditData/"
        # input_format  = "org.apache.hadoop.mapred.TextInputFormat"
        # output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
        # input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
        # output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
        input_format  = element(var.input_formats, count.index)
        output_format = element(var.output_formats, count.index)
        number_of_buckets = var.number_of_buckets
        parameters = element(var.table_storage_parameters, count.index)


        ser_de_info {
            name                  = "trail-logs"
            # serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
            # serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
            # serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"
            serialization_library = element(var.serialization_libs, count.index)
            # parameters            = {
            #     "serialization.format" = 1
            #     # "field.delim"          = ","
            #     # "separatorChar"        = ","
            #     # "quoteChar"            = "\""
            #     # "escapeChar"           = "\\"
            # }
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


