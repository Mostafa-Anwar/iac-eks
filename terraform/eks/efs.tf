resource "aws_efs_file_system" "efs" {
   creation_token = "efs"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
 tags = {
     Name = "ABC-Prod-EFS"
     Project = var.project_name_tag
     Environment = var.environment_tag
   }
 }


resource "aws_efs_mount_target" "efs-mt-pub1" {
   file_system_id  = aws_efs_file_system.efs.id
   subnet_id = (data.terraform_remote_state.net.outputs.sub-pub1)
   security_groups = [
      data.terraform_remote_state.net.outputs.sg-efs,
    ]
 }

 resource "aws_efs_mount_target" "efs-mt-pub2" {
   file_system_id  = aws_efs_file_system.efs.id
   subnet_id = (data.terraform_remote_state.net.outputs.sub-pub2)
   security_groups = [
      data.terraform_remote_state.net.outputs.sg-efs,
    ]
 }

