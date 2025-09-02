# Lightdash Self-Hosted with Traefik

This repository provides a Docker Compose setup for self-hosting [Lightdash](https://www.lightdash.com/), an open-source business intelligence platform. It uses [Traefik](https://traefik.io/) as a reverse proxy to handle HTTPS, automatic certificate renewal with Let's Encrypt, and routing.

## Features

-   **Docker Compose:** All services are defined in a single `docker-compose.yml` for easy management.
-   **Traefik Reverse Proxy:** Handles all incoming traffic, routing to the correct service.
-   **Automatic HTTPS:** Traefik is configured to automatically obtain and renew SSL certificates from Let's Encrypt.
-   **Persistent Storage:** Data for PostgreSQL and Minio is stored in local volumes to ensure data persistence across container restarts.

## Prerequisites

-   A server with Docker and Docker Compose installed.
-   A registered domain name.
-   DNS records pointing your domain (e.g., `ld.your-domain.com`) to your server's public IP address.
-   A Cloudflare account and API token (or another DNS provider supported by Traefik's DNS challenge).

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-directory>
```

### 2. Configure Environment Variables

Copy the example environment file and update it with your specific settings.

```bash
cp .env.example .env
```

Now, edit the `.env` file and fill in the required values:

-   `SITE_URL`: The full URL where your Lightdash instance will be accessible (e.g., `https://ld.your-domain.com`).
-   `LETSENCRYPT_EMAIL`: Your email address for Let's Encrypt registration.
-   `PGPASSWORD`: A strong password for the PostgreSQL database.
-   `LIGHTDASH_SECRET`: A long, random string to secure sessions.

You will also need to provide your DNS provider credentials for the Let's Encrypt DNS challenge. For Cloudflare, you would set the `CF_API_TOKEN` or `CF_API_KEY` environment variables within the `.env` file (these are read by Traefik).

### 3. Run the First-Time Setup Script

This script creates the necessary directories and sets the correct permissions for the persistent volumes.

```bash
bash first_time_deploy.sh
```

### 4. Update Docker Compose Configuration

Open [`docker-compose.yml`](docker-compose.yml) and update the Traefik routing rule to use your domain:

```yaml
# In the 'lightdash' service labels:
- "traefik.http.routers.lightdash.rule=Host(`ld.your-domain.com`)"
```

### 5. Deploy the Application

Start all the services in detached mode:

```bash
docker compose up -d
```

Your Lightdash instance should now be available at the `SITE_URL` you configured. Traefik will automatically handle the SSL certificate generation, which may take a minute or two on the first run.

## Services

-   **`lightdash`**: The main Lightdash application.
-   **`traefik`**: The reverse proxy. You can access its dashboard for monitoring (by default, it's not exposed to the internet).
-   **`db`**: The PostgreSQL database for Lightdash.
-   **`minio`**: An S3-compatible object storage service used by Lightdash for file storage.

## Updating

To update to the latest version of Lightdash, you can pull the new image and restart the services:

```bash
docker compose pull lightdash
docker compose up -d
```
