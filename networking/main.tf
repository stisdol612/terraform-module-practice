# --- networking/main.tf

resource "random_integer" "random" {
  min = 1
  max = 10
}

resource "aws_vpc" "smt_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "smt_vpc-${random_integer.random.id}"
  }
}

resource "aws_subnet" "smt_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.smt_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"][count.index]

  tags = {
    Name = "smt_public_${count.index + 1}"
  }
}

resource "aws_subnet" "smt_private_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.smt_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"][count.index]

  tags = {
    Name = "smt_private_${count.index + 1}"
  }
}