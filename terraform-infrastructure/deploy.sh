#!/bin/bash
# setup-backend.sh - Run this ONCE to create the S3 bucket and DynamoDB table

set -e

# Configuration
BUCKET_NAME="wareiq-terraform-state-bucket"
DYNAMODB_TABLE="terraform-state-lock"
REGION="us-west-2"  # Change this to your preferred region

echo "🚀 Setting up Terraform backend infrastructure..."

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

# Create DynamoDB table for state locking
echo "🔐 Creating DynamoDB table for state locking: $DYNAMODB_TABLE"
aws dynamodb create-table \
    --table-name $DYNAMODB_TABLE \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region $REGION

echo "✅ Backend infrastructure setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Update your GitHub Actions secrets with:"
echo "   - TERRAFORM_STATE_BUCKET: $BUCKET_NAME"
echo "   - TERRAFORM_DYNAMODB_TABLE: $DYNAMODB_TABLE"
echo ""
echo "2. Update backend.hcl files with the correct bucket name if different"
echo ""
echo "3. Run terraform init with backend config for each environment:"
echo "   terraform init -backend-config=environments/dev/backend.hcl"
echo "   terraform init -backend-config=environments/qa/backend.hcl"
echo "   terraform init -backend-config=environments/prod/backend.hcl"