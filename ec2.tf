
resource "aws_instance" "website_server" {
  ami                    = "ami-00263659a97a6c29c" # ID to select amazon linux as OS 
  instance_type          = "t3.micro"
  key_name               = "chave-site-prod-terraform"
  vpc_security_group_ids = [aws_security_group.website_sg.id]
  iam_instance_profile   = "ECR-EC2-Role"

  tags = {
    Name        = "website-server"
    Provisioned = "terraform"
    Client      = "Tomas"
  }
}

resource "aws_security_group" "website_sg" {
  name        = "website-sg"
  description = "Security gruop for website"
  vpc_id      = "vpc-03abaea4beab93722"


  tags = {
    Name        = "website-sg"
    Provisioned = "terraform"
    Client      = "Tomas"
  }
}


# Network configurations

# Ingress rules 
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4         = "2.82.163.195/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.website_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Egress rules
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.website_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}