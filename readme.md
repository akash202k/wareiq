# WareIQ Terraform Infrastructure

Multi-environment AWS infrastructure management using Terraform and GitHub Actions.

## Architecture

- **VPC** with public subnet and internet gateway
- **EC2** instance with security groups
- **S3** bucket with random suffix
- **Remote state** stored in S3 with native locking

## Environments

| Environment | Branch | Region | Approval |
|-------------|--------|--------|----------|
| Dev | `dev` | us-west-2 | Manual |
| QA | `qa` | us-west-2 | Manual |
| Prod | `prod` | us-west-2 | Manual |

## Quick Start

1. **Setup backend infrastructure:**
   ```bash
   cd terraform-infrastructure
   ./deploy.sh
   ```

2. **Configure GitHub secrets:**
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`

3. **Deploy to environment:**
   - Push to `dev` branch → triggers dev deployment
   - Push to `qa` branch → triggers qa deployment  
   - Push to `prod` branch → triggers prod deployment

## Local Development

```bash
# Initialize
terraform init -backend-config="environments/dev/backend.hcl"

# Plan
terraform plan -var-file="environments/dev/infra.tfvars"

# Apply
terraform apply -var-file="environments/dev/infra.tfvars"

# Destroy
terraform destroy -var-file="environments/dev/infra.tfvars"
```

## Structure

```
terraform-infrastructure/
├── environments/           # Environment-specific configs
│   ├── dev/
│   ├── qa/
│   └── prod/
├── modules/               # Reusable Terraform modules
│   ├── compute/
│   ├── network/
│   └── s3/
└── *.tf                  # Root configuration
```

## Features

- ✅ Multi-environment support
- ✅ Remote state with S3 locking
- ✅ Automated CI/CD with GitHub Actions
- ✅ Manual approval for deployments
- ✅ Modular Terraform architecture