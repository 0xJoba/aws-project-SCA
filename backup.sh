#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# 1. Load the variables from the .env file
# This is how you avoid hardcoding passwords in the script itself!
export $(grep -v '^#' .env | xargs)

TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
BACKUP_FILE="backup-$TIMESTAMP.sql"

echo "Creating database backup..."

# 2. Run the dump using the variable we just loaded
docker exec wordpress-db \
mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" wordpress \
> "$BACKUP_FILE"

echo "Uploading to S3..."

# 3. Upload to your bucket
aws s3 cp "$BACKUP_FILE" s3://wordpress-backup-joba-2026-904690835815-eu-north-1-an/

# 4. Optional: Remove the local file to save space
rm "$BACKUP_FILE"

echo "Backup $BACKUP_FILE uploaded successfully!"
