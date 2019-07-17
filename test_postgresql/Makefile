## Initialize terraform remote state
init: create-db
	[ -f .terraform/terraform.tfstate ] || terraform $@

## Clean up the project
clean: clean-db
	rm -rf .terraform *.tfstate*

## Pass arguments through to terraform which require remote state
apply console destroy graph plan output providers show: init
	@terraform $@

## Pass arguments through to terraform which do not require remote state
get fmt version:
	@terraform $@

## For advanced state management
state-list:
	@terraform state list

validate:
	@terraform $@ -check-variables=false . && echo "[OK] terraform validated"

## https://hub.docker.com/_/postgres
create-db clean-db adminer pgexercises pg_stat_activity pg_settings psql pg_dump pg_dumpall: create-db
	@./postgres.sh $@
