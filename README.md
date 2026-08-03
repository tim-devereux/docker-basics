# Docker Basics

A short, hands-on primer on Docker containers: what they are, the core
commands, and how to build your own image.

## 1. Images vs. Containers

- **Image** — a read-only template (filesystem + metadata) that describes
  what should run: an OS layer, your code, dependencies, and a default
  command. Built once, reused everywhere.
- **Container** — a running (or stopped) *instance* of an image. It's an
  isolated process with its own filesystem, network, and process tree,
  but it shares the host's kernel (this is why containers start in
  milliseconds, unlike VMs).

Think of an image like a class, and a container like an object created
from it — you can run many containers from the same image.

## 2. Install & sanity check

Install Docker Desktop (Mac/Windows) or Docker Engine (Linux), then:

```bash
docker version    # confirms client + daemon are talking
docker run hello-world
```

If `hello-world` prints a welcome message, Docker pulled an image and ran
it as a container successfully.

## 3. Core commands

| Command | What it does |
|---|---|
| `docker images` | List images stored locally |
| `docker ps` | List *running* containers |
| `docker ps -a` | List all containers (including stopped) |
| `docker pull <image>` | Download an image from a registry (default: Docker Hub) |
| `docker run <image>` | Create + start a container from an image |
| `docker run -d <image>` | Run detached (in the background) |
| `docker run -p 8000:8000 <image>` | Map host port 8000 → container port 8000 |
| `docker exec -it <container> sh` | Open a shell inside a running container |
| `docker logs <container>` | View a container's stdout/stderr |
| `docker stop <container>` | Gracefully stop a running container |
| `docker rm <container>` | Delete a stopped container |
| `docker rmi <image>` | Delete an image |
| `docker build -t <name> .` | Build an image from a Dockerfile in the current directory |

Containers and images are referenced by name or ID — both work.

## 4. Try it: run an existing image

```bash
docker run -d -p 8080:80 --name my-nginx nginx
curl localhost:8080          # or open http://localhost:8080 in a browser
docker logs my-nginx
docker stop my-nginx
docker rm my-nginx
```

## 5. The Dockerfile

A `Dockerfile` is the recipe for building your own image. This repo
includes a minimal example in [`example/`](example/):

```dockerfile
FROM python:3.12-slim   # start from a base image

WORKDIR /app             # set the working directory inside the image
COPY app.py .            # copy your code in

EXPOSE 8000               # documents which port the app uses
CMD ["python", "app.py"] # default command when a container starts
```

Common instructions:

- `FROM` — base image to build on top of
- `WORKDIR` — sets the current directory for subsequent instructions
- `COPY` / `ADD` — copy files from your machine into the image
- `RUN` — execute a command *while building* the image (e.g. `pip install`)
- `ENV` — set environment variables
- `EXPOSE` — documents the port the container listens on (doesn't publish it)
- `CMD` — the default command run when a container starts

### Build and run the example

```bash
cd example
docker build -t docker-basics-demo .
docker run -d -p 8000:8000 --name demo docker-basics-demo
curl localhost:8000
docker stop demo && docker rm demo
```

## 6. Volumes (persisting data)

Containers are ephemeral — delete the container and its filesystem
changes are gone. Volumes let you persist or share data:

```bash
docker volume create my-data
docker run -v my-data:/data <image>       # named volume
docker run -v $(pwd):/app <image>          # bind mount (host directory)
```

## 7. Networking basics

By default, containers can reach the internet but are isolated from the
host and each other unless you connect them:

```bash
docker network create my-net
docker run --network my-net --name db postgres
docker run --network my-net --name web myapp   # 'web' can reach 'db' by name
```

`-p host:container` publishes a container port to the host, as used above.

## 8. Cleaning up

```bash
docker ps -a                 # see everything, including stopped containers
docker container prune       # remove all stopped containers
docker image prune           # remove dangling (untagged) images
docker system prune          # remove unused containers, networks, images
```

## 9. Docker Compose (multi-container apps)

For apps with multiple services (e.g. a web app + a database), Compose
lets you define them in one YAML file:

```yaml
# docker-compose.yml
services:
  web:
    build: .
    ports:
      - "8000:8000"
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: example
```

```bash
docker compose up      # build/start all services
docker compose down    # stop and remove them
```

## Next steps

- Modify `example/app.py`, rebuild the image, and re-run the container to
  see your change take effect.
- Try adding a second service (e.g. `redis`) and a `docker-compose.yml`
  to wire it up to the example app.
- Read up on multi-stage builds once you're comfortable — they keep
  production images small by separating build-time and run-time
  dependencies.
