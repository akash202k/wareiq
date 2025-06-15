bucket         = "wareiq-terraform-state-bucket"
key            = "dev/terraform.tfstate"
region         = "ap-south-1"
encrypt        = true
dynamodb_table = "terraform-state-lock"