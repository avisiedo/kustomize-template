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


.PHONY: create
create:
	kustomize build | kubectl create -f -


.PHONY: delete
delete:
	kustomize build | kubectl delete -f -


.PHONY: lint
lint: check-docker
	kustomize build config/ | $(DOCKER) run -t -v "$(PWD):/workspace" bridgecrew/checkov -d /workspace

