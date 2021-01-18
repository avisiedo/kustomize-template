include Makefile.variables


ifneq (,$(shell command -v podman))
DOCKER?=podman
else
ifneq (,$(shell command -v docker))
DOCKER?=docker
else
DOCKER?=
endif
endif


.PHONY: check-docker
ifeq (,$(DOCKER))
check-docker:
	@echo "ERROR:No docker nor podman found in the system" && exit 1
else
check-docker:
endif



.PHONY: help
help:
	@cat .help.txt


.PHONY: container-build
container-build: check-docker
	$(DOCKER) build -t $(CONTAINER_IMAGE) -f Dockerfile .


.PHONY: container-push
container-push: check-docker
	$(DOCKER) push $(CONTAINER_IMAGE)


.PHONY: container-image-save
container-image-save: check-docker
	@[ ! -e container-image.tar ] || rm -vf container-image.tar
	$(DOCKER) image save $(CONTAINER_IMAGE) -o container-image.tar


.PHONY: container-run
container-run: check-docker
	$(DOCKER) run $(CONTAINER_RUN_ARGS) $(CONTAINER_IMAGE)


.PHONY: create
create:
	kustomize build --reorder none config/ | kubectl create -f -


.PHONY: delete
delete:
	kustomize build --reorder none config/ | kubectl delete -f -


.PHONY: lint
lint: check-docker container-image-save
	$(DOCKER) run --rm -v "$(PWD):/workspace:ro" -w "/workspace" -e "DOCKER_CONTENT_TRUST=1" goodwithtech/dockle --input container-image.tar
	$(DOCKER) run --rm -i -v "$(PWD):/workspace:ro" -w "/workspace" --entrypoint "" hadolint/hadolint hadolint Dockerfile
	kustomize build --reorder none config/ | $(DOCKER) run --rm -t -v "$(PWD):/workspace" bridgecrew/checkov -d /workspace


.PHONY: update
update: check-docker
	$(DOCKER) pull hadolint/hadolint
	$(DOCKER) pull bridgecrew/checkov
	$(DOCKER) pull goodwithtech/dockle

.PHONY: manifest-build
manifest-build:
	@kustomize build config/
