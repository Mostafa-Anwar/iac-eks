
### Get latest Windows Server 2019 AMI

data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}




### Create and bootstrap a bastion host in us-east-1

resource "aws_instance" "eks_bastion" {
  ami                         = data.aws_ami.windows-2019.id
  instance_type               = var.bastion-instance-type
  key_name                    = var.key_pair
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.terraform_remote_state.net.outputs.sg-eks-access]
  subnet_id                   = data.terraform_remote_state.net.outputs.sub-pub1

  tags = {
    Name = var.bastion_name_tag
    Project = var.project_name_tag
    Environment = var.environment_tag
  }
}

