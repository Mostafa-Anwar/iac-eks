### Create required policies and roles to allow Kubernetes to access different AWS services ###
resource "aws_iam_role" "eks-node" {
  name = "terraform-eks-node-role"

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
  node_group_name = "m5axl-eks-workers"
  node_role_arn   = aws_iam_role.eks-node.arn
#  subnet_ids     = aws_subnet.public-subnets[*].id
  subnet_ids      = [
       data.terraform_remote_state.net.outputs.sub-pub1,
       data.terraform_remote_state.net.outputs.sub-pub2,
    ]
  instance_types  = var.eks-worker-type[*]
  disk_size       = var.eks-worker-disk-size
  capacity_type   = var.capacity-type


  remote_access {
    ec2_ssh_key = var.key-pair
  }

  
  scaling_config {
    desired_size = 1
    max_size     = 48
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
  ]

}





data "aws_eks_cluster" "cluster" {
  depends_on = [aws_eks_node_group.kubernetes-workers]
  name = var.cluster-name
}

data "aws_eks_cluster_auth" "cluster" {
   depends_on = [aws_eks_node_group.kubernetes-workers]
   name = var.cluster-name
}

data "tls_certificate" "cert" {
  depends_on = [aws_eks_node_group.kubernetes-workers]
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

#resource "aws_iam_openid_connect_provider" "openid_connect" {
#  depends_on = [aws_eks_node_group.kubernetes-workers]
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = [data.tls_certificate.cert.certificates.0.sha1_fingerprint]
#  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
#}

#provider "kubernetes" {
#  host                   = data.aws_eks_cluster.cluster.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#  token                  = data.aws_eks_cluster_auth.cluster.token
#  load_config_file       = false
#  version                = "~> 1.11.4"
#}

#module "ebs_csi_driver_controller" {
#  source = "DrFaust92/ebs-csi-driver/kubernetes"
#  version = "2.4.0"
#  depends_on = [aws_eks_node_group.kubernetes-workers]
#  ebs_csi_controller_role_name               = "ebs-csi-driver-controller"
#  ebs_csi_controller_role_policy_name_prefix = "ebs-csi-driver-policy"
#  oidc_url                                   = aws_iam_openid_connect_provider.openid_connect.url
#}



#data "aws_iam_role" "eks-node" {
#  name = "terraform-eks-prod-node-role"
#  depends_on = [aws_eks_node_group.kubernetes-workers]
#}

#module "kubernetes_dashboard" {
#  source = "cookielab/cluster-autoscaler-aws/kubernetes"
#  version = "0.9.0"
#  depends_on = [aws_eks_node_group.kubernetes-workers]
#  aws_iam_role_for_policy = data.aws_iam_role.eks-node.name

#  asg_tags = [
#    "k8s.io/cluster-autoscaler/enabled",
#    "k8s.io/cluster-autoscaler/${var.cluster-name}",
#  ]

#  kubernetes_deployment_image_tag = "v1.18.3"
#  skip_nodes_with_local_storage = "false"
#}

