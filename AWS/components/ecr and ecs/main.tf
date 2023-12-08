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

resource "aws_ecs_cluster_capacity_providers" "provider"{
  count = length(var.clusters)
  cluster_name = aws_ecs_cluster.clusters[count.index].name
  capacity_providers = ["FARGATE"]

    default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = "FARGATE"
  }
}
