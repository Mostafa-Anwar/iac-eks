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



variable "cluster-name" {
  description = "EKS cluster name"
  default     = "prod-eks-odoo"
}




variable "vpc_name" {
  description = "VPC name for EKS"
  default     = "prod.eks-vpc"
}



## Tagging variables

variable "environment_tag" {
  description = "Tag variable for environment"
  default     = "Prod"
}


variable "project_name_tag" {
  description = "Tag variable for name of project"
  default     = ""
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
  default = [ "10.94.0.0/24", "10.94.1.0/24" ]
}


variable "private-subnet-az" {
  type    = list(string)
  default = [ "10.94.2.0/24", "10.94.3.0/24" ]
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
      port = 22
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
    {
      port = 80
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
    {
      port = 443
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
  ]
}

variable "eks_fs_rules" {
  default = [
    {
      port = 2049
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
  ]
}

variable "eks_rds_rules" {
  default = [
    {
      port = 5432
      proto = "tcp"
      cidrs = ["0.0.0.0/0"]
    },
  ]
}