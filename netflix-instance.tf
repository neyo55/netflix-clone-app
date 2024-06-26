# neflix-instance

# This file is used to create a key pair in AWS and store the private key in a local file.

# Ensure the directory for storing the private key exists 
resource "local_file" "private_key" {
  content  = tls_private_key.my_private_key.private_key_pem
  filename = "${path.module}/key/netflix-app-key.pem"
}

# Create a key pair in AWS
resource "aws_key_pair" "netflix_app_keypair" {
  key_name   = var.netflix_app_keypair_name
  public_key = tls_private_key.my_private_key.public_key_openssh # Use the public key generated from a TLS private key
}

# Generate a TLS private key
resource "tls_private_key" "my_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Fetch the latest Ubuntu AMI using a data source
data "aws_ami" "ubuntu_netflix" {
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


# Create elastic IP for Netflix instance
resource "aws_eip" "netflix_lb" {
  instance   = aws_instance.netflix_app_instance.id
  domain     = "vpc"
  depends_on = [aws_instance.netflix_app_instance]
}

# Associate the elastic IP with the Netflix instance
resource "aws_eip_association" "netflix_eip_assoc" {
  instance_id   = aws_instance.netflix_app_instance.id
  allocation_id = aws_eip.netflix_lb.id
}

# create netflix app instance 
resource "aws_instance" "netflix_app_instance" {
  ami             = data.aws_ami.ubuntu_netflix.id
  instance_type   = var.instance_type_netflix
  subnet_id       = aws_subnet.netflix_subnet.id
  key_name        = aws_key_pair.netflix_app_keypair.key_name
  security_groups = [aws_security_group.netflix_app_security_group.id]
  depends_on      = [aws_key_pair.netflix_app_keypair, aws_subnet.netflix_subnet, aws_security_group.netflix_app_security_group]

  user_data = filebase64("docker-setup.sh")

  tags = {
    Name = "${var.project_name}_netflix_app_instance"
  }

}
















# # Create a key pair
# resource "aws_key_pair" "my_key_pair" {
#   key_name   = var.keypair_name
#   public_key = tls_private_key.rsa.public_key_openssh
# }

# # Create a private key using resource
# resource "tls_private_key" "rsa" {
#   algorithm   = "RSA"
#   rsa_bits    = 4096
# }

# # Create a local file for the private key
# resource "local_file" "private_key" {
#   content  = tls_private_key.rsa.private_key_pem
#   filename = "key.pem"
# }




# # Create an EC2 instance
# resource "aws_instance" "main" {
#   count         = var.instance_count
#   ami           = data.aws_ami.latest_ubuntu.id
#   instance_type = var.instance_type
#   key_name      = var.keypair_name
#   subnet_id     = var.subnet_ids[count.index]
#   vpc_security_group_ids = [var.security_group_id]

#   user_data = <<-EOF
#   #!/bin/bash

#   # Update the package lists
#   sudo apt-get update -y

#   # install apache 
#   sudo apt-get install apache2 -y

#   # Start and enable the apache service
#   sudo systemctl enable apache2

#   # Create a simple index page
#   sudo bash -c 'echo THIS IS WEB SERVER > /var/www/html/index.html'

#   # Start the apache service
#   sudo systemctl start apache2

#   # Install Ansible
#   sudo apt-get install ansible -y

#   # Install Docker
#   sudo apt-get install docker.io -y

#   # Start and enable the Docker service
#   sudo systemctl start docker
#   sudo systemctl enable docker

#   # Add the user to the docker group to run Docker without sudo
#   sudo usermod -aG docker ubuntu
#   EOF 

#   tags = {
#     Name = "${var.environment}-instance-${count.index + 1}"
#   }
# }