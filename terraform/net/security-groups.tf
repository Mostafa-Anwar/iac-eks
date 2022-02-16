####  Create Security groups for Worker nodes, EFS and RDS  ####

resource "aws_security_group" "sg_eks_access" {
  name        = "SG-eks-access"
  description = "Security group for the eks-cluster"
  vpc_id      = aws_vpc.eks-cluster.id
  dynamic "ingress" {
    for_each = var.eks_access_rules
    content {
      description = "Allow access to the worker nodes"
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidrs"]
    }
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "eks-access.sg"
    Project = var.project_name_tag
  }
}


resource "aws_security_group" "sg_eks_fs" {
  name        = "SG-eks-fs"
  description = "Security group for the eks-cluster"
  vpc_id      = aws_vpc.eks-cluster.id

  dynamic "ingress" {
    for_each = var.eks_fs_rules
    content {
      description = "Allow access to the worker nodes"
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidrs"]
    }
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_security_group.sg_eks_access,
  ]

  tags = {
    Name    = "eks-fs.sg"
    Project = var.project_name_tag
  }
}

resource "aws_security_group" "sg_eks_db" {
  name        = "SG-prod-eks-db"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.eks-cluster.id
  dynamic "ingress" {
    for_each = var.eks_fs_rules
    content {
      description = "Allow access to the worker nodes"
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidrs"]
    }
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name    = "prod.eks-db.sg"
    Project = var.project_name_tag
  }

  depends_on = [
    aws_security_group.sg_eks_access,
  ]
}