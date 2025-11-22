terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-justin-web-app"
    key            = "backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-locks-justin-web-app"
    encrypt        = true
  }
}
