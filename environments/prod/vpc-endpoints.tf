resource "aws_security_group" "vpc_endpoints" {
  name        = "vpc-endpoints-${var.environment}"
  description = "Allow HTTPS from VPC to AWS interface endpoints"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoints-${var.environment}"
  }
}


resource "aws_vpc_endpoint" "sts" {
  vpc_id            = data.aws_vpc.selected.id
  service_name      = "com.amazonaws.ap-south-1.sts"
  vpc_endpoint_type = "Interface"

  subnet_ids = data.aws_subnets.private.ids
  security_group_ids = [
    aws_security_group.vpc_endpoints.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "sts-endpoint-${var.environment}"
  }
}


resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = data.aws_vpc.selected.id
  service_name      = "com.amazonaws.ap-south-1.ec2"
  vpc_endpoint_type = "Interface"

  subnet_ids = data.aws_subnets.private.ids
  security_group_ids = [
    aws_security_group.vpc_endpoints.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "ec2-endpoint-${var.environment}"
  }
}


