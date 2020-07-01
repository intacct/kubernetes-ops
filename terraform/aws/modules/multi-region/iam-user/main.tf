resource "aws_iam_user" "this" {
  count = var.create_user ? length(var.name) : 0

  name                 = element(var.name,count.index)
  path                 = var.path
  force_destroy        = var.force_destroy
  permissions_boundary = var.permissions_boundary
  tags                 = var.tags
}

resource "aws_iam_user_login_profile" "this" {
  count = var.create_user && var.create_iam_user_login_profile ? length(var.name) : 0

  user                    = aws_iam_user.this[count.index].name
  pgp_key                 = var.pgp_key
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
}

resource "aws_iam_access_key" "this" {
  count = var.create_user && var.create_iam_access_key && var.pgp_key != "" ? length(var.name) : 0

  user    = aws_iam_user.this[count.index].name
  pgp_key = var.pgp_key
}

resource "aws_iam_access_key" "this_no_pgp" {
  count = var.create_user && var.create_iam_access_key && var.pgp_key == "" ? length(var.name) : 0

  user = aws_iam_user.this[count.index].name
}

resource "aws_iam_user_ssh_key" "this" {
  count = var.create_user && var.upload_iam_user_ssh_key ? length(var.name) : 0

  username   = aws_iam_user.this[count.index].name
  encoding   = var.ssh_key_encoding
  public_key = var.ssh_public_key
}
