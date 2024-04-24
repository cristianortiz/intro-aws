terraform {
  #S3 bucker and dynamoDB table area already setup, check de aws-backend-setup/main.tf
  backend "s3" {
    bucket         = "cris-ortiz-tfstate82"
    key            = "lesson-02/web-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cris-ortiz-tf-statelocking82"
    encrypt        = true
  }

required_providers {
  aws ={
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  
}

#EC2 instance
resource "aws_instance" "instance_1" {
  #Ubuntu, 22.04 LTS, amd64 jammy image build on 2024-03-01
  ami = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  security_groups = [aws.security_groups.instances.name]
  #hack to create very simple web app with bash and python
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, world 1 " > index.html
              python3 -m http.server 8080 &   
              EOF
  
}
#EC2 instance for replica ELB
resource "aws_instance" "instance_2" {
  #Ubuntu, 22.04 LTS, amd64 jammy image build on 2024-03-01
  ami = "ami-080e1f13689e07408"
  instance_type = "t2.micro"
  security_groups = [aws.security_groups.instances.name]
  #hack to create very simple web app with bash and python
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, world 2 " > index.html
              python3 -m http.server 8080 &   
              EOF
  
}