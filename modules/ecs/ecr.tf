resource "aws_ecr_repository" "services_repos" {
  for_each = var.services

  name                 = "${local.prefix}-${each.value.name}"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_lifecycle_policy" "services_repos_policy" {
  for_each = aws_ecr_repository.services_repos

  repository = each.value.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep only the 10 most recent Docker images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}
