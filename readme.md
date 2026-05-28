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
| Prod (batched) | `main` | us-west-2 | Manual |

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
   - Push to `main` branch → triggers batched prod deployment (`batch-1`, `batch-2`)

## Local Development

```bash
# Initialize (dev/qa)
terraform init -backend-config="environments/dev/backend.hcl"

# Initialize (prod batch)
terraform init -backend-config="environments/prod/batch-1/backend.hcl"

# Plan
terraform plan -var-file="environments/dev/infra.tfvars"

# Plan for a prod batch with API-throttle friendly refresh skip
terraform plan -refresh=false -var-file="environments/prod/batch-1/infra.tfvars"

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
│       ├── batch-1/
│       └── batch-2/
├── modules/               # Reusable Terraform modules
│   ├── compute/
│   ├── network/
│   └── s3/
└── *.tf                  # Root configuration
```

## Features

- ✅ Multi-environment support
- ✅ Batched prod state sharding (`prod/batch-*`)
- ✅ Remote state with S3 locking
- ✅ Optional `-refresh=false` for high-load prod runs
- ✅ Automated CI/CD with GitHub Actions
- ✅ Manual approval for deployments
- ✅ Tenant-level S3 fanout (`tenant_ids`)