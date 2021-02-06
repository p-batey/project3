# Create an Autoscaling Group starting with 2 nodes upto a max of 4
resource "aws_autoscaling_group" "Web" {
  name             = aws_launch_configuration.Web.name
  provider         = aws.region-web
  min_size         = 1
  desired_capacity = 2
  max_size         = 4

  # use the ELB health check on the are group ARN
  health_check_type = "ELB"
  target_group_arns = [aws_lb_target_group.app-lb-tg.arn]
  
  # Specify the required Launch Configuration
  launch_configuration = aws_launch_configuration.Web.name

  # Gathered metrics
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  # Use 2 defined AZs
  vpc_zone_identifier = [
    aws_subnet.public_us_east_1a.id,
    aws_subnet.public_us_east_1b.id
  ]

  # Required to redeploy without an outage. Instead of destroy_before_create
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

}
