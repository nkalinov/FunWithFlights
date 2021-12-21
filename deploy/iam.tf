# ECR user used for publishing images
resource "aws_iam_user" "github" {
  name = "github"
}

# todo: Custom policy with https://stackoverflow.com/questions/65727113/aws-ecr-user-is-not-authorized-to-perform-ecr-publicgetauthorizationtoken-on-r
resource "aws_iam_user_policy_attachment" "publisher_policy_AmazonEC2ContainerRegistryFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  user       = aws_iam_user.github.name
}
resource "aws_iam_user_policy_attachment" "publisher_policy_AmazonElasticContainerRegistryPublicFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicFullAccess"
  user       = aws_iam_user.github.name
}
resource "aws_iam_user_policy_attachment" "publisher_policy_AmazonS3FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  user       = aws_iam_user.github.name
}
resource "aws_iam_user_policy_attachment" "publisher_policy_AWSCodeDeployRoleForECS" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  user       = aws_iam_user.github.name
}

resource "aws_iam_access_key" "publisher" {
  user = aws_iam_user.github.name
}

output "iam_user_github_access_key" {
  value       = aws_iam_access_key.publisher.id
  description = "AWS_ACCESS_KEY of GitHub IAM user"
}

output "iam_user_github_secret_key" {
  value       = aws_iam_access_key.publisher.secret
  description = "AWS_SECRET_ACCESS_KEY of GitHub IAM user"
  sensitive   = true
}