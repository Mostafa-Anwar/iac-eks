data "aws_availability_zones" "available" {}

#provider "aws" {
  # profile = "default"
#  region     = var.region
#  access_key = var.acc_key
#  secret_key = var.sec_key
#}



# Create VPC for eks-cluster 

resource "aws_vpc" "eks-cluster" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = tomap(
    {
      Name                                        = var.vpc_name,
      "kubernetes.io/cluster/${var.cluster-name}" = "shared",
      Project                                     = var.project_name_tag
    }
  )

}


####  Create public and private subnet ####

resource "aws_subnet" "public-subnets" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = element(var.public-subnet-az, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.eks-cluster.id


  tags = tomap(
    {
      Name                                        = "${var.pub-subs}${count.index + 1}",
      Tier                                        = "Public",
      "kubernetes.io/cluster/${var.cluster-name}" = "shared",
      Project                                     = var.project_name_tag
    }
  )
}


resource "aws_subnet" "private-subnets" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = element(var.private-subnet-az, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.eks-cluster.id


  tags = tomap(
    {
      Name                                        = "${var.priv-subs}${count.index + 1}",
      Tier                                        = "Private",
      "kubernetes.io/cluster/${var.cluster-name}" = "shared",
      Project                                     = var.project_name_tag
    }
  )
}


####  Create IGW  ####


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks-cluster.id

  tags = {
    Name    = "prod.eks-igw"
    Project = var.project_name_tag
  }
}


####  Create public router and associate it with its equivalent subnets ####


resource "aws_route_table" "pub-router" {

  vpc_id = aws_vpc.eks-cluster.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name    = "prod.eks-public-router"
    Project = var.project_name_tag
  }

}

resource "aws_route_table_association" "pub-association" {
  count = 2

  subnet_id      = aws_subnet.public-subnets.*.id[count.index]
  route_table_id = aws_route_table.pub-router.id

}
