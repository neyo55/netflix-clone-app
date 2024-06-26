# create a security group for the instance 
resource "aws_security_group" "netflix_app_security_group" {
  name        = "netflix_app_security_group"
  description = "Allow traffic"
  vpc_id      = aws_vpc.netflix_vpc.id

  ingress {
    description = "NETFLIX_APP_SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NETFLIX_APP_HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   description = "NETFLIX_APP_ICMP"
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "icmp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    description = "NETFLIX_APP_PORT" # custom port for the netflix app 
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "JENKINS_SERVER" # custom port for the Jenkins server
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SONARQUBE_APP_PORT_&_PROMETHEUS_APP_PORT" # custom port for the SonarQube and Prometheus app
    from_port   = 9000
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "GRAFANA_APP_PORT" # custom port for Grafana app
    from_port   = 3000
    to_port     = 3300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_security_group"
  }

}






