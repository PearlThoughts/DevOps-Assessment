resource "aws_ecs_service" "notificationservice" {
   task_definition = aws_ecs_task_definition.notificationapp.id
   cluster = aws_ecs_cluster.mycluster.id
   launch_type = "FARGATE"
   name = "notificationservice"
   desired_count   = 1
   network_configuration {
    subnets         = aws_subnet.mysubnet[*].id
    security_groups = [aws_security_group.app_sg.id]
    assign_public_ip = true
   }
}
