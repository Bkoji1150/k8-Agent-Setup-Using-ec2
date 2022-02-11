
# Using the module from https://github.com/terraform-aws-modules/terraform-aws-ec2-instance
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(var.instance_name)

  version       = "~> 3.0"
  ami           = "ami-04505e74c0741db8d"
  name          = "instance-${each.key}"
  instance_type = "t2.medium"
  monitoring    = true

  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.id

  tags = {
    Name        = "instance-${each.key}"
    Environment = "sbx"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "s3_key"
  public_key = file(var.public_key_path)
}
