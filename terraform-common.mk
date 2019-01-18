SHELL := /bin/bash
DOCKER_IMAGE := hashicorp/terraform:light

.PHONY: install
install: ## Pull latest images
	@docker image inspect $(DOCKER_IMAGE) >/dev/null 2>&1 || docker pull $(DOCKER_IMAGE)

.PHONY: init
init: install ## Initilise empty terraform env
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		init -input=false >/dev/null

.PHONY: apply
apply: init ## Builds or changes infrastructure
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		apply -auto-approve

.PHONY: graph
graph: apply ## Create a visual graph of Terraform resources
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		graph

.PHONY: state-pull
state-pull: ## Pull the state from its location and output it to stdout
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		state pull

.PHONY: state-list
state-list: ## List resources in the Terraform state
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		state list

.PHONY: state-show
state-show: ## Shows the attributes of a resource in the Terraform state
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		state show

.PHONY: output
output: apply ## Read an output from a state file
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		output

.PHONY: version
version: ## Prints the Terraform version
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		version

.PHONY: validate
validate: ## Validates the Terraform files
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		validate -check-variables=false .

.PHONY: show
show: apply ## Inspect Terraform state or plan
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		show

.PHONY: fmt
fmt: ## Rewrites config files to canonical format
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		fmt

.PHONY: clean
clean: ## Destroy Terraform-managed infrastructure
	@docker run -it --rm -w $$PWD -v $$PWD:$$PWD $(DOCKER_IMAGE) \
		destroy -auto-approve
