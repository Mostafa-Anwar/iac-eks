variable "region" {
  default = "us-east-2"
}

variable "acc_key" {
  default = ""
}

variable "sec_key" {
  default = ""
}



variable "profile" {
  description = "The name of the AWS profile in the credentials file"
  type        = string
  default     = "default"
}


variable "vpc_name" {
  description = "VPC name for EKS"
  default     = "prod.eks-vpc"
}


variable "cluster-name" {
  description = "EKS cluster name"
  default     = "prod-eks-cluster"
}


## Tagging variables

variable "environment_tag" {
  description = "Tag variable for environment"
  default     = "Prod"
}


variable "project_name_tag" {
  description = "Tag variable for name of project"
  default     = "ABC"
}



##  S3 bucket name for dynamodb

variable "backend_state_bucket" {
  description = "S3 bucket for terraform backend dynamodb lock"
  default     = "prod-eks-terraform-backend-bucket"
}



## Dynamodb tables for Network and EKS resources

variable "stages" {
  type    = list(string)
  default = ["net", "eks"]
}

variable "stagecount" {
  type    = number
  default = 2
}



variable "table_name_net" {
  description = "The name of the DynamoDB table for networking resources."
  type        = string
  default     = "terraform-Prod-EKS-state-lock-dynamo-net"
}

variable "table_name_eks" {
  description = "The name of the DynamoDB table for eks resources ."
  type        = string
  default     = "terraform-Prod-EKS-state-lock-dynamo-eks-cluster"
}






variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default     = "10.94.0.0/16"
}


variable "az1" {
  default = "us-east-2a"
}

variable "az2" {
  default = "us-east-2b"
}


variable "public-subnet-az" {
  type    = list(string)
  default = ["10.94.0.0/24", "10.94.1.0/24"]
}


variable "private-subnet-az" {
  type    = list(string)
  default = ["10.94.2.0/24", "10.94.3.0/24"]
}


variable "pub-subs" {
  default = "pub-subnet-eks-az"
}


variable "priv-subs" {
  default = "priv-subnet-eks-az"
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
  ]
}

variable "eks_fs_rules" {
  default = [
    {
      port  = 2049
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

variable "key-pair" {
  description = "Key Pair name to ssh to EC2"
  default     = "eks-ec2"
}



variable "eks-worker-type" {
  description = "EKS worker nodes ec2 size"
  default     = "t3a.medium"
}


variable "eks-worker-disk-size" {
  description = "EKS worker nodes disk size"
  default     = "50"
}


variable "capacity-type" {
  description = "Type of capacity associated with the EKS Node Group"
  default     = "ON_DEMAND"
}



variable "eks-version" {
  default = "1.21"
}

