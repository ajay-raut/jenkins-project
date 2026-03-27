
resource "aws_security_group" "app_server_sg" {
  name        = "app_server_sg"
  description = "Allow SHH and TCP traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    description = "Allow out bonds traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "AppServerSecurityGroup"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-019715e0d74f695be"
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  user_data = <<-EOF
                #!/bin/bash
                apt-get update
                apt-get install apache2 wget unzip vim -y
                systemctl enabled apache2
                mkdir -p /tmp/finance
                cd /tmp/finance
                wget https://www.tooplate.com/zip-templates/2135_mini_finance.zip
                unzip -o 2135_mini_finance.zip
                cp -r 2135_mini_finance/* /var/www/html/
                systemctl restart apache2
                cd /tmp/
                rm -rf /tmp/finance            
              EOF

  tags = {
    Name = var.instance_name
  }
}

# Output the Public IP after creation
output "instance_public_ip" {
  value = aws_instance.app_server.public_ip
}
