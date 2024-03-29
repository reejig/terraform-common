# Copyright 2016 Philip G. Porada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.ONESHELL:
.SHELL := /bin/bash
.PHONY: apply destroy destroy-target plan-destroy plan plan-out plan-target prep

# Defaults
SITE?=001
ACCOUNT?=reejig-development
REGION?=ap-southeast-2
PACKAGE_VERSION?=snapshot
CONFIG_BRANCH?=refs/heads/main

WORKSPACE="$(ACCOUNT)-$(REGION)"
TF_BUCKET="$(ACCOUNT)-terraform-remote-state"
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

# Variables for Terraform
export TF_VAR_site_id=$(SITE)
export TF_VAR_account=$(ACCOUNT)
export TF_VAR_aws_region=$(REGION)
export TF_VAR_package_version=$(PACKAGE_VERSION)
export TF_VAR_config_branch=$(CONFIG_BRANCH)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

set-env:
	@if [ -z $(SITE) ]; then \
		echo "$(BOLD)$(RED)SITE was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(ACCOUNT) ]; then \
		echo "$(BOLD)$(RED)ACCOUNT was not set.$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(REGION) ]; then \
		echo "$(BOLD)$(RED)REGION was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		echo "$(BOLD)Example usage: \`ACCOUNT=reejig-development SITE=001 REGION=ap-southeast-2 remake plan\`$(RESET)"; \
		exit 1; \
	 fi
	@if [ ! -f stack.id ]; then \
    echo "$(BOLD)$(RED)Please create a stack.id file and provide a unique name for this stack$(RESET)"; \
		exit 1; \
	 fi

prep: set-env ## Prepare a new workspace (environment) if needed, configure the tfstate backend, update any modules, and switch to the workspace
	@echo "$(BOLD)Configuring the Terraform backend$(RESET)"
	@rm .terraform/terraform.tfstate
	@rm .terraform/environment
	@echo "$(YELLOW)Account/Workspace:        $(WORKSPACE)$(RESET)"
	@echo "$(YELLOW)Backend Config Bucket:    $(TF_BUCKET)$(RESET)"
	@echo "$(YELLOW)Stack Id:                 $$(cat stack.id)$(RESET)"

	@terraform init \
		-force-copy \
		-input=false \
		-get=true \
		-upgrade=true \
		-reconfigure \
		-backend=true \
	  -backend-config="backend.config" \
		-backend-config="key=$$(cat stack.id)/$(SITE)/$(CUSTOMER)/terraform.tfstate" \
		-backend-config="bucket=$(TF_BUCKET)" \
	  -backend-config="acl=private"
	@echo "$(BOLD)Switching to workspace $(WORKSPACE)$(RESET)"
	@terraform workspace select $(WORKSPACE) || terraform workspace new $(WORKSPACE)

refresh: prep ## Show what terraform thinks it will do
	@terraform refresh \
		-lock=true \
		-input=false

plan: prep ## Show what terraform thinks it will do
	@terraform plan \
		-lock=true \
		-input=false \
		-refresh=true

plan-out: prep ## Show what terraform thinks it will do
	@terraform plan \
		-lock=true \
		-input=false \
		-refresh=true \
		-out=tfplan

plan-target: prep ## Shows what a plan looks like for applying a specific resource
	@echo "$(YELLOW)$(BOLD)[INFO]   $(RESET)"; echo "Example to type for the following question: module.rds.aws_route53_record.rds-master"
	@read -p "PLAN target: " DATA && \
		terraform plan \
			-lock=true \
			-input=true \
			-refresh=true \
			-target=$$DATA \
			-out=tfplan

plan-destroy: prep ## Creates a destruction plan.
	@terraform plan \
		-input=false \
		-refresh=true \
		-destroy \
		-out=destroy.tfplan

apply: prep ## Have terraform do the things. This will cost money.
	@terraform apply \
		-lock=true \
		-input=false \
		-refresh=true

ci-apply: # no need to do init as we saved .terraform in CI from one plan step to apply another. We use tfplan as input
	@terraform apply \
		-input=false \
		-refresh=true \
		-lock=true \
		-auto-approve \
		-input=false \
		tfplan

output: prep ## Export the output values in a json file
	@terraform output -json > terraform_output.json

destroy: prep ## Destroy the things
	@terraform destroy \
		-lock=true \
		-input=false \
		-refresh=true

destroy-plan: prep ## Destroy the things
	@terraform plan -destroy \
		-lock=true \
		-input=false \
		-refresh=true

destroy-ci: prep ## Destroy the things without asking for confirmation
	@terraform apply -destroy \
		-input=false \
		-auto-approve

destroy-target: prep ## Destroy a specific resource. Caution though, this destroys chained resources.
	@echo "$(YELLOW)$(BOLD)[INFO] Specifically destroy a piece of Terraform data.$(RESET)"; echo "Example to type for the following question: module.rds.aws_route53_record.rds-master"
	@read -p "Destroy target: " DATA && \
		terraform destroy \
		-lock=true \
		-input=false \
		-refresh=true \
		-target=$$DATA \
		-out=destroy.tfplan

import: ## Import a resource
	@echo "$(YELLOW)$(BOLD)[INFO] Commencing import.$(RESET)";
	@terraform import $(TF_ADDR) $(RESOURCE_ID)

import-interactive: ## Import a resource interactively
	@echo "$(YELLOW)$(BOLD)[INFO] Commencing interactive import.$(RESET)"; echo "Example to type for the following question: module.rds.aws_route53_record.rds-master"
	@read -p "Terraform address: " TF_ADDR && \
	read -p "Resource identifier: " RESOURCE_ID && \
  terraform import $$TF_ADDR $$RESOURCE_ID