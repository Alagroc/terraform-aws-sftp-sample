output "bucket_name" {
  value = var.s3_bucket_name
}
output "transfer_server_id" {
  value = aws_transfer_server.sftp_server.id
}
output "transfer_server_endpoint" {
  value = aws_transfer_server.sftp_server.endpoint
}
output "Service_name" {
  value = var.service_name
}
output "SFTP_user_name" {
  value = var.sftp_user_name
}
