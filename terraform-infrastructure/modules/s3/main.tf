resource "aws_s3_bucket" "main" {
  bucket = "${var.bucket_prefix}-${var.environment}-${random_id.suffix.hex}"

  tags = {
    Name = "${var.bucket_prefix}-${var.environment}"
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}