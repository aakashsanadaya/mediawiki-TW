provider "aws" {
  region = "us-east-2"
}

 resource "aws_key_pair" "ec2_key" {
   key_name   = "bluesky"
   public_key = file("/tmp/id_rsa.pub")
 }

###### Module for VPC
module "vpc" {
  source = "./modules/vpc"
  instance-tenancy = "default"
  vpc-name = "mediawiki_vpc"
  region = "us-east-2"
  ig-name = "mediawiki-igw"
  map_pub_ip = "true"
  public-subnets-name = "public-subnets"
  public-subnet-routes-name = "public-subnet-routes"
  private-subnet-name = "private-subnets"
  nat_count = "1"
  eip-name = "eip-nat-gateway"
  nat-name = "nat-gateway"
  private-route-cidr = "0.0.0.0/0"
  private-route-name = "private-route"
  vpc-cidr = "10.0.0.0/16"
  vpc-public-subnet-cidr = ["10.0.1.0/24"]
  vpc-private-subnet-cidr = ["10.0.8.0/24"]
}

#####module for EC2 instance
module "ec2"{
    source = "./modules/ec2"
    ami = "ami-0e82959d4ed12de3f"
    instance_type = "t2.micro"
    subnet_id = "${element(tolist(module.vpc.public-subnet-ids), 1)}"
    key_name = "${aws_key_pair.ec2_key.key_name}"
    vpc_security_group_ids = ["${module.vpc.public-sg}"]
    associate_public_ip_address = true
    tags = "apache"
}

######module for ec2 database
module "ec2-mysql"{
    source = "./modules/ec2"
    ami = "ami-0e82959d4ed12de3f"
    instance_type = "t2.micro"
    subnet_id = "${element(tolist(module.vpc.private-subnet-ids), 1)}"
    key_name = "${aws_key_pair.ec2_key.key_name}"
    vpc_security_group_ids = ["${module.vpc.mysql-sg}"]
    tags = "mysql"
 }
