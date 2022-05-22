####  Create Security groups for Worker nodes, EFS and RDS  ####

resource "aws_security_group" "sg_eks_access" {
  name        = var.sg_eks_access_name
  description = "Security group for the eks-cluster"
  vpc_id      = aws_vpc.eks_cluster_vpc.id
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
    Name        = var.sg_eks_access_name
    Project     = var.project_name_tag
    Environment = var.environment_tag
  }
}




resource "aws_security_group" "sg_eks_db" {
  name        = var.sg_eks_db_name
  description = "Security group for RDS"
  vpc_id      = aws_vpc.eks_cluster_vpc.id
  dynamic "ingress" {
    for_each = var.eks_rds_rules
    content {
      description     = "Allow access to the worker nodes"
      from_port       = ingress.value["port"]
      to_port         = ingress.value["port"]
      protocol        = ingress.value["proto"]
      security_groups = [aws_security_group.sg_eks_access.id]
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
    Name        = var.sg_eks_db_name
    Project     = var.project_name_tag
    Environment = var.environment_tag
  }

  depends_on = [
    aws_security_group.sg_eks_access,
  ]
}