#!/bin/bash

# Update package lists
apt-get update

# Install Docker
apt-get install docker.io -y

# Add user 'ubuntu' to the Docker group
usermod -aG docker ubuntu

# Set permissions for Docker socket
chmod 777 /var/run/docker.sock

# Inform that Docker installation and configuration is completed
echo "Docker installation and configuration completed successfully." > /var/log/user-data.log

# Verify Docker installation and add output to log
docker --version >> /var/log/user-data.log

# Run a test Docker container and add output to log
docker run hello-world >> /var/log/user-data.log

################################ Jenkins Installation ################################

# Install Java package for Jenkins installation
apt-get update

# Install the required dependencies, including Fontconfig and OpenJDK 17 JRE
apt-get install -y fontconfig openjdk-17-jre

# Verify Java version installed and add output to log
java -version >> /var/log/user-data.log

# Download the Jenkins repository key and save it to `/usr/share/keyrings/jenkins-keyring.asc`
wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add the Jenkins repository to the system's sources list
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package index again to include the new Jenkins repository
apt-get update

# Install Jenkins
apt-get install -y jenkins

# Start Jenkins service
systemctl start jenkins

# Enable Jenkins service to start on boot
systemctl enable jenkins

# Inform that Jenkins installation and configuration is completed
echo "Jenkins installation and configuration completed successfully." >> /var/log/user-data.log

# Check Jenkins status and add output to log
systemctl status jenkins >> /var/log/user-data.log

# Install dependencies for Trivy
apt-get install -y wget apt-transport-https gnupg lsb-release

# Add Trivy GPG key
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -

# Add Trivy repository to sources list
echo deb https://aquasecurity.github.io/trivy-repo/deb "$(lsb_release -sc)" main | tee -a /etc/apt/sources.list.d/trivy.list

# Update package lists to include Trivy repository
apt-get update

# Install Trivy
apt-get install -y trivy

# Inform that Trivy installation is completed
echo "Trivy installation completed successfully." >> /var/log/user-data.log





########################################################

# #!/bin/bash

# # Update package lists
# apt-get update

# # Install Docker
# apt-get install docker.io -y

# # Add user 'ubuntu' to the Docker group
# usermod -aG docker ubuntu

# # Set permissions for Docker socket
# chmod 777 /var/run/docker.sock

# # Inform that Docker installation and configuration is completed
# echo "Docker installation and configuration completed successfully." > /var/log/user-data.log

# # Verify Docker installation and add output to log
# docker --version >> /var/log/user-data.log

# # Run a test Docker container and add output to log
# docker run hello-world >> /var/log/user-data.log

# ################################ Jenkins Installation ################################

# # Install Java package for Jenkins installation
# apt-get update

# # Install the required dependencies, including Fontconfig and OpenJDK 17 JRE
# apt-get install -y fontconfig openjdk-17-jre

# # Verify Java version installed and add output to log
# java -version >> /var/log/user-data.log

# # Download the Jenkins repository key and save it to `/usr/share/keyrings/jenkins-keyring.asc`
# wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# # Add the Jenkins repository to the system's sources list
# echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# # Update the package index again to include the new Jenkins repository
# apt-get update

# # Install Jenkins
# apt-get install -y jenkins

# # Start Jenkins service
# systemctl start jenkins

# # Enable Jenkins service to start on boot
# systemctl enable jenkins

# # Inform that Jenkins installation and configuration is completed
# echo "Jenkins installation and configuration completed successfully." >> /var/log/user-data.log

# # Check Jenkins status and add output to log
# systemctl status jenkins >> /var/log/user-data.log

# # Install dependencies for Trivy
# apt-get install -y wget apt-transport-https gnupg lsb-release

# # Add Trivy GPG key
# wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -

# # Add Trivy repository to sources list
# echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | tee -a /etc/apt/sources.list.d/trivy.list

# # Update package lists to include Trivy repository
# apt-get update

# # Install Trivy
# apt-get install -y trivy

# # Inform that Trivy installation is completed
# echo "Trivy installation completed successfully." >> /var/log/user-data.log

























































