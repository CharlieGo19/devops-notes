output "s3_bucket_replication_source_arn" {
    value = aws_s3_bucket.s3_bucket_replication_source.arn
}

output "s3_bucket_replication_destination_arn" {
    value = aws_s3_bucket.s3_bucket_replication_destination.arn
}