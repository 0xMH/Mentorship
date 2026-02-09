output "ec2_ids" {
    value = aws_instance.this[*].id
}