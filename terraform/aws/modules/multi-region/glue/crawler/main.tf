
resource "aws_glue_crawler" "glue_crawler_s3" {
  count = var.create ? 1 : 0

  name          = var.name
  database_name = var.db
  role          = var.role
  schedule      = var.schedule 
  table_prefix  = var.table_prefix
  description   = var.description

  schema_change_policy {
    delete_behavior = var.delete_behavior
    update_behavior = var.update_behavior
  }

  s3_target {
    path = var.data_source_paths[0]
  }
  s3_target {
    path = var.data_source_paths[1]
  }
  # dynamic "s3_target" {
  #   for_each = var.data_source_paths
  #   content {
  #       path = data_source_paths
  #   }
  # }
   
}