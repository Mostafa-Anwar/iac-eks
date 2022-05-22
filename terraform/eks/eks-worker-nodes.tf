### Create EKS node group and instances ###

resource "aws_eks_node_group" "kubernetes_workers" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.nodegroup_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  #  subnet_ids     = aws_subnet.public-subnets[*].id
  subnet_ids = [
      data.terraform_remote_state.net.outputs.sub-priv1,
      data.terraform_remote_state.net.outputs.sub-priv2,
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
    aws_eks_cluster.eks_cluster,
    aws_iam_role_policy_attachment.eks_node_role_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_role_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_role_AmazonEC2ContainerRegistryReadOnly,
  ]

}



