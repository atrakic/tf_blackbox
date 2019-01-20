SHELL := /bin/bash
DOCKER_IMAGE := hashicorp/terraform:light

.PHONY: install
install: ## Pull latest images
	@docker pull $(DOCKER_IMAGE) >/dev/null 2>&1
#	@docker image inspect $(DOCKER_IMAGE) >/dev/null 2>&1 || docker pull $(DOCKER_IMAGE)

.PHONY: init
init: install ## Initilise empty terraform env
	@echo "+ $@"
	@docker run -i $(DOCKER_FLAGS) --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		init $(TF_FLAGS) -input=false >/dev/null

.PHONY: plan
plan: init ## Plans changes infrastructure
	@echo "+ $@"
	docker run -i $(DOCKER_FLAGS) --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		plan $(TF_FLAGS)

.PHONY: apply
apply: init ## Builds or changes infrastructure
	@echo "+ $@"
	docker run -i $(DOCKER_FLAGS) --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		apply $(TF_FLAGS) -auto-approve

.PHONY: graph
graph: apply ## Create a visual graph of Terraform resources
	@echo "+ $@"
	@docker run -i $(DOCKER_FLAGS)  --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		graph

.PHONY: state-pull
state-pull: ## Pull the state from its location and output it to stdout
	@echo "+ $@"
	@docker run -i $(DOCKER_FLAGS) --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		state pull

.PHONY: state-list
state-list: ## List resources in the Terraform state
	@echo "+ $@"
	@docker run -i $(DOCKER_FLAGS) --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		state list

.PHONY: state-show
state-show: ## Shows the attributes of a resource in the Terraform state
	@echo "+ $@"
	@docker run -i $(DOCKER_FLAGS) --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		state show

.PHONY: output
output: apply ## Read an output from a state file
	@echo "+ $@"
	@docker run --rm -i $(DOCKER_FLAGS) --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		output

.PHONY: version
version: ## Prints the Terraform version
	@echo "+ $@"
	docker run --rm -i $(DOCKER_FLAGS) --network host -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		version 

.PHONY: validate
validate: ## Validates the Terraform files
	@echo "+ $@"
	@docker run --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		validate -check-variables=false . && echo "[OK] terraform validated"

.PHONY: show
show: apply ## Inspect Terraform state or plan
	@echo "+ $@"
	@docker run --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		show

.PHONY: fmt
fmt: ## Rewrites config files to canonical format
	@echo "+ $@"
	@docker run --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		fmt

.PHONY: destroy
destroy: ## Destroy Terraform-managed infrastructure
	@echo "+ $@"
	@docker run --network host --rm -w /app -v $$PWD:/app $(DOCKER_IMAGE) \
		destroy -auto-approve
