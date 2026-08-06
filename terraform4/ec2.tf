data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_iam_policy" "ssm_core" {
  name = "AmazonSSMManagedInstanceCore"
}

module "my_server_rackula" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.4.0"

  name                        = "tf-server-rackula"
  ami                         = data.aws_ami.my_ami.id
  instance_type               = "t3.micro"
  subnet_id                   = module.my_vpc.public_subnets[0]
  create_security_group       = false
  vpc_security_group_ids      = [module.my_sg.id]
  create_iam_instance_profile = true
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = data.aws_iam_policy.ssm_core.arn
  }

  user_data = templatefile("userdata.sh", {})
  tags      = { Name = "tf-server-rackula" }
}
