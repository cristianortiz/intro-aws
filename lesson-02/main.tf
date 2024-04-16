terraform {
    backend "s3" {
      bucket = "devops-directive-tf-state"
      key = "tf-infra/terraform.tfstate"
      region ="us-east-1"
      dynamodb_table ="terraform-state-locking"
      encrypt =true
    }
    
}

required_providers{
    aws {

    }
}