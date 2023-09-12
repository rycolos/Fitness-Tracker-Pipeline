#variables.tf
variable "access_key" {
    description = "Access key to AWS console"
}
variable "secret_key" {
    description = "Secret key to AWS console"
}
variable "db_user" {
    description = "Username for db"
}
variable "db_pass" {
    description = "Password for db"
}
variable "dev_pc" {
    description = "Public IP for development system"
}
variable "ami_id" {
    description = "AMI id for ec2 instance"
}
variable "ami_key_pair_name" {
    description = "Key pair for ec2 instance"
}


