
variable "aws_region" {
  description = "Region to which this Template would be deployed in."
  type        = string
  default     = "us-east-1"
}

variable "public_key_path" {
  type    = string
  default = "/Users/kojibello/.ssh/s3_key.pub"
}
