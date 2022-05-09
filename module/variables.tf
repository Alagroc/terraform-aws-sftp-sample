variable "s3_bucket_name" {
  description = "Bucket to be used to host files"
  type        = string
}
variable "sftp_user_name" {
  description = "SFTP username"
  type        = string
}
variable "context_name" {
  description = "Name of partner or any other context for this service"
  type        = string
}
variable "sftp_public_key" {
  description = "Public key for SFTP clients"
  type        = string
}
