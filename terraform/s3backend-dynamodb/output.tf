#data "aws_s3_bucket" "terrafom-state-bucket" {
#  bucket = "prod-eks-terraform-backend"
#}

output "dynamodb_table_name_net" {
  value       = aws_dynamodb_table.terraform_state_lock[0].name
  description = "The name of the DynamoDB table"
}

output "dynamodb_table_name_eks" {
  value       = aws_dynamodb_table.terraform_state_lock[1].name
  description = "The name of the DynamoDB table"
}

output "region" {
  value       = aws_s3_bucket.terraform_state_buck[*].region
  description = "The name of the region"
}

output "s3_bucket" {
  value       = aws_s3_bucket.terraform_state_buck[*].bucket
  description = "The ARN of the S3 bucket"
}
