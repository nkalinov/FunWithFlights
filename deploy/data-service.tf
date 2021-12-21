resource "aws_ecs_task_definition" "funwithflights_data_service" {
  family             = "funwithflights-data-service"
  execution_role_arn = aws_iam_role.funwithflights_data_service_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name : "funwithflights-data-service",
      image : "${aws_ecr_repository.funwithflights_data_service.repository_url}:latest",
      portMappings : [
        {
          "containerPort" : 3000
        }
      ],
      environment : [],
      logConfiguration : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-region" : data.aws_region.current.name,
          "awslogs-group" : "/ecs/funwithflights-data-service",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])

  # These are the minimum values for Fargate containers.
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]

  # This is required for Fargate containers (more on this later).
  network_mode = "awsvpc"
}

resource "aws_ecs_service" "funwithflights_data_service" {
  name        = "funwithflights-data-service"
  launch_type = "FARGATE"

  cluster         = aws_ecs_cluster.funwithflights_cluster.id
  task_definition = aws_ecs_task_definition.funwithflights_data_service.arn

  network_configuration {
    assign_public_ip = false

    security_groups = [
      aws_security_group.egress_all.id,
      aws_security_group.ingress_api.id,
    ]

    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.funwithflights_service.arn
    container_name   = "funwithflights-data-service"
    container_port   = "3000"
  }

  desired_count = 1
}

resource "aws_ecr_repository" "funwithflights_data_service" {
  name = "funwithflights/data"
}

output "data_service_ecr_url" {
  value       = aws_ecr_repository.funwithflights_data_service.repository_url
  description = "The ECR repository URL for funwithflights-data-service"
}

output "data_service_ecr_repository_name" {
  value       = aws_ecr_repository.funwithflights_data_service.name
  description = "The ECR repository name for funwithflights-data-service"
}

resource "aws_cloudwatch_log_group" "funwithflights_data_service" {
  name = "/ecs/funwithflights-data-service"
}

# This is the role under which ECS will execute our task. This role becomes more important
# as we add integrations with other AWS services later on.

# The assume_role_policy field works with the following aws_iam_policy_document to allow
# ECS tasks to assume this role we're creating.
resource "aws_iam_role" "funwithflights_data_service_task_execution_role" {
  name               = "funwithflights-data-service-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Normally we'd prefer not to hardcode an ARN in our Terraform, but since this is
# an AWS-managed policy, it's okay.
data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
# Attach the above policy to the execution role.
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.funwithflights_data_service_task_execution_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

# Give task access to Dynamo
resource "aws_iam_policy" "dynamodb" {
  name        = "funwithflights-data-service-task-policy-dynamodb"
  description = "Policy that allows access to DynamoDB"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": [
               "dynamodb:CreateTable",
               "dynamodb:UpdateTimeToLive",
               "dynamodb:PutItem",
               "dynamodb:DescribeTable",
               "dynamodb:ListTables",
               "dynamodb:DeleteItem",
               "dynamodb:GetItem",
               "dynamodb:Scan",
               "dynamodb:Query",
               "dynamodb:UpdateItem",
               "dynamodb:UpdateTable"
           ],
           "Resource": "*"
       }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.funwithflights_data_service_task_execution_role.name
  policy_arn = aws_iam_policy.dynamodb.arn
}
