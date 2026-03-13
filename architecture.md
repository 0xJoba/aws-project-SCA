# WordPress Two-Tier Deployment Architecture

## Overview

This project deploys a containerized WordPress application with a MySQL database on AWS.  
The system follows a simple two-tier architecture consisting of:

1. A web/application layer running WordPress
2. A database layer running MySQL

Both services run as Docker containers on an EC2 instance. Persistent storage is provided through an attached EBS volume, while automated database backups are stored in an S3 bucket.

This architecture demonstrates core DevOps principles such as containerization, persistent storage management, automation through scripts, and cloud infrastructure design.

---

## Architecture Diagram

User Browser
     │
     ▼
 Public Internet
     │
     ▼
 EC2 Instance (Ubuntu)
     │
     ▼
 Docker Engine
   /        \
  ▼          ▼
WordPress    MySQL
Container    Container
                │
                ▼
         EBS Volume
      (/mnt/mysql-data)
                │
                ▼
         Backup Script
                │
                ▼
            S3 Bucket

---

## Components

### EC2 Instance

The application runs on an :contentReference[oaicite:0]{index=0} instance using Ubuntu Linux.

This instance acts as the main compute environment responsible for:

- Running Docker
- Hosting the WordPress container
- Hosting the MySQL container
- Executing the backup script

Using EC2 provides flexibility and full control over the infrastructure environment.

---

### Docker Containers

The application uses Docker to run services in isolated environments.

Docker containers make the application portable and easy to deploy because all dependencies are packaged together.

Two containers are used:

**WordPress Container**
- Runs the WordPress application
- Handles user requests from the browser
- Communicates with the MySQL database

**MySQL Container**
- Stores all WordPress data including posts, users, and configuration
- Runs separately from the WordPress container

Containers are managed using Docker Compose, which defines both services and their networking configuration.

---

### Persistent Storage (EBS)

The MySQL database requires persistent storage to ensure that data is not lost if containers stop or restart.

To achieve this, the MySQL data directory is mapped to an external storage location backed by an :contentReference[oaicite:1]{index=1} volume.

The volume is mounted on the EC2 instance at:

/mnt/mysql-data

This means:

- If the MySQL container stops, the data remains on the EBS disk
- If the container is recreated, MySQL reads the same database files
- Data remains safe as long as the EBS volume exists

This separation of compute and storage is a key principle in modern cloud architecture.

---

### Database Backups

In addition to persistent storage, the database is backed up regularly.

A script (`backup.sh`) performs the following steps:

1. Executes `mysqldump` inside the MySQL container
2. Creates a timestamped SQL backup file
3. Uploads the backup file to an S3 bucket

The backups are stored in :contentReference[oaicite:2]{index=2}.

Using S3 ensures that backups are stored separately from the EC2 instance and remain available even if the server is destroyed.

---

## Security Considerations

The EC2 instance is protected using a security group.

The following inbound rules are configured:

Port 22 (SSH)  
Allows administrators to connect to the server for management and troubleshooting.

Port 80 (HTTP)  
Allows users to access the WordPress website through a web browser.

In a production environment, SSH access would typically be restricted to specific IP addresses instead of allowing access from anywhere.

---

## Failure Scenarios

This architecture is designed to handle several potential failures.

If Docker containers stop:
- Containers can be restarted easily using Docker Compose
- Database data remains safe on the EBS volume

If the EC2 instance crashes:
- The instance can be replaced with a new one
- The EBS volume can be reattached
- Database backups can be restored from S3

This layered approach improves system resilience and data protection.

---

## Scalability Considerations

This architecture is suitable for small workloads or development environments. However, it can be extended to support larger systems.

Possible improvements include:

- Using a load balancer to distribute traffic across multiple servers
- Moving the database to a managed service such as Amazon RDS
- Using a CDN such as CloudFront for faster content delivery
- Implementing auto scaling for high availability

These improvements would make the architecture more robust and production-ready.

---

## Conclusion

This project demonstrates a basic but practical cloud architecture for deploying a containerized web application.

The design separates application services, storage, and backups to ensure better reliability and maintainability. By using AWS services such as EC2, EBS, and S3 along with Docker containers, the system follows modern DevOps deployment practices.
