#
# Definition of assume role 
#

resource "aws_iam_role" "sftp_role" {
  name = "iam_assume_role_sftp_${var.service_name}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

#
# Definition of iam role policy 
#

resource "aws_iam_role_policy" "sftp_policy" {
  name = "iam_role_sftp_${var.service_name}"
  role = aws_iam_role.sftp_role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "sftpSample",
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "*"
        },
        {
			    "Effect": "Allow",
          "Action": [
            "s3:ListBucket",
            "s3:GetBucketLocation"
          ],
         "Resource": [
            "arn:aws:s3:::${var.s3_bucket_name}"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion",
            "s3:GetObjectVersion",
            "s3:GetObjectACL",
            "s3:PutObjectACL"
          ],
          "Resource": [
            "arn:aws:s3:::${var.s3_bucket_name}/*"
        ]
      },
      {
        "Sid" : "KMSAccess",
        "Action" : [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Effect" : "Allow",
        "Resource" : "${data.aws_kms_key.s3.arn}"
      }
    ]
}
POLICY
}

#
# Definition of aws transfer server
#
resource "aws_transfer_server" "sftp_server" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = aws_iam_role.sftp_role.arn
  protocols              = ["SFTP"]

  tags = {
    Name   = "transfer-server-sftp-${var.service_name}"
    Vendor = var.service_name
  }
}

#
# Definition of sftp user 
#
resource "aws_transfer_user" "sftp_user" {
  server_id = aws_transfer_server.sftp_server.id
  user_name = var.sftp_user_name
  role      = aws_iam_role.sftp_role.arn

  home_directory_type = "PATH"
  home_directory      = "/${var.s3_bucket_name}"
}

#
# Definition of SSH key
#
resource "aws_transfer_ssh_key" "sftp_key" {
  server_id = aws_transfer_server.sftp_server.id
  user_name = aws_transfer_user.sftp_user.user_name
  body      = var.sftp_public_key
}

#
# Definition of KMS
#
data "aws_kms_key" "s3" {
  key_id = "alias/aws/s3"
}

