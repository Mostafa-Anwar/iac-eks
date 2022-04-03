## Create dynamodb table to lock the state file,
## To prevent the risk of multiple concurrent attempts making changes to terraform infrastructure state
## (locking is a feature that prevents opening the state file while already in use) ##

resource "aws_dynamodb_table" "terraform_state_lock" {
  count        = var.stagecount
  name         = "${var.dynamo_table_name}_${format("%s", var.stages[count.index])}"
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