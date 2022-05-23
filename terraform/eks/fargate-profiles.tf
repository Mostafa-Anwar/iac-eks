### Create Fargate profiles for EKS

resource "aws_eks_fargate_profile" "fargate_profile" {
  count = var.fargate_profile_count
  cluster_name           = var.eks_cluster_name
  fargate_profile_name   = element(var.fargate_profiles, count.index)
  pod_execution_role_arn = aws_iam_role.eks_fargate_role.arn
  subnet_ids             = [
      data.terraform_remote_state.net.outputs.sub-priv1,
      data.terraform_remote_state.net.outputs.sub-priv2,
  ]

  selector {
    namespace = var.fargate_profiles_namespaces[count.index]
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}