# WordPress Two-Tier Deployment on AWS (Docker)

This project deploys WordPress and MySQL using Docker containers on AWS.

The goal is to demonstrate DevOps concepts including:

- Infrastructure provisioning
- Containerized applications
- Persistent storage
- Automated backups

## Architecture

The application follows a simple two-tier architecture running on AWS.

            User Browser
                 │
                 ▼
            Internet
                 │
                 ▼
        EC2 Instance (Ubuntu)
                 │
                 ▼
            Docker Engine
            /           \
           ▼             ▼
     WordPress       MySQL
     Container      Container
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

## Technologies Used

AWS Services
- EC2
- EBS
- S3

DevOps Tools
- Docker
- Docker Compose
- Bash
- AWS CLI

---

## Project Structure

wordpress-project
│
├── provision.sh
├── docker-compose.yml
├── backup.sh
├── architecture.md
└── screenshots

---

## Deployment

Run the provisioning script:

chmod +x provision.sh  
./provision.sh

Start containers:

docker compose up -d

Then open the EC2 public IP in your browser.

---

## Backup

The backup script creates a MySQL dump and uploads it to S3.

Example file:

backup-2026-03-15.sql

---

## Author

Maryam Adedolapo Amunigun
