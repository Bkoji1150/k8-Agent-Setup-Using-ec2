
# Using the module from https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
module "ec2_instance" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  version       = "~> 3.0"
  name          = "Ubuntu-Server"
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.medium"
  monitoring    = true
  #   vpc_security_group_ids      = [aws_security_group.My_VPC_Security_Group_Public.id]
  #   subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.id

  tags = {
    Name        = "Ubuntu-Server"
    Environment = "sbx"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "s3_key"
  public_key = file(var.public_key_path)
}
