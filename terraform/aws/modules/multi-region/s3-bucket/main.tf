provider "aws" {
  profile = var.auth_profile
  region = var.region
}

resource "aws_s3_bucket" "this" {
  count = var.create_bucket ? 1 : 0

  bucket              = var.bucket
  bucket_prefix       = var.bucket_prefix
  acl                 = var.acl
  tags                = var.tags
  force_destroy       = var.force_destroy
  acceleration_status = var.acceleration_status
  # region              = var.region
  request_payer       = var.request_payer

  dynamic "versioning" {
    for_each = length(keys(var.versioning)) == 0 ? [] : [var.versioning]

    content {
      enabled    = lookup(versioning.value, "enabled", null)
      mfa_delete = lookup(versioning.value, "mfa_delete", null)
    }
  }

  dynamic "logging" {
    for_each = length(keys(var.logging)) == 0 ? [] : [var.logging]

    content {
      target_bucket = logging.value.target_bucket
      target_prefix = lookup(logging.value, "target_prefix", null)
    }
  }
}

resource "aws_s3_bucket_object" "this" {
    count   = var.create_s3_objects ? length(var.obj_name) : 0
    bucket  = aws_s3_bucket.this[0].id
    acl     = var.acl
    key     = element(var.obj_name, count.index)
    source  = var.obj_source
}

resource "aws_s3_bucket_policy" "this" {
  count = var.create_bucket && (var.attach_elb_log_delivery_policy || var.attach_policy) ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = var.attach_elb_log_delivery_policy ? data.aws_iam_policy_document.elb_log_delivery[0].json : var.policy
}

# AWS Load Balancer access log delivery policy
data "aws_elb_service_account" "this" {
  count = var.create_bucket && var.attach_elb_log_delivery_policy ? 1 : 0
}

data "aws_iam_policy_document" "elb_log_delivery" {
  count = var.create_bucket && var.attach_elb_log_delivery_policy ? 1 : 0

  statement {
    sid = ""

    principals {
      type        = "AWS"
      identifiers = data.aws_elb_service_account.this.*.arn
    }

    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.this[0].id}/*",
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.create_bucket ? 1 : 0

  // Chain resources (s3_bucket -> s3_bucket_policy -> s3_bucket_public_access_block)
  // to prevent "A conflicting conditional operation is currently in progress against this resource."
  bucket = (var.attach_elb_log_delivery_policy || var.attach_policy) ? aws_s3_bucket_policy.this[0].id : aws_s3_bucket.this[0].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}