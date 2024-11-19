#!/bin/bash
#cloud-config

# Update and upgrade the system
package_update: true
package_upgrade: true

# Install prerequisite packages
packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - software-properties-common

runcmd:
  # Add Docker's official GPG key
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  # Add Docker's official APT repository
  - echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Update the package database
  - apt-get update

  # Install Docker packages
  - apt-get install -y docker-ce docker-ce-cli containerd.io

  # Enable and start the Docker service
  - systemctl enable docker
  - systemctl start docker

  # Install Docker Compose
  - curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  - chmod +x /usr/local/bin/docker-compose

  # Verify Docker and Docker Compose installations
  - docker --version
  - docker-compose --version
