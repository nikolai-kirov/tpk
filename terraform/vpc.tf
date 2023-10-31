resource "aws_vpc" "tpk_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "tpk"
  }
}

resource "aws_subnet" "tpk_subnet1" {
  vpc_id     = aws_vpc.tpk_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-3a" 

  tags = {
    Name = "tpk"
  }
}

resource "aws_subnet" "tpk_subnet2" {
  vpc_id            = aws_vpc.tpk_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3b" 

  tags = {
    Name = "tpk"
  }
}

resource "aws_subnet" "tpk_subnet3" {
  vpc_id     = aws_vpc.tpk_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-3c"

  tags = {
    Name = "tpk"
  }
}

resource "aws_internet_gateway" "tpk_gw" {
  vpc_id = aws_vpc.tpk_vpc.id

  tags = {
    Name = "tpk"
  }
}
