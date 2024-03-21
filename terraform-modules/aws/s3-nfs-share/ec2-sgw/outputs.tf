output "private_ip" {
  value       = aws_instance.ec2_sgw.private_ip
  description = "The Private IP address of the Storage Gateway on EC2"
}