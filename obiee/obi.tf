/* Create OBIEE Server on AWS
*/

provider "aws" {
  profile = "2auth"
  region = var.region
}

/*
resource "aws_key_pair" "srk" {
  key_name   = "sridhar.krishnamurthy"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAs0lgK+s8ud6wvsWWJDNM6pQajC+CtUTYBLtWOOiwf/Yhqy9aPt6rjBLPnEgQIOy6HuJK3wWCBw56wxp2ENUs6rHTkHasnAaEBmRZDEQU6pBPcSfGsQK9rqMncMTISJNb3/u8QjxgjUAxq0GdYLkwGRbNkvKeehusGvny29q9oyyfnJQnP/Hccb0HYzXxcf+ZqjS1KJnGj9hgAkVabPPRv19xNp6JRrrF9jJzCLMpJicn/hiko5xHLJ8g4b1UPSM346v+dr6O2eqpLHeQBZLTxm5ri3VkFP9072/fqLmE1XZAOPuEl7D2UZboC2uJ5CdCR5+yPSqRVIAiJIH1sN0qJw== Sridhar Krishnamurthy - US - Principal DevOps Engineer"

}
*/

# resource "aws_vpzc" "dev_obi_vpc" {
#   cidr_block = "${var.vpc_cidr}"

#   tags = {
#     Name = "srk_pg"
#   }
# }


# resource "aws_subnet" "dev_obi_subnet1" {
#   vpc_id     = var.vpc
#   cidr_block = var.subnet

#   tags = {
#     Name = "srk_subnet1"
#   }
# }


resource "aws_security_group" "dev_obi_sg" {
  name        = "dev_obi_sg"
  description = "Port definitions for Dev OBIEE servers"
  vpc_id      = var.vpc

  ingress {
    # Open port for servers to access Oracle RDS
    description = "Oracle server port"
    from_port   = 1521
    to_port     = 1521
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # Open SSH port
    description = "SSH port"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # Allow ICMP traffic to server for ping and traceroute functions
    description = "ICMP port"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    # Allow all outbound traffic
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "srk_obi_sg"
  }
}

resource "aws_instance" "dev_obi01" {
  subnet_id                   = var.subnet
  instance_type               = "t2.large"
  vpc_security_group_ids      = ["${aws_security_group.dev_obi_sg.id}"]
  associate_public_ip_address = false
  private_ip                  = "10.234.9.20"
  ami                         = "ami-01ed306a12b7d1c96"
  key_name                    = "sridhar.krishnamurthy"

  tags = {
    Name = "srk_obi01"
  }
}
