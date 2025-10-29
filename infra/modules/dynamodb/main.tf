resource "aws_dynamodb_table" "app" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  attribute { 
    name = "pk" 
    type = "S" 
    }
  tags = { 
    Name = "${var.project_name}-ddb" 
    }
}
