# Lightdash with Traefik on Docker

This repository provides a production-ready setup for deploying [Lightdash](https://www.lightdash.com/) using Docker and Docker Compose. It includes [Traefik](https://traefik.io/) as a reverse proxy to handle SSL termination with automatic certificate generation from [Let's Encrypt](https://letsencrypt.org/).

## Features

- **Lightdash**: An open-source business intelligence platform.
- **Traefik**: A modern reverse proxy and load balancer that automatically discovers services.
- **Let's Encrypt**: Automated SSL certificate generation and renewal.
- **Docker Compose**: Easy, single-command deployment.
- **Secure by Default**: The Traefik dashboard is secured with basic authentication.
- **Simple Setup**: A single script handles directory creation, permissions, and initial launch.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

You will also need a domain name and the ability to point DNS records to the server where you will be running this stack.

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd <repository-directory>
```

### 2. Configure Environment Variables

Create a `.env` file by copying the example file:

```bash
cp .env.example .env
```

Now, open the `.env` file with your favorite editor and set the following variables:

- `SITE_URL`: The full URL for your Lightdash instance (e.g., `https://ld.your-domain.com`).
- `LETSENCRYPT_EMAIL`: Your email address. Let's Encrypt will use this to send you important notifications about your SSL certificates.
- `TRAEFIK_DASHBOARD_USERNAME`: The username you want to use for the Traefik dashboard (e.g., `admin`).
- `TRAEFIK_DASHBOARD_PASSWORD`: The password for the Traefik dashboard.

You can also customize any of the other Lightdash or PostgreSQL variables as needed.

### 3. Update DNS Records

In your domain registrar or DNS provider's dashboard, create two `A` records pointing to your server's public IP address:

- An `A` record for your Lightdash instance (e.g., `ld.your-domain.com`).
- An `A` record for your Traefik dashboard (e.g., `traefik.ld.your-domain.com`).

### 4. Run the Deployment Script

The included script will handle creating the necessary directories, setting the correct file permissions, and launching the entire stack.

```bash
bash first_time_deploy.sh
```

The first time you run this, it may take a few minutes to download all the necessary Docker images.

## Accessing Your Services

- **Lightdash**: Once the services are running and Traefik has obtained the SSL certificate (this can take a minute or two), you can access your Lightdash instance at the `SITE_URL` you configured (e.g., `https://ld.your-domain.com`).

- **Traefik Dashboard**: You can monitor the status of your services and certificates by accessing the Traefik dashboard at the URL you configured in your DNS (e.g., `https://traefik.ld.your-domain.com`). You will be prompted for the username and password you set in your `.env` file.

## Understanding the Magic

This setup uses Traefik's powerful Docker integration to automatically configure routing and SSL. To learn more about how this works, please see the detailed explanation in [`TRAEFIK_EXPLAINER.md`](./TRAEFIK_EXPLAINER.md).