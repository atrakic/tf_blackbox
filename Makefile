SHELL := /bin/bash

.PHONY: help
help:
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

include $(shell git rev-parse --show-toplevel)/terraform-common.mk
include $(shell git rev-parse --show-toplevel)/terraform-aws-common.mk
