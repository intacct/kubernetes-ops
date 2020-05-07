
resource "aws_glue_crawler" "glue_crawler_s3" {
  count = "${var.create ? 1 : 0}"

  name          = "${var.name}"
  database_name = "${var.db}"
  role          = "${var.role}"

  schedule     = "${var.schedule}"
  table_prefix = "${var.table_prefix}"
  description  = "${var.description}"

  s3_target {
    path = var.data_source_paths[0]
  }
  s3_target {
    path = var.data_source_paths[1]
  }
  # dynamic "s3_target" {
  #   for_each = [for s in var.data_source_paths: {
  #     content {
  #       path = s
  #     }
  #   }]
  # }
   
}