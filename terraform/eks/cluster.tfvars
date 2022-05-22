region             = "us-east-1"

profile            = "XYZA"

environment_tag    = "prod"

project_name_tag   = "XYZA" 

vpc_name           = "XYZA-prod-eks-vpc"


### EKS Control-Plane and Data-Plane
eks_cluster_name            = "xyza-prod-eks-cluster"

eks_cluster_role            = "terraform-eks-prod-cluster-role"

enabled_log_types           =  ["api", "audit", "authenticator", "controllerManager", "scheduler"]

public_endpoint             = true

private_endpoint            = true

eks_nodegroup_role          = "terraform-eks-prod-nodegroup-role"

nodegroup_name              = "prod-t3amed-eks-workers"

eks_workers_type            = "t3a.medium"

eks_workers_disk_size       = "35"

eks_workers_capacity_type   = "ON_DEMAND"

key_pair                    = "eks-ec2"

eks_workers_desired_size    = "1"

eks_workers_max_size        = "3"

eks_workers_min_size        = "1"

eks_version                 = "1.21"



### Bastion Host   
bastion-instance-type       = "t3a.medium"

bastion_name_tag            = "XYZA-prod-bastion"



## EFS
efs_creation_token        = "XYZA-prod-efs"

efs_name_tag              = "XYZA-prod-efs"
