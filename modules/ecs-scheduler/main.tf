resource "aws_cloudwatch_log_group" "lambda_ecs_scheduler" {
  name              = "/aws/lambda/${local.prefix}-ecs-scheduler"
  retention_in_days = 14
  tags              = local.common_tags
}

resource "aws_lambda_function" "ecs_scheduler" {
  filename         = "${path.module}/ecs-scheduler.js.zip"
  function_name    = "${local.prefix}-ecs-scheduler"
  handler          = "ecs-scheduler.handler"
  runtime          = "nodejs22.x"
  source_code_hash = filebase64sha256("${path.module}/ecs-scheduler.js.zip")
  role             = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      region       = var.region
      clusterName  = var.ecs_cluster
      services     = local.ecs_services_string
      desiredCount = "X"
    }
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_event_rule" "crons_start" {
  name                = "ecs-scheduler-start"
  schedule_expression = "cron(${var.crons_start})"
}

resource "aws_cloudwatch_event_rule" "crons_stop" {
  name                = "ecs-scheduler-stop"
  schedule_expression = "cron(${var.crons_stop})"
}

resource "aws_cloudwatch_event_target" "start_lambda" {
  rule      = aws_cloudwatch_event_rule.crons_start.name
  target_id = "start-ecs-lambda"
  arn       = aws_lambda_function.ecs_scheduler.arn
  input     = jsonencode({ desiredCount = "1" })
}

resource "aws_cloudwatch_event_target" "stop_lambda" {
  rule      = aws_cloudwatch_event_rule.crons_stop.name
  target_id = "stop-ecs-lambda"
  arn       = aws_lambda_function.ecs_scheduler.arn
  input     = jsonencode({ desiredCount = "0" })
}

resource "aws_lambda_permission" "allow_start_event" {
  statement_id  = "AllowExecutionFromEventBridgeStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.crons_start.arn
}

resource "aws_lambda_permission" "allow_stop_event" {
  statement_id  = "AllowExecutionFromEventBridgeStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_scheduler.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.crons_stop.arn
}
