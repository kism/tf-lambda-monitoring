# data "aws_iam_policy_document" "github_ecr_assume_role" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.github.arn]
#     }

#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     condition {
#       test     = "StringEquals"
#       variable = "token.actions.githubusercontent.com:aud"
#       values   = ["sts.amazonaws.com"]
#     }

#     condition {
#       test     = "StringLike"
#       variable = "token.actions.githubusercontent.com:sub"
#       values   = ["repo:kism/archivepodcast:*"]
#     }
#   }
# }


# resource "aws_ecr_repository" "kism_repository" {
#   name                 = "kism/archivepodcast"
#   image_tag_mutability = "MUTABLE"
# }

# data "aws_iam_policy_document" "github_ecr_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ecr:GetAuthorizationToken"
#     ]
#     resources = ["*"]
#   }

#   statement {
#     effect = "Allow"
#     actions = [
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload",
#       "ecr:BatchGetImage",
#       "ecr:PutImage"
#     ]
#     resources = [
#       aws_ecr_repository.kism_repository.arn
#     ]
#   }
# }


# resource "aws_iam_role" "github_ecr" {
#   name               = "github-ecr-push"
#   assume_role_policy = data.aws_iam_policy_document.github_ecr_assume_role.json
# }

# resource "aws_iam_policy" "github_ecr" {
#   name   = "GitHubECRPush"
#   policy = data.aws_iam_policy_document.github_ecr_policy.json
# }

# resource "aws_iam_role_policy_attachment" "github_ecr_attach" {
#   role       = aws_iam_role.github_ecr.name
#   policy_arn = aws_iam_policy.github_ecr.arn
# }
