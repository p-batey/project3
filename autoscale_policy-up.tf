# Create Autoscaling policy to scale up
resource "aws_autoscaling_policy" "web_policy_up" {
  provider               = aws.region-web
  name                   = "web_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.Web.name
}

# CloudWatch alarm to trigger when CPU greater than or equal to 60 for 4 minutes
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  provider            = aws.region-web
  alarm_name          = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Web.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.web_policy_up.arn]
}
