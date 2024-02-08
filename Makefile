
# Makefile to build and run a Docker container with CUDA support

# Define variables
IMAGE_NAME=pinerf
TAG=latest
CONTAINER_NAME=pinerf

# Default target executed when no arguments are given to make
all: build

update:
	git submodule update --init --recursive

build: update
	@echo "Building Docker image $(IMAGE_NAME):$(TAG)..."
	docker build -t $(IMAGE_NAME):$(TAG) .

run:
	@echo "Running container $(CONTAINER_NAME) with GPU access from image $(IMAGE_NAME):$(TAG)..."
	docker run --gpus all --name $(CONTAINER_NAME) -v $(PWD)/../../data:/app/data/nerf \
	-it -d $(IMAGE_NAME):$(TAG) /bin/bash

stop:
	@echo "Stopping container $(CONTAINER_NAME)..."
	docker stop $(CONTAINER_NAME)
	@echo "Removing container $(CONTAINER_NAME)..."
	docker rm $(CONTAINER_NAME)

clean:
	@echo "Removing Docker image $(IMAGE_NAME):$(TAG)..."
	docker rmi $(IMAGE_NAME):$(TAG)

.PHONY: all build run stop clean
