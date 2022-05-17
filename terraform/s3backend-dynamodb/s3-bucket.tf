resource "aws_s3_bucket" "terraform_state_buck" {
  bucket = var.backend_state_bucket
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name        = "${var.backend_state_bucket_tag}"
    Environment = "${var.environment_tag}"
    Project     = "${var.project_name_tag}"
  }
}

