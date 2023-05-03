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

KEY="tools/foundational/terraform.tfstate"
ACCOUNT?=reejig-development
REGION?=ap-southeast-2
ENV?=dev
export TF_VAR_aws_region=$(REGION)
export TF_VAR_account=$(ACCOUNT)
export TF_VAR_environment=$(ENV)
export TF_VAR_app_name=tools

.ONESHELL:
.SHELL := /bin/bash
.PHONY: apply destroy destroy-target plan-destroy plan plan-target prep
WORKSPACE="$(ACCOUNT)-$(REGION)"
BACKEND="backend/$(ACCOUNT).backend"
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

set-env:
	@if [ -z $(ACCOUNT) ]; then \
		echo "$(BOLD)$(RED)ACCOUNT was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ -z $(REGION) ]; then \
		echo "$(BOLD)$(RED)REGION was not set$(RESET)"; \
		ERROR=1; \
	 fi
	@if [ ! -z $${ERROR} ] && [ $${ERROR} -eq 1 ]; then \
		echo "$(BOLD)Example usage: \`CUSTOMERS=demo1 VERSION=489b31841932178fab77aaf980aa8c02ef443473 ACCOUNT=reejig-development REGION=ap-southeast-2 SITE=001 make plan\`$(RESET)"; \
		exit 1; \
	 fi

prep: set-env ## Prepare a new workspace (environment) if needed, configure the tfstate backend, update any modules, and switch to the workspace
	@echo "$(BOLD)Configuring the terraform backend$(RESET)"
	@rm ".terraform/terraform.tfstate"
	@rm ".terraform/environment"
	@terraform init \
		-force-copy \
		-input=false \
		-get=true \
		-upgrade=true \
		-reconfigure \
		-backend=true \
		-backend-config="$(BACKEND)" \
		-backend-config="key=$(KEY)" \
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

plan-destroy: prep ## Creates a destruction plan.
	@terraform plan \
		-input=false \
		-refresh=true \
		-destroy \
		-out=destroy.tfplan

apply: prep # no need to do init as we saved .terraform in CI from one plan step to apply another. We use tfplan as input
	@terraform apply \
		-input=false \
		-refresh=true \
		-lock=true \
		-input=false

ci-apply: prep # no need to do init as we saved .terraform in CI from one plan step to apply another. We use tfplan as input
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
