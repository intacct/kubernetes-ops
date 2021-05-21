resource "aws_glue_catalog_table" this {
    count          = var.create_table ? 1 : 0

    name           = var.table_name
    database_name  = var.db_name
    description    = var.table_description
    table_type     = var.table_type
    view_original_text = "/* Presto View: ${base64encode(file("../../modules/multi-region/glue/view/files/audittrailview.txt"))} */"
    view_expanded_text = "/* Presto View */"
    # parameters     = {        
    #     presto_view = "true"
    #     comment     = "Presto View"    
    # }
    parameters     = length(var.parameters) > 0 ? element(var.parameters, count.index) : {}


    storage_descriptor {
        ser_de_info {
            name                  = " "
            serialization_library = " "
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
    }
}
