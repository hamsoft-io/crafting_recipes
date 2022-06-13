MAJOR?=0
MINOR?=1

VERSION=$(MAJOR).$(MINOR)

APP_NAME = "crafting-recipes"

# Our docker Hub account name
HUB_NAMESPACE = "hamsoft"

# location of Dockerfiles
DOCKER_FILE_DIR = "."
DOCKERFILE = "${DOCKER_FILE_DIR}/Dockerfile"

IMAGE_NAME = "${APP_NAME}"
CUR_DIR = $(shell echo "${PWD}")

#################################
# Installation
#################################

#################################
# Docker
#################################

.PHONY: clean-image
clean-image: version-check
@docker rmi ${HUB_NAMESPACE}/${IMAGE_NAME}:latest  || true
	@docker rmi ${HUB_NAMESPACE}/${IMAGE_NAME}:${VERSION}  || true

.PHONY: image
image: version-check
	@docker build -t ${HUB_NAMESPACE}/${IMAGE_NAME}:${VERSION} -f ./${DOCKERFILE} .
	@docker tag ${HUB_NAMESPACE}/${IMAGE_NAME}:${VERSION} ${HUB_NAMESPACE}/${IMAGE_NAME}:latest
	@echo 'Done.'
	@docker images --format '{{.Repository}}:{{.Tag}}\t\t Built: {{.CreatedSince}}\t\tSize: {{.Size}}' | grep ${IMAGE_NAME}:${VERSION}

.PHONY: run
run:
	@docker run ${HUB_NAMESPACE}/${IMAGE_NAME}:${VERSION}

.PHONY: push
push: clean-image image
	@docker push ${HUB_NAMESPACE}/${IMAGE_NAME}:${VERSION}
	@docker push ${HUB_NAMESPACE}/${IMAGE_NAME}:latest


#################################
# test targets
#################################

.PHONY: build
build: version-check
	@bundle install

.PHONY: test
test: build
	@ruby bin/rspec

.PHONY: lint
lint: build
	@ruby bin/rubocop lib
#################################
# Utilities
#################################

.PHONY: version-check
version-check:
	@echo "+ $@"
	if [ -z "${VERSION}" ]; then \
		echo "VERSION is not set" ; \
		false ; \
	else \
		echo "VERSION is ${VERSION}"; \
	fi
