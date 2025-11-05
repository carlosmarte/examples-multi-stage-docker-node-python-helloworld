.PHONY: build run stop clean help

IMAGE_NAME = multi-stage-app
CONTAINER_NAME = multi-stage-container

help:
	@echo "Available targets:"
	@echo "  build  - Build the Docker image"
	@echo "  run    - Run the Docker container"
	@echo "  stop   - Stop and remove the container"
	@echo "  clean  - Remove the Docker image"
	@echo "  help   - Show this help message"

build:
	@echo "Building Docker image..."
	docker build -t $(IMAGE_NAME) .

run:
	@echo "Running Docker container..."
	docker run -d --name $(CONTAINER_NAME) -p 3000:3000 $(IMAGE_NAME)
	@echo "Container started!"
	@echo "Gateway running at: http://localhost:3000"
	@echo "  - Node.js service: http://localhost:3000/app"
	@echo "  - Python service:  http://localhost:3000/llm"

stop:
	@echo "Stopping container..."
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true

clean: stop
	@echo "Removing Docker image..."
	docker rmi $(IMAGE_NAME) || true

logs:
	docker logs -f $(CONTAINER_NAME)
