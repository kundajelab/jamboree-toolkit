REGISTRY?=kellislab
IMAGE_NAME?=neurogen-spring22
VERSION=package_envs

PARENT_VERSION?=rstudio_base
PARENT_DOCKER?=${REGISTRY}/${IMAGE_NAME}:${PARENT_VERSION}

all: build

.PHONY: build
build:
	DOCKER_BUILDKIT=1 docker build \
	--tag ${IMAGE_NAME}:${VERSION} \
	--tag ${REGISTRY}/${IMAGE_NAME}:${VERSION} \
	--build-arg PARENT_DOCKER=${PARENT_DOCKER} \
	--build-arg BUILDKIT_INLINE_CACHE=1 \
	--cache-from ${REGISTRY}/${IMAGE_NAME}:${VERSION} \
	  .

.PHONY: build-no-cache
build-no-cache:
	DOCKER_BUILDKIT=1 docker build \
	--tag ${IMAGE_NAME}:${VERSION} \
	--tag ${REGISTRY}/${IMAGE_NAME}:${VERSION} \
	--build-arg PARENT_DOCKER=${PARENT_DOCKER} \
	.

.PHONY: test
test:
	docker run --rm -it -p 8888:8888 ${REGISTRY}/${IMAGE_NAME}:${VERSION}

.PHONY: test_bash
test_bash:
	docker run --rm -it -p 8888:8888 ${REGISTRY}/${IMAGE_NAME}:${VERSION} bash

.PHONY: push
push:
	docker push ${REGISTRY}/${IMAGE_NAME}:${VERSION}
