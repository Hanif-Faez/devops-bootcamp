data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_iam_instance_profile" "my_ssm_profile" {
  name = "AWS-SSM"
}

data "aws_ssm_parameter" "token" {
  name = "/devops-bootcamp-2026/tunnel-token"
}

module "node1" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"
  name                   = "node1"
  ami                    = data.aws_ami.my_ami.id
  instance_type          = "t3.micro"
  subnet_id              = module.my_vpc.public_subnets[0] // Use the first public subnet
  create_security_group  = false
  vpc_security_group_ids = [module.my_sg.id] // Use the security group created in the VPC module
  key_name               = "FedoraLab"
  tags                   = { Name = "node1" }
  root_block_device = { size = 16 } // Increase root volume size to 16GB
}

module "node2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"
  name                   = "node2"
  ami                    = data.aws_ami.my_ami.id 
  instance_type          = "t3.micro" 
  subnet_id              = module.my_vpc.public_subnets[0] // Use the first public subnet from the VPC module
  create_security_group  = false // Disable security group creation since we are using an existing one
  vpc_security_group_ids = [module.my_sg.id]
  key_name               = "FedoraLab" 
  tags                   = { Name = "node2" }
  root_block_device = { size = 16 } // Increase root volume size to 16GB
}