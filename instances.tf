# Upload local key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "web-key" {
  provider   = aws.region-web
  key_name   = "web-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create Lauch Configuration with the prefix Web-
resource "aws_launch_configuration" "Web" {
  provider                    = aws.region-web
  name_prefix                 = "Web-"
  image_id                    = var.instance-ami
  instance_type               = var.instance-type
  key_name                    = "web-key"
  security_groups             = [aws_security_group.website-sg.id]
  associate_public_ip_address = true

  user_data = <<USER_DATA
#!/bin/bash
yum update -y
yum -y install httpd git
cd /tmp;git clone https://github.com/p-batey/static-website.git
mv static-website/index.html /var/www/html/
mv static-website/images /var/www/html/
mv static-website/assets /var/www/html/
mv static-website/error /var/www/html/
sudo sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
# Harden Apache
echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf
echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf
yum -y install mod_security
systemctl start httpd
systemctl enable httpd
  USER_DATA

  lifecycle {
    create_before_destroy = true
  }
}
