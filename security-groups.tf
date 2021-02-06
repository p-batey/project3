#Create SG for LB, only TCP/80,TCP/443 and outbound access
resource "aws_security_group" "lb-sg" {
  provider    = aws.region-web
  name        = "lb-sg"
  description = "Allow 443 and 80 traffic to the website"
  vpc_id      = aws_vpc.web_vpc.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "website-sg" {
  provider    = aws.region-web
  name        = "website-sg"
  description = "Allow TCP/443"
  vpc_id      = aws_vpc.web_vpc.id
  ingress {
    description     = "allow anyone on port 443"
    from_port       = var.webserver-port
    to_port         = var.webserver-port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  ingress {
    description = "allow SSH from Bastion on port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.automation_pub_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
