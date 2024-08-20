resource "aws_cloudwatch_dashboard" "ecs_dasboard" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = var.widgets
  })
}
