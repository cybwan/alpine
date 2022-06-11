#!make

CTR_REGISTRY = cybwan
DOCKER_BUILDX_OUTPUT ?= type=registry

default: docker-build-alpine-jdk

.PHONY: docker-build-alpine-base
docker-build-alpine-base: DOCKER_BUILDX_PLATFORM=linux/amd64,linux/arm64
docker-build-alpine-base:
	docker buildx build --builder osm --platform=$(DOCKER_BUILDX_PLATFORM) -o $(DOCKER_BUILDX_OUTPUT) -t $(CTR_REGISTRY)/alpine-base:latest -f dockerfiles/Dockerfile.alpine-base .

.PHONY: docker-build-alpine-jdk
docker-build-alpine-jdk: DOCKER_BUILDX_PLATFORM=linux/amd64,linux/arm64
docker-build-alpine-jdk:
	docker buildx build --builder osm --platform=$(DOCKER_BUILDX_PLATFORM) -o $(DOCKER_BUILDX_OUTPUT) -t $(CTR_REGISTRY)/alpine-jdk:latest -f dockerfiles/Dockerfile.alpine-jdk .