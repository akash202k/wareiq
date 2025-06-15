bucket         = "wareiq-terraform-state-bucket"
key            = "qa/terraform.tfstate"
region         = "us-west-2"
encrypt        = true
dynamodb_table = "terraform-state-lock"