data "aws_availability_zones" "available" {}

# Create VPC for eks-cluster 

resource "aws_vpc" "eks_cluster_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = tomap(
    {
      Name                                            = var.vpc_name,
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared",
      Project                                         = var.project_name_tag
    }
  )

}


####  Create public and private subnet ####

resource "aws_subnet" "public_subnets" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = element(var.public_subnet_az, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.eks_cluster_vpc.id


  tags = tomap(
    {
      Name                                            = "${var.pub_subs}${count.index + 1}",
      Tier                                            = "Public",
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared",
      "kubernetes.io/role/elb"                        = "1",
      Project                                         = var.project_name_tag
    }
  )
}


resource "aws_subnet" "private_subnets" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = element(var.private_subnet_az, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.eks_cluster_vpc.id


  tags = tomap(
    {
      Name                                            = "${var.priv_subs}${count.index + 1}",
      Tier                                            = "Private",
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared",
      "kubernetes.io/role/internal-elb"               = "1",
      Project                                         = var.project_name_tag
    }
  )
}



####  Allocate ElasticIP for NAT GW  ####

resource "aws_eip" "nat_eip" {
  vpc        = true
 # depends_on = [$ { aws_internet_gateway.igw }]

  tags = {
    Name = var.natgw_eip_name
    environment = var.project_name_tag
  }
}


####  Create Internet and NAT GWs  ####

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_cluster_vpc.id

  tags = {
    Name    = var.igw_name
    Project = var.project_name_tag
  }
}


resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[1].id

  tags = {
    Name = var.natgw_name
    Project = var.project_name_tag

  }
}



####  Create public and private routers and associate them with their equivalent subnets ####


resource "aws_route_table" "pub_router" {

  vpc_id = aws_vpc.eks_cluster_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name    = var.public_route_table
    Project = var.project_name_tag
  }

}

resource "aws_route_table_association" "pub_association" {
  count = 2

  subnet_id      = aws_subnet.public_subnets.*.id[count.index]
  route_table_id = aws_route_table.pub_router.id

}



resource "aws_route_table" "priv_route" {

  vpc_id = aws_vpc.eks_cluster_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

    tags = {
        Name = var.private_route_table
        Project = var.project_name_tag
    }

}


resource "aws_route_table_association" "priv_association" {
  count = 2

  subnet_id      = aws_subnet.private_subnets.*.id[count.index]
  route_table_id = aws_route_table.priv_route.id

}
