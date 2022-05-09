# Managed SFTP solution

This module will create an AWS managed SFTP service, basic configuration via SSH public key

It will serve files inside a S3 bucket. Uses default KMS key for the bucket.

## Sample usage:
inputs:
```
  s3_bucket_name    = "< bucket name, needs to be already existing >"
  service_name      = "< identifier or service context >"
  sftp_user_name    = "< username for the sftp service >"
  sftp_public_key   = "ssh public key"
}
```

# TODO

- Custom KMS arn not available yet, pending implementation

- Better ways to handle the public key

- Bucket creation

- Lots more to improve :)
