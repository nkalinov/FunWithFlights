resource "aws_ecs_cluster" "funwithflights_cluster" {
  name = "funwithflights"
}

// ... the rest is configured per service.
// ex. data-service.tf