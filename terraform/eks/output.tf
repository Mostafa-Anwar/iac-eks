output "efs-id" {
  value       = aws_efs_file_system.efs.id
  description = "The ID of the EFS"
}
