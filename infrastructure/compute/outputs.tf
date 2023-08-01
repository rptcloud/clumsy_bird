output "clumsy-bird-url" {
  value = "http://${aws_eip.clumsy_bird.public_dns}:8001"
}

output "clumsy-bird-ip" {
  value = "http://${aws_eip.clumsy_bird.public_ip}:8001"
}

output "s3_bucket" {
  value     = module.s3_bucket.s3_bucket_id
}