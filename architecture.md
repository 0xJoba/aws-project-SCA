# WordPress Two-Tier Deployment Architecture

## Overview

This project deploys a two-tier web application consisting of WordPress and MySQL using Docker containers on an AWS EC2 instance.

The goal is to demonstrate infrastructure provisioning, container orchestration, persistent storage, and automated database backups.

The architecture uses the following AWS services:

- EC2 for compute
- EBS for persistent database storage
- S3 for database backups
- Docker and Docker Compose for container management

---

## System Architecture

User → Web Browser  
↓  
Public Internet  
↓  
EC2 Instance (Ubuntu Linux)  
↓  
Docker Engine  
↓  
WordPress Container  
↓  
MySQL Container  
↓  
EBS Volume (/mnt/mysql-data)

Database backups are periodically uploaded to an S3 bucket.

---

## Why EBS Is Used for MySQL Data

Containers are ephemeral, meaning their internal storage is temporary. If MySQL stored its database files inside the container filesystem, the data would be lost whenever the container restarts or is recreated.

To prevent this, MySQL's data directory is mapped to an external storage location backed by an EBS volume mounted at:

/mnt/mysql-data

This ensures that database data persists even if containers are stopped or replaced.

---

## Security Group Configuration

The EC2 instance uses a security group with the following inbound rules:

Port 22 (SSH)
Purpose: Allows administrators to connect securely to the server for management.

Port 80 (HTTP)
Purpose: Allows users to access the WordPress website via a web browser.

While SSH is currently open to 0.0.0.0/0 for simplicity in this assignment, a production environment would restrict SSH access to specific trusted IP addresses.

---

## Failure Scenarios

If the EC2 instance crashes or is terminated:

Lost components:
- EC2 server
- Running Docker containers

Components that survive:
- EBS volume containing MySQL database files
- S3 backups of the database

This design ensures that the database can be restored by attaching the EBS volume to a new EC2 instance or by restoring backups from S3.

---

## Backup Strategy

A backup script (`backup.sh`) creates a MySQL dump using `mysqldump` executed inside the running MySQL container.

The dump file is timestamped and uploaded to an S3 bucket using the AWS CLI.

This provides an additional layer of data protection beyond EBS persistence.

---

## Scaling Considerations

If the application needed to support significantly more users, several improvements could be made:

- Place WordPress behind an AWS Application Load Balancer
- Run multiple EC2 instances in an Auto Scaling Group
- Move the database to Amazon RDS for managed database scaling
- Store uploaded files using Amazon S3 instead of local storage
- Add CloudFront CDN for faster global content delivery

These improvements would increase reliability, scalability, and performance.

---

## Conclusion

This architecture demonstrates a simple but realistic cloud deployment for a containerized web application.

It separates compute, storage, and backups to improve reliability and maintainability while leveraging AWS cloud services for infrastructure.
