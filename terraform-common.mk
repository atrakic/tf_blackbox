SHELL := /bin/bash

TERRAFORM := $(shell git rev-parse --show-toplevel)/terraform
TMP ?= /tmp
OS ?= $(shell uname -s | tr '[:upper:]' '[:lower:]')
TERRAFORM_VERSION ?= 0.11.10
TERRAFORM_URL ?= https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_$(OS)_amd64.zip

.PHONY: install
install: ## Install terraform
	@[ -x $(TERRAFORM) ] || ( \
		echo "Installing terraform $(TERRAFORM_VERSION) ($(OS)) from $(TERRAFORM_URL)" && \
		curl '-#' -fL -o $(TMP)/terraform.zip $(TERRAFORM_URL) && \
		unzip -q -d $(TMP)/ $(TMP)/terraform.zip && \
		mv $(TMP)/terraform $(TERRAFORM) && \
		rm -f $(TMP)/terraform.zip \
		)
	which $(TERRAFORM)
	$(TERRAFORM) version

.PHONY: apply
apply: init ## Builds or changes infrastructure
	@$(TERRAFORM) apply -auto-approve

.PHONY: graph
graph: apply ## Create a visual graph of Terraform resources
	@$(TERRAFORM) graph

.PHONY: output
output: apply ## Read an output from a state file
	@$(TERRAFORM) output

.PHONY: version
version: install ## Prints the Terraform version
	@$(TERRAFORM) version

.PHONY: init
init: install ## Initilise empty terraform env
	@$(TERRAFORM) init -input=false >/dev/null

.PHONY: validate
validate: ## Validates the Terraform files
	@$(TERRAFORM) validate

.PHONY: show
show: apply ## Inspect Terraform state or plan
	@$(TERRAFORM) show

.PHONY: fmt
fmt: ## Rewrites config files to canonical format
	@$(TERRAFORM) fmt

.PHONY: clean
clean: ## Clean up
	@rm -rf *.tfstate *.tfstate.backup $(TERRAFORM) .terraform/* >/dev/null
