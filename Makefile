all: validate 
	@./run.sh

apply:
	terraform apply -input=false -no-color

fmt:
	terraform fmt *.tf

validate:
	terraform validate -check-variables=false .

