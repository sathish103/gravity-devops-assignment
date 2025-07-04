#SNS topic and cloudwatch alarm for monitoring

resource "aws_sns_topic" "cpu-alarm" {
    name = "gravity-cpu-alarm-topic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.cpu-alarm.arn
  protocol  = "email"
  endpoint  = "sathishdharma.dr@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "gravity_cpu_alarm" {
  alarm_name                = "gravity-cpu-alarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Alarm when CPU exceeds 80%"
  dimensions = {
    instanceId = aws_instance.gravity-ec2-instance.id
  }

  alarm_actions = [aws_sns_topic.cpu-alarm.arn]
}