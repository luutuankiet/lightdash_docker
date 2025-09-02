#!/bin/bash
# setup.sh - A script to prepare the host and deploy the application

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
MINIO_UID=1001
POSTGRES_UID=999

# --- Main Logic ---
echo "Creating persistent directories..."
mkdir -p persistent/minio persistent/db

echo "Setting directory ownership..."
chown $MINIO_UID:$MINIO_UID persistent/minio
chown $POSTGRES_UID:$POSTGRES_UID persistent/db

echo "Verifying directory permissions..."
ls -ld persistent/minio
ls -ld persistent/db

echo "Starting the application with Docker Compose..."
docker-compose up -d

echo "Deployment complete!"
