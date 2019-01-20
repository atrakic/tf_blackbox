SHELL := /bin/bash

.PHONY: help
help:
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
	TF_FLAGS = "-no-color"
	include $(shell git rev-parse --show-toplevel)/terraform-common-docker.mk
else
	include $(shell git rev-parse --show-toplevel)/terraform-common.mk
endif

.PHONY: clean
clean: ## Cleanup working directory from states and plugins
	@rm -rf .terraform terraform.tfstate terraform.tfstate.backup
