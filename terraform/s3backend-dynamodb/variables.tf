variable "region" {
  default = "us-east-1"
}


variable "profile" {
  description = "The name of the AWS profile in the credentials file"
  type        = string
  default     = "XYZA"
}




## Tagging variables

variable "environment_tag" {
  description = "Tag variable for environment"
  default     = "prod"
}


variable "project_name_tag" {
  description = "Tag variable for name of project"
  default     = "XYZA"
}



##  S3 bucket name for dynamodb

variable "backend_state_bucket" {
  description = "S3 bucket for terraform backend dynamodb lock"
  default     = "xyza-prod-eks-terraform-backend-bucket"
}



variable "backend_state_bucket_tag" {
  description = "S3 bucket name tag for terraform backend dynamodb lock"
  default     = "xyza-eks-terraform-backend-bucket"
}



## Dynamodb tables for Network and EKS resources

variable "stages" {
  type    = list(string)
  default = ["net", "cluster"]
}

variable "stagecount" {
  type    = number
  default = 2
}



variable "dynamo_table_name" {
  description = "The name of the DynamoDB table for networking resources."
  type        = string
  default     = "terraform_XYZ_prod_eks_locks"
}





## Networks Resources (VPC, Subnets and SGs)


variable "vpc_name" {
  description = "VPC name for EKS"
  default     = "xyza-prod-eks-vpc"
}


variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.94.0.0/16"
}


variable "az1" {
  default = "us-east-1a"
}

variable "az2" {
  default = "us-east-1b"
}


variable "public_subnet_az" {
  type    = list(string)
  default = ["10.94.0.0/24", "10.94.10.0/24"]
}


variable "private_subnet_az" {
  type    = list(string)
  default = ["10.94.20.0/24", "10.94.30.0/24"]
}


variable "pub_subs" {
  default = "public-sub-eks-az"
}


variable "priv_subs" {
  default = "private-sub-eks-az"
}


variable "natgw_eip_name" {
  default = "nat-eip"
}


variable "igw_name" {
  default = "xyza-prod-eks-igw"
}


variable "natgw_name" {
  default = "xyza-prod-eks-ngw"
}


variable "public_route_table" {
  default = "xyza-prod-eks-public-router"
}


variable "private_route_table" {
  default = "xyza-prod-eks-private-router"
}


variable "eks_access_rules" {
  default = [
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
}


variable "eks_rds_rules" {
  default = [
    {
      port  = 5432
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
  ]
}


variable "sg_eks_access_name" {
  description = "Security group name for the eks-cluster access sg"
  default     = "XYZA-prod-eks-access"
}

variable "sg_eks_db_name" {
  description = "Security group name for the RDS"
  default     = "XYZA-prod-eks-db"
}



### EKS Control-Plane and Data-Plane

variable "eks_cluster_name" {
  description = "EKS cluster name"
  default     = "XYZA-prod-eks-cluster"
}


variable "eks_cluster_role" {
  description = "EKS control-plane IAM role"
  default     = "terraform-eks-prod-cluster-role"
}

variable "enabled_log_types" {
  description = "Logging for EKS Control plane" 
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  type        = list(string)
}

variable "public_endpoint" {
  description = "To enable public endpoint for the API server"
  default     = true
}

variable "private_endpoint" {
  description = "To enable private endpoint for the API server"
  default     = true
}


variable "eks_nodegroup_role" {
  description = "EKS data-plane IAM role"
  default     = "terraform-eks-prod-nodegroup-role"
}


variable "nodegroup_name" {
  description = "Name assigned to EKS node group"
  default     = "prod-m5axl-eks-workers"
}


variable "eks_workers_type" {
  description = "EKS worker nodes ec2 size"
  default     = "m5a.xlarge"
}


variable "eks_workers_disk_size" {
  description = "EKS worker nodes disk size"
  default     = "35"
}


variable "eks_workers_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  default     = "ON_DEMAND"
}


variable "key_pair" {
  description = "Key Pair name to ssh to EC2"
  default     = "prod-eks"
}


variable "eks_workers_desired_size" {
  description = "EKS Node group autoscaling desired size"
  default     = "3"
}


variable "eks_workers_max_size" {
  description = "EKS Node group autoscaling maximum size"
  default     = "10"
}

variable "eks_workers_min_size" {
  description = "EKS Node group autoscaling minimum size"
  default     = "3"
}


variable "eks_version" {
  default = "1.21"
}


variable "fargate_profile_role" {
  default = "terraform-eks-prod-fargate-role"
}


variable "fargate_profile_count" {
  type    = number
  default = 2
}

variable "fargate_profiles" {
  type    = list(string)
  default = ["fargate-1", "fargate-2"]
}


variable "fargate_profiles_namespaces" {
  type    = list(string)
  default = ["alpha", "beta"]
}




### Bastion Host 

variable "bastion-instance-type" {
  default = "t3a.medium"
}


variable "bastion_name_tag" {
  default = "XYZA-prod-bastion"
}


## EFS
variable "efs_creation_token" {
  default = "XYZA-prod-efs"
}

variable "efs_name_tag" {
  default = "XYZA-prod-efs"
}