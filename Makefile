.DEFAULT_GOAL := run-all

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  fmt            Format all Terraform files"
	@echo "  docs 					Generate Terraform documentation"
	@echo "  run-all        Run all above commands"
	@echo

fmt:
	terraform fmt --recursive

docs:
	terraform-docs markdown table --hide header --recursive --recursive-path ./modules/ \
	--output-file README.md --output-mode inject --sort-by required  --hide-empty --indent 2 ./

run-all:
	make fmt
	make terraform-docs
