resource "aws_s3_bucket" "data-test-cicd" {
  # bucket is public
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-data-4a50bb30-eef0-4c3e-bbf9-47f6914f1844"
  acl           = "public"
  force_destroy = true
}

resource "aws_s3_bucket_object" "data_object" {
  bucket = aws_s3_bucket.data-test-cicd.id
  key    = "customer-master.xlsx"
  source = "resources/customer-master.xlsx"
}

resource "aws_s3_bucket" "financials" {
  # bucket is not encrypted
  # bucket does not have access logs
  # bucket does not have versioning
  bucket        = "${local.resource_prefix.value}-financials-4a50bb30-eef0-4c3e-bbf9-47f6914f1844"
  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket" "operations" {
  # bucket is not encrypted
  # bucket does not have access logs
  bucket = "${local.resource_prefix.value}-operations-4a50bb30-eef0-4c3e-bbf9-47f6914f1844"
  acl    = "private"
  versioning {
    enabled = true
  }
  force_destroy = true
}

resource "aws_s3_bucket" "data_science" {
  # bucket is not encrypted
  bucket = "${local.resource_prefix.value}-data-science-4a50bb30-eef0-4c3e-bbf9-47f6914f1844"
  acl    = "private"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = "${aws_s3_bucket.logs.id}"
    target_prefix = "log/"
  }
  force_destroy = true
}

resource "aws_s3_bucket" "logs" {
  bucket = "${local.resource_prefix.value}-logs-4a50bb30-eef0-4c3e-bbf9-47f6914f1844"
  acl    = "log-delivery-write"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "${aws_kms_key.logs_key.arn}"
      }
    }
  }
  force_destroy = true
}
