resource "aws_glue_catalog_table" this {
    count          = "${var.create_table ? 1 : 0}"

    name           = var.table_name
    database_name  = var.db_name
    description    = var.table_description
    table_type     = var.table_type
    view_original_text = "/* Prest View: ${base64encode(file("../../modules/multi-region/glue/view/files/audittrailview.txt"))} */"
    view_expanded_text = "/* Prest View: */"
    parameters     = {        
        presto_view = "true"
        comment     = "Presto View"    
    }

    storage_descriptor {
        ser_de_info {
            name                  = " "
            serialization_library = " "
        }

        dynamic "columns" {
            for_each = var.columns
            content {
                name = "${columns.key}"
                type = "${columns.value}"
            }
        }
    }
}
