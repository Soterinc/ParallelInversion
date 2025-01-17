
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
	@echo "Building Docker image ${IMAGE_NAME}:${TAG}..."
	docker build -t ${IMAGE_NAME}:${TAG} .

run:
	@echo "Running container ${CONTAINER_NAME} with GPU access from image ${IMAGE_NAME}:${TAG}..."
	docker run --gpus all --name ${CONTAINER_NAME} \
	-v $(PWD)/../../data:/app/data/nerf \
	-v $(PWD)/scripts:/app/scripts \
	-it -d ${IMAGE_NAME}:${TAG} /bin/bash

stop:
	@echo "Stopping container ${CONTAINER_NAME}..."
	docker stop ${CONTAINER_NAME}
	@echo "Removing container ${CONTAINER_NAME}..."
	docker rm ${CONTAINER_NAME}

push:
	docker tag ${IMAGE_NAME}:${TAG} ghcr.io/soterinc/${IMAGE_NAME}:${TAG}
	docker push ghcr.io/soterinc/${IMAGE_NAME}:${TAG}

pull:
	docker pull ghcr.io/soterinc/${IMAGE_NAME}:${TAG}
	docker tag ghcr.io/soterinc/${IMAGE_NAME}:${TAG} ${IMAGE_NAME}:${TAG}

enter:
	docker exec -it ${CONTAINER_NAME} bash

clean:
	@echo "Removing Docker image ${IMAGE_NAME}:${TAG}..."
	docker rmi ${IMAGE_NAME}:${TAG}

.PHONY: all build run stop clean push pull enter
