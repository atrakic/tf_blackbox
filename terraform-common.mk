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

.PHONY: apply
apply: init ## Builds or changes infrastructure
	@$(TERRAFORM) apply -auto-approve

.PHONY: graph
graph: apply ## Create a visual graph of Terraform resources
	@$(TERRAFORM) graph

.PHONY: state-pull
state-pull: ## Pull the state from its location and output it to stdout
	@$(TERRAFORM) state pull

.PHONY: state-list
state-list: ## List resources in the Terraform state
	@$(TERRAFORM) state list

.PHONY: state-show
state-show: ## Shows the attributes of a resource in the Terraform state
	@$(TERRAFORM) state show

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
validate: init ## Validates the Terraform files
	@$(TERRAFORM) validate -check-variables=false . && echo "[OK] terraform validated"

.PHONY: show
show: apply ## Inspect Terraform state or plan
	@$(TERRAFORM) show

.PHONY: fmt
fmt: ## Rewrites config files to canonical format
	@$(TERRAFORM) fmt

.PHONY: destroy
destroy: ## Destroy Terraform-managed infrastructure
	@$(TERRAFORM) destroy -auto-approve
