# ECR user used for publishing images
resource "aws_iam_user" "publisher" {
  name = "ecr-publisher"
}

# todo: Custom policy with https://stackoverflow.com/questions/65727113/aws-ecr-user-is-not-authorized-to-perform-ecr-publicgetauthorizationtoken-on-r
resource "aws_iam_user_policy_attachment" "publisher_policy_AmazonEC2ContainerRegistryFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  user       = aws_iam_user.publisher.name
}
resource "aws_iam_user_policy_attachment" "publisher_policy_AmazonElasticContainerRegistryPublicFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess"
  user       = aws_iam_user.publisher.name
}

resource "aws_iam_access_key" "publisher" {
  user = aws_iam_user.publisher.name
}

output "publisher_access_key" {
  value       = aws_iam_access_key.publisher.id
  description = "AWS_ACCESS_KEY to publish to ECR"
}

output "publisher_secret_key" {
  value       = aws_iam_access_key.publisher.secret
  description = "AWS_SECRET_ACCESS_KEY to upload to the ECR"
  sensitive   = true
}