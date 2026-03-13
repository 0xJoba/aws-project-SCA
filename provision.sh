#!/bin/bash

echo "Updating system..."
sudo apt update -y

echo "Installing Docker..."
sudo apt install docker.io -y

echo "Starting Docker..."
sudo systemctl start docker
sudo systemctl enable docker

echo "Installing Docker Compose..."
sudo apt install docker-compose -y

echo "Installing AWS CLI..."
sudo apt install awscli -y

echo "Creating MySQL data directory..."
sudo mkdir -p /mnt/mysql-data

echo "Mounting EBS volume..."
if ! mount | grep "/mnt/mysql-data" > /dev/null
then
    sudo mount /dev/xvdf /mnt/mysql-data
fi

echo "Setting permissions..."
sudo chown -R ubuntu:ubuntu /mnt/mysql-data

echo "Provisioning complete!"
