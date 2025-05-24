# Name of the image
IMAGE_NAME=chatbot

# Tag for the image
TAG=latest

# Dockerfile location (if not in the same directory)
DOCKERFILE_PATH=.

# Kind Cluster
KINDCLUSTER=woohoosvcs

ifeq ($(shell command -v podman 2> /dev/null),)
	CMD=docker
else
	CMD=podman
endif

.PHONY: all
all: build-image

.PHONY: build-image
build-image:
	$(CMD) build -t $(IMAGE_NAME):$(TAG) $(DOCKERFILE_PATH)

.PHONY: push
push:
	kubectl apply -f kube_manifest.yaml
	$(CMD) save -o $(IMAGE_NAME).tar $(IMAGE_NAME)
	kind load image-archive $(IMAGE_NAME).tar --name $(KINDCLUSTER)
	rm $(IMAGE_NAME).tar
	kubectl rollout restart deployment/$(IMAGE_NAME)
	sleep 15
	kubectl get pods | sed '1p;/$(IMAGE_NAME)/!d'

.PHONY: run
run:
	go run .
