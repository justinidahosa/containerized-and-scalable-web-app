output "backend_bucket"   { 
    value = aws_s3_bucket.tf_state.bucket 
}
output "lock_table_name"  { 
    value = aws_dynamodb_table.tf_lock.name 
}