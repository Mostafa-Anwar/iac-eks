#resource "aws_s3_bucket" "terrafom_state_bucket" {
#  bucket = var.backend_state_bucket

#  versioning {
#    enabled = true
#  }
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm = "AES256"
#      }
#    }
#  }
#  tags = {
#    Name        = "prod.eks-terraform.backend.S3"
#    Environment = "${var.environment_tag}"
#    Project = "${var.project_name_tag }"
#  }
#}





# Create dynamodb table to lock the state file, to prevent the risk of multiple concurrent attemptsto make changes to terraform infrastructure state (locking is a feature that prevents opening the state file while already in use)

resource "aws_dynamodb_table" "terraform_state_lock" {
  count        = var.stagecount
  name         = format("terraform_prod_eks_locks_%s", var.stages[count.index])
  depends_on   = [aws_s3_bucket.terraform_state_buck]
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Environment = "${var.environment_tag}"
    Project     = "${var.project_name_tag}"
  }
}
