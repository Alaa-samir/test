//variable "aws_access_key" {}
//variable "aws_secret_key" {}
variable "vpc-cidr" {
  description = "vpc cidr"
}
variable "pubsub-cidr" {
  description = "public subnet cidr"
}
variable "prisub-cidr" {
  description = "private subnet cidr"
}
variable "subnet_count" {
  description = "number of subnet"
}