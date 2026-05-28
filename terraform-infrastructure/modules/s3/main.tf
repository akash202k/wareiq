locals {
  tenant_suffix = var.tenant_id == null ? "" : "-${lower(replace(var.tenant_id, "_", "-"))}"
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.bucket_prefix}-${var.environment}${local.tenant_suffix}-${random_id.suffix.hex}"

  tags = merge(
    {
      Name      = "${var.bucket_prefix}-${var.environment}${local.tenant_suffix}"
      ManagedBy = "terraform"
    },
    var.tenant_id == null ? {} : { TenantId = var.tenant_id }
  )
}

resource "random_id" "suffix" {
  byte_length = 4
}