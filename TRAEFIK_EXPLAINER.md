# Understanding Traefik with Docker

This document explains how Traefik works as a reverse proxy within a Docker environment, focusing on its dynamic configuration through Docker labels.

## What is Traefik?

Traefik is a modern **reverse proxy** and **load balancer** that makes deploying microservices easy. Think of it as a smart front door for your applications. When a request comes in from the internet, Traefik's job is to figure out which of your application containers should receive it.

The key feature that sets Traefik apart is its ability to **automatically discover** and configure itself to work with your services.

## How Traefik Integrates with Docker

Traefik's magic lies in its integration with orchestrators like Docker. This is handled by what Traefik calls **Providers**. We've configured Traefik to use the Docker provider.

Here's how it works:

1.  **Listening to Docker Events:** We gave the Traefik container access to Docker's socket (`/var/run/docker.sock`). This allows Traefik to listen to events happening within Docker, such as when a container starts, stops, or is updated.

2.  **Dynamic Configuration:** When Traefik detects a new container, it scans the container's **labels** for any configuration instructions. If it finds Traefik-specific labels, it automatically creates the necessary routing rules to direct traffic to that container.

This means you no longer need to manually edit a central configuration file (like `nginx.conf`) every time you add, remove, or change a service. The configuration for a service lives right alongside the service itself in your `docker-compose.yml`.

## The Core Concepts: Routers, Services, and Middlewares

Traefik's configuration is built around three main components:

*   **Routers:** A router's job is to examine an incoming request (looking at the domain name, path, headers, etc.) and decide where it should go. The core of a router is its **Rule**. In our case, the rule is `Host(`ld.kenluu.org`)`, which means "if a request comes in for `ld.kenluu.org`, this router should handle it."

*   **Services:** A service tells Traefik how to reach your actual application container. It knows the container's internal IP address and which port to forward the traffic to.

*   **Middlewares:** Middlewares are optional components that can modify a request before it's sent to your service. In our setup for the Traefik dashboard, we used a `basicauth` middleware to add password protection.

## Deconstructing the Docker Labels

Let's break down the labels we added to your `lightdash` service in the [`docker-compose.yml`](docker-compose.yml:123) file:

```yaml
labels:
    # 1. Enable Traefik for this service
    - "traefik.enable=true"

    # 2. Define a router named 'lightdash'
    - "traefik.http.routers.lightdash.rule=Host(`ld.kenluu.org`)"

    # 3. Set the entrypoint for this router to 'websecure' (HTTPS)
    - "traefik.http.routers.lightdash.entrypoints=websecure"

    # 4. Tell the router to use our Let's Encrypt certificate resolver
    - "traefik.http.routers.lightdash.tls.certresolver=letsencrypt"

    # 5. Define the service and tell it which port to use
    - "traefik.http.services.lightdash.loadbalancer.server.port=8080"
```

1.  `traefik.enable=true`: This is the master switch. It tells Traefik, "Pay attention to this container."

2.  `traefik.http.routers.lightdash.rule=Host(...)`: This creates a new HTTP **router** named `lightdash`. The `rule` specifies that this router will match any request where the `Host` header is `ld.kenluu.org`. This is how Traefik performs "DNS-like" routing.

3.  `traefik.http.routers.lightdash.entrypoints=websecure`: This connects our `lightdash` router to the `websecure` entrypoint, which we defined in [`traefik.yml`](traefik/traefik.yml) to be on port `443` (HTTPS).

4.  `traefik.http.routers.lightdash.tls.certresolver=letsencrypt`: This is a crucial instruction. It tells the `lightdash` router to handle TLS (SSL) termination and to obtain the necessary certificate from the `letsencrypt` certificate resolver we configured.

5.  `traefik.http.services.lightdash.loadbalancer.server.port=8080`: This defines the **service** that our router will forward traffic to. It tells Traefik that the `lightdash` container is listening for traffic on port `8080`. Traefik will automatically get the container's internal IP address and send the traffic to `<container-ip>:8080`.

By using this system of labels, you can define complex routing rules, add authentication, and manage SSL certificates in a declarative and highly automated way, right from your `docker-compose.yml` file.