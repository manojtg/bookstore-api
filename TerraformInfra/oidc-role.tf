
# ----------------------------
# GitHub OIDC Role for Terraform/GitHub Actions
# ----------------------------

# Step 1: Data Source for GitHub OIDC
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# Step 2: IAM Role to Assume from GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "GitHubActionsDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = data.aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:manojtg/bookstore-api:*"
        }
      }
    }]
  })
}

# Step 3: Attach Inline Policy for ECS + ECR + Terraform basic permissions
resource "aws_iam_role_policy" "github_actions_policy" {
  name = "GitHubActionsPolicy"
  role = aws_iam_role.github_actions_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:*",
          "iam:PassRole",
          "logs:*",
          "ecr:*",
          "ec2:Describe*",
          "elasticloadbalancing:*"
        ],
        Resource = "*"
      }
    ]
  })
}
