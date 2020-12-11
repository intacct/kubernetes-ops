data "template_file" "attach_nvme" {
    template = "${file("${path.module}/files/attach_ebs.sh")}"
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.attach_nvme.rendered}"
  }
}
