# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY AND MANAGE A FUNCTION ON AWS LAMBDA
# This module takes a .zip file and uploads it to AWS Lambda
# to create a serverless function.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

locals {
  s3_bucket         = var.filename != null ? null : var.s3_bucket
  s3_key            = var.filename != null ? null : var.s3_key
  s3_object_version = var.filename != null ? null : var.s3_object_version

  # source_code_hash = var.source_code_hash != null ? var.source_code_hash : var.filename != null ? filebase64sha256(var.filename) : null
}
# locals {
#   # Use a generated filename to determine when the source code has changed.
#   # filename - to get package from local
#   filename    = var.local_existing_package != null ? var.local_existing_package : (var.store_on_s3 ? null : element(concat(data.external.archive_prepare.*.result.filename, [null]), 0))
#   was_missing = var.local_existing_package != null ? ! fileexists(var.local_existing_package) : element(concat(data.external.archive_prepare.*.result.was_missing, [false]), 0)

#   # s3_* - to get package from S3
#   s3_bucket         = var.s3_existing_package != null ? lookup(var.s3_existing_package, "bucket", null) : (var.store_on_s3 ? var.s3_bucket : null)
#   s3_key            = var.s3_existing_package != null ? lookup(var.s3_existing_package, "key", null) : (var.store_on_s3 ? element(concat(data.external.archive_prepare.*.result.filename, [null]), 0) : null)
#   s3_object_version = var.s3_existing_package != null ? lookup(var.s3_existing_package, "version_id", null) : (var.store_on_s3 ? element(concat(aws_s3_bucket_object.lambda_package.*.version_id, [null]), 0) : null)

# }

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_function" "lambda" {
  count = var.create_lamdba ? length(var.function_name) : 0

  function_name = element(var.function_name, count.index)
  description   = element(var.description, count.index)

  filename         = element(var.filename, count.index)
  # source_code_hash = local.source_code_hash
  source_code_hash = var.source_code_hash != null ? var.source_code_hash : var.filename != null ? filebase64sha256(element(var.filename,count.index)) : null

  s3_bucket         = local.s3_bucket
  s3_key            = local.s3_key
  s3_object_version = local.s3_object_version

  runtime = var.runtime
  handler = var.handler
  # layers  = var.layer_arns
  layers  = [aws_lambda_layer_version.this[0].arn]
  publish = var.publish
  role    = var.role_arn

  memory_size = var.memory_size
  timeout     = var.timeout

  reserved_concurrent_executions = var.reserved_concurrent_executions

  kms_key_arn = var.kms_key_arn

  dynamic environment {
    for_each = length(var.environment_variables) > 0 ? [true] : []

    content {
      variables = var.environment_variables
    }
  }

  dynamic dead_letter_config {
    for_each = length(var.dead_letter_config_target_arn) > 0 ? [true] : []

    content {
      target_arn = var.dead_letter_config_target_arn
    }
  }

  vpc_config {
    security_group_ids = var.vpc_security_group_ids
    subnet_ids         = var.vpc_subnet_ids
  }

  dynamic tracing_config {
    for_each = var.tracing_mode != null ? [true] : []

    content {
      mode = var.tracing_mode
    }
  }

  tags = merge(var.module_tags, var.function_tags)

  depends_on = [var.module_depends_on]
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A LAMBDA FUNCTION LAYER
# ----------------------------------------------------------------------------------------------------------------------

resource "aws_lambda_layer_version" "this" {
  count = var.create_layer ? length(var.layer_name) : 0

  layer_name   = element(var.layer_name, count.index)
  description  = element(var.layer_description, count.index)
  license_info = element(var.license_info, count.index)

  compatible_runtimes = length(var.compatible_runtimes) > 0 ? var.compatible_runtimes : [var.runtime]

  filename         = var.layer_filename
  source_code_hash = (var.layer_filename == null ? false : fileexists(var.layer_filename)) ? filebase64sha256(var.layer_filename) : null

  s3_bucket         = local.s3_bucket
  s3_key            = local.s3_key
  s3_object_version = local.s3_object_version

  # depends_on = [null_resource.archive, aws_s3_bucket_object.lambda_package]
}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE A MAP OF ALIASES FOR THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

locals {
  aliases = {
    for name, config in var.aliases : name => {
      description                = try(config.description, ""),
      version                    = try(config.version, "$LATEST")
      additional_version_weights = try(config.additional_version_weights, {})
    }
  }
}

# resource "aws_lambda_alias" "alias" {
#   for_each = var.module_enabled ? local.aliases : {}

#   name             = each.key
#   description      = each.value.description
#   function_name    = aws_lambda_function.lambda[0].function_name
#   function_version = each.value.version

#   dynamic routing_config {
#     for_each = length(each.value.additional_version_weights) > 0 ? [true] : []

#     content {
#       additional_version_weights = each.value.additional_version_weights
#     }
#   }
# }

# ----------------------------------------------------------------------------------------------------------------------
# ATTACH A MAP OF PERMISSIONS TO THE LAMBDA FUNCTION
# ----------------------------------------------------------------------------------------------------------------------

# locals {
#   permissions = {
#     for permission in var.permissions : permission.statement_id => {
#       statement_id       = permission.statement_id
#       action             = try(permission.action, "lambda:InvokeFunction")
#       event_source_token = try(permission.event_source_token, null)
#       principal          = permission.principal
#       qualifier          = try(permission.qualifier, null)
#       source_account     = try(permission.source_account, null)
#       source_arn         = permission.source_arn
#     }
#   }
# }

# resource "aws_lambda_permission" "permission" {
#   for_each = var.module_enabled ? local.permissions : {}

#   action             = each.value.action
#   event_source_token = each.value.event_source_token
#   function_name      = aws_lambda_function.lambda[0].function_name
#   principal          = each.value.principal
#   qualifier          = each.value.qualifier
#   statement_id       = each.key
#   source_account     = each.value.source_account
#   source_arn         = each.value.source_arn
# }
