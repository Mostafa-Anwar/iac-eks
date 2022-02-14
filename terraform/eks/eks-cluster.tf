### Create required policies and roles to allow Kubernetes to access different AWS services ###

resource "aws_iam_role" "eks-cluster" {
  name = "terraform-eks-prod-cluster-role"
  

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster.name
}


### Create the EKS cluster ###

resource "aws_eks_cluster" "eks-cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.eks-cluster.arn
  version = var.eks-version
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
    ]
  vpc_config {
#    security_group_ids  = [aws_security_group.sg-eks-cluster.id]
#    subnet_ids          = aws_subnet.public-subnets[*].id
    security_group_ids  = [
      data.terraform_remote_state.net.outputs.sg-access,
    ]
    subnet_ids          = [
       data.terraform_remote_state.net.outputs.sub-pub1,
       data.terraform_remote_state.net.outputs.sub-pub2,
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  ]
}
