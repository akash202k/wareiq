output "vpc_id" {
  value = module.network.vpc_id
}

output "instance_id" {
  value = module.compute.instance_id
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}