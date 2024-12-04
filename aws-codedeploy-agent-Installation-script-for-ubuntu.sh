#!/bin/bash

set -e

# Update the package list
echo "Updating the package list..."
sudo apt-get update

# Install Ruby and wget
echo "Installing Ruby and wget..."
sudo apt-get install -y ruby-full wget

# Navigate to /tmp for downloading the agent installer
echo "Switching to /tmp directory..."
cd /tmp

# Determine the operating system version and download the appropriate CodeDeploy package
echo "Downloading the AWS CodeDeploy Agent installer..."
AGENT_VERSION="latest"
if [[ `lsb_release -rs` == "22.04" ]]; then
  wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/$AGENT_VERSION/install
elif [[ `lsb_release -rs` == "20.04" ]]; then
  wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/$AGENT_VERSION/install
elif [[ `lsb_release -rs` == "18.04" ]]; then
  wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/$AGENT_VERSION/install
else
  echo "Unsupported Ubuntu version. Exiting."
  exit 1
fi

# Make the installer executable
echo "Making the installer executable..."
chmod +x ./install

# Run the installer
echo "Installing the AWS CodeDeploy Agent..."
sudo ./install auto

# Enable and start the CodeDeploy Agent
echo "Starting and enabling the AWS CodeDeploy Agent service..."
sudo systemctl enable codedeploy-agent
sudo systemctl start codedeploy-agent

# Check the status of the CodeDeploy Agent
echo "Checking the status of the AWS CodeDeploy Agent..."
sudo systemctl status codedeploy-agent

echo "AWS CodeDeploy Agent installation completed successfully!"
