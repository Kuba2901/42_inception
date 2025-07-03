LOGIN = jnenczak
SRCS = srcs
DOCKER_COMPOSE_FILE = $(SRCS)/docker-compose.yml

all: up

build:
	@echo "Building docker images..."
	docker compose -f $(DOCKER_COMPOSE_FILE) build

up: build
	@echo "Starting services..."
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	@echo "Stopping services..."
	docker compose -f $(DOCKER_COMPOSE_FILE) down

clean: down
	@echo "Removing Docker images and volumes..."
	docker system prune -f --volumes
	docker rmi -f $(shell docker images -q --filter "dangling=true")

re: clean all

.PHONY: all build up down clean re 
