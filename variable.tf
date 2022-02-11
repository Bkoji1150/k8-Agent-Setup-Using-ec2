
variable "aws_region" {
  description = "Region to which this Template would be deployed in."
  type        = string
  default     = "us-east-1"
}

variable "public_key_path" {
  type    = string
  default = "/Users/kojibello/.ssh/s3_key.pub"
}

variable "instance_name" {
  description = "Instance name"
  type        = list(any)
  default     = ["k8_controller", "K8_Nodes"]
}

variable "Envi_Choice" {
  description = "Preferred Env to run the Template, choose sbx/prod"
  type        = list(any)
  default = [
    "prod",
    "prod"
  ]
}
