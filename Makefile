all: validate 
	@./run.sh

fmt:
	terraform fmt *.tf

validate:
	terraform validate -check-variables=false .

