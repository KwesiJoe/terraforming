resource "aws_ecr_repository" "repository" {
  count = length(var.repositories)
  name = var.repositories[count.index]
}

resource "aws_ecr_lifecycle_policy" "policy" {
  count = length(var.repositories)
  repository = aws_ecr_repository.repository[count.index].name
  depends_on = [ aws_ecr_repository.repository ]
  policy = <<EOF

{
  "rules": [
    {
      "rulePriority": 1,
      "description": "remove untagged images",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}

  EOF
}

resource "aws_ecs_cluster" "clusters" {
	count = length(var.clusters)
	name = var.clusters[count.index]

	setting {
    name  = "containerInsights"
    value = "enabled"
  }

}