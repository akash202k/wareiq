#!/bin/bash
# setup-backend.sh - Run this ONCE to create the S3 bucket for Terraform state

set -e

# Configuration
BUCKET_NAME="wareiq-terraform-state-bucket"
REGION="us-west-2"  # Change this to your preferred region

echo "🚀 Setting up Terraform S3 backend infrastructure..."

# Create S3 bucket for state storage
echo "📦 Creating S3 bucket: $BUCKET_NAME"
aws s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION \
    --create-bucket-configuration LocationConstraint=$REGION

# Enable versioning on the bucket
echo "🔄 Enabling versioning on S3 bucket"
aws s3api put-bucket-versioning \
    --bucket $BUCKET_NAME \
    --versioning-configuration Status=Enabled

# Enable server-side encryption
echo "🔒 Enabling server-side encryption"
aws s3api put-bucket-encryption \
    --bucket $BUCKET_NAME \
    --server-side-encryption-configuration '{
        "Rules": [
            {
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }
        ]
    }'

# Block public access
echo "🛡️ Blocking public access"
aws s3api put-public-access-block \
    --bucket $BUCKET_NAME \
    --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "✅ S3 backend infrastructure setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Update your GitHub Actions secrets with:"
echo "   - TERRAFORM_STATE_BUCKET: $BUCKET_NAME"
echo ""
echo "2. Run terraform init with backend config for each environment:"
echo "   terraform init -backend-config=environments/dev/backend.hcl"
echo "   terraform init -backend-config=environments/qa/backend.hcl"
echo "   terraform init -backend-config=environments/prod/batch-1/backend.hcl"
echo "   terraform init -backend-config=environments/prod/batch-2/backend.hcl"
echo ""
echo "🔐 Note: Using S3-native locking (use_lockfile=true) - no DynamoDB table needed!"