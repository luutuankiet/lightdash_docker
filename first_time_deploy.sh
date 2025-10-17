#!/bin/bash
# setup.sh - A script to prepare the host and deploy the application

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
MINIO_UID=1001
POSTGRES_UID=999

# --- Main Logic ---
echo "Creating persistent directories..."
mkdir -p persistent/minio persistent/db traefik

echo "Setting directory ownership and permissions for persistent data..."
sudo chmod -R 777 persistent/minio
sudo chown $POSTGRES_UID:$POSTGRES_UID persistent/db

echo "Setting permissions for Traefik's acme.json file..."
# Create an empty acme.json file if it doesn't exist
touch traefik/acme.json
# Set permissions to 600 for acme.json (read/write for owner only)
sudo chmod 600 traefik/acme.json

echo "Verifying directory permissions..."
ls -ld persistent/minio
ls -ld persistent/db
ls -ld traefik
ls -l traefik/acme.json


echo "Scaffold complete! Deploy with docker compose up -d now."
