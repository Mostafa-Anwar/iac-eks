region              = "us-east-1"

profile             = "XYZA"

environment_tag     = "prod"

project_name_tag    = "XYZA" 

vpc_name            = "XYZA-prod-eks-vpc"

vpc_cidr            = "10.94.0.0/16"

az1                 = "us-east-1a"

az2                 = "us-east-1b"

public_subnet_az    = ["10.94.0.0/24", 
                      "10.94.10.0/24"]

private_subnet_az  = ["10.94.20.0/24",
                       "10.94.30.0/24"]

pub_subs            = "public-sub-eks-az"

priv_subs           = "private-sub-eks-az"

natgw_eip_name      = "nat-eip"

igw_name            = "xyza-prod-eks-igw"

natgw_name          = "xyza-prod-eks-ngw"

public_route_table  = "xyza-prod-eks-public-router"

private_route_table = "xyza-prod-eks-private-router"

eks_access_rules   = [
    {
      port  = 22
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
    {
      port  = 80
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
    {
      port  = 443
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
    {
      port  = 2049
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
    {
      port  = 3389
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
  ]

eks_rds_rules = [ 
    {
      port  = 5432
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
  ]


sg_eks_access_name = "XYZA-prod-eks-access"

sg_eks_db_name     = "XYZA-prod-eks-db"