# Multi-Stage Docker: Node.js (Fastify) + Python (FastAPI)

A simple example demonstrating a multi-stage Docker build that runs both a Node.js Fastify server and a Python FastAPI server in a single container, managed by PM2.

## Overview

This project showcases how to:
- Build a multi-stage Dockerfile to optimize image size
- Run multiple services (Node.js and Python) in one container
- Use PM2 as a process manager for both services
- Manage Docker operations with a Makefile

## Project Structure

```
.
├── Dockerfile              # Multi-stage Docker build
├── Makefile               # Build and run commands
├── node_server.js         # Fastify gateway (port 3000)
├── package.json           # Node.js dependencies
├── ecosystem.config.js    # PM2 config for both services
└── python_app/
    ├── main.py           # FastAPI server (port 3001, internal)
    └── requirements.txt  # Python dependencies
```

## Prerequisites

- Docker installed
- Make utility (optional, but recommended)

## Quick Start

### Using Makefile (Recommended)

```bash
# Build the Docker image
make build

# Run the container
make run

# View logs
make logs

# Stop the container
make stop

# Clean up (remove container and image)
make clean
```

### Using Docker directly

```bash
# Build
docker build -t multi-stage-app .

# Run
docker run -d --name multi-stage-container -p 3000:3000 multi-stage-app

# Logs
docker logs -f multi-stage-container

# Stop
docker stop multi-stage-container && docker rm multi-stage-container
```

## API Endpoints

The application uses **path-based routing** with a single entry point on port 3000:

- **Node.js service** (`/app`): http://localhost:3000/app
  ```json
  {"message": "Hello World from Fastify (Node.js)!"}
  ```

- **Python service** (`/llm`): http://localhost:3000/llm
  ```json
  {"message": "Hello World from FastAPI (Python)!"}
  ```

### Architecture
- Node.js (Fastify) acts as the **API gateway** on port 3000
- Python (FastAPI) runs internally on port 3001
- Requests to `/llm/*` are automatically proxied to the Python service
- Requests to `/app` are handled directly by the Node.js service

## How It Works

### Multi-Stage Build

The Dockerfile uses three stages:

1. **node-builder**: Builds Node.js dependencies
2. **python-builder**: Installs Python dependencies
3. **runtime**: Final lightweight image that copies from both builders

This approach keeps the final image small by excluding build tools and intermediate files.

### Process Management

PM2 manages both services in the container:
- Runs both Node.js and Python processes
- Auto-restarts on failure
- Forwards logs to Docker
- Handles graceful shutdown

## Technologies

- **Node.js**: Runtime for Fastify server
- **Fastify**: Fast and low overhead web framework
- **Python**: Runtime for FastAPI server
- **FastAPI**: Modern, fast Python web framework
- **PM2**: Production process manager
- **Docker**: Container platform
- **Debian Bookworm**: Base image for runtime