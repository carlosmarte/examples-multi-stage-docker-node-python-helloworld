############################################
# Docker-in-Docker Orchestrator Container
############################################
FROM docker:27-dind

# Install docker-compose plugin and other utilities
RUN apk add --no-cache \
    docker-cli-compose \
    bash \
    curl \
    git

# Set working directory
WORKDIR /orchestrator

# Copy docker-compose configuration and service dockerfiles
COPY docker-compose.yml .
COPY node.dockerfile .
COPY python.dockerfile .
COPY node_server.js .
COPY package.json .
COPY package-lock.json* .
COPY python_app ./python_app

# Create startup script that starts dockerd and runs compose
RUN cat > /start.sh << 'EOF'
#!/bin/bash
set -e

echo "Starting Docker daemon..."
dockerd-entrypoint.sh &

# Wait for Docker daemon to be ready
echo "Waiting for Docker daemon to be ready..."
while ! docker info >/dev/null 2>&1; do
    sleep 1
done

echo "Docker daemon is ready"
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker compose version)"

# Build and start services with docker-compose
cd /orchestrator
echo "Starting services with docker-compose..."
docker compose up --build

EOF

RUN chmod +x /start.sh

# Expose port 8080 for the application
EXPOSE 8080

CMD ["/start.sh"]
