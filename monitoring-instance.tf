# monitoring instance


# Fetch the latest Ubuntu AMI using a data source
data "aws_ami" "ubuntu_monitoring" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID for Ubuntu AMIs

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create elastic IP for monitoring instance
resource "aws_eip" "monitoring_lb" {
  instance   = aws_instance.monitoring_app_instance.id
  domain     = "vpc"
  depends_on = [aws_instance.monitoring_app_instance]
}

# Associate the elastic IP with the Monitoring instance
resource "aws_eip_association" "monitoring_eip_assoc" {
  instance_id   = aws_instance.monitoring_app_instance.id
  allocation_id = aws_eip.monitoring_lb.id
}

# create netflix app instance 
resource "aws_instance" "monitoring_app_instance" {
  ami             = data.aws_ami.ubuntu_monitoring.id
  instance_type   = var.instance_type_monitoring
  subnet_id       = aws_subnet.netflix_subnet.id
  key_name        = aws_key_pair.netflix_app_keypair.key_name
  security_groups = [aws_security_group.netflix_app_security_group.id]
  depends_on      = [aws_key_pair.netflix_app_keypair, aws_subnet.netflix_subnet, aws_security_group.netflix_app_security_group]

  user_data = filebase64("monitoring.sh")

  tags = {
    Name = "${var.project_name}_monitoring_app_instance"
  }

}