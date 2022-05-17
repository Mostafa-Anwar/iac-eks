### Create required policies and roles to allow Kubernetes to access different AWS services ###
resource "aws_iam_role" "eks-node" {
  name = var.eks_nodegroup_role

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node.name
}


### Create EKS node group and instances ###

resource "aws_eks_node_group" "kubernetes-workers" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = var.nodegroup_name
  node_role_arn   = aws_iam_role.eks-node.arn
  #  subnet_ids     = aws_subnet.public-subnets[*].id
  subnet_ids = [
    data.terraform_remote_state.net.outputs.sub-pub1,
    data.terraform_remote_state.net.outputs.sub-pub2,
  ]
  instance_types = var.eks_workers_type[*]
  disk_size      = var.eks_workers_disk_size
  capacity_type  = var.eks_workers_capacity_type


  remote_access {
    ec2_ssh_key = var.key_pair
  }


  scaling_config {
    desired_size = var.eks_workers_desired_size
    max_size     = var.eks_workers_max_size
    min_size     = var.eks_workers_min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
  ]

}



