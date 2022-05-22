### Create the EKS cluster ###

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  # role_arn = aws_iam_role.eks_master_role.arn
  role_arn = aws_iam_role.eks_master_role.arn
  version  = var.eks_version
  enabled_cluster_log_types = var.enabled_log_types
  vpc_config {
    security_group_ids = [
      data.terraform_remote_state.net.outputs.sg-eks-access,
    ]
    subnet_ids = [
      data.terraform_remote_state.net.outputs.sub-pub1,
      data.terraform_remote_state.net.outputs.sub-pub2,
      data.terraform_remote_state.net.outputs.sub-priv1,
      data.terraform_remote_state.net.outputs.sub-priv2
    ]
    endpoint_public_access  = var.public_endpoint    
    endpoint_private_access = var.private_endpoint
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_master_role_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_master_role_AmazonEKSVPCResourceController,
  ]
}


### Create IAM OIDC for the cluster

data "tls_certificate" "cluster-cert" {
  url = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster-cert.certificates.0.sha1_fingerprint]
  url = aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
}