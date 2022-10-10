#!/bin/bash

# Setups Azure ML CLI used by the devops scripts. Azure CLI is a prerequisite, so
# Azure CLI should be installed before Azure ML CLI
# If devops VM is used, this software is already installed
# @see (https://docs.microsoft.com/es-es/azure/devops/pipelines/agents/hosted?view=azure-devops&tabs=yaml)
# @see (https://github.com/actions/virtual-environments/blob/main/images/linux/Ubuntu2004-README.md)
# References for Azure ML CLI installation
# Reference: https://docs.microsoft.com/es-es/azure/machine-learning/how-to-configure-cli
# Reference: https://docs.microsoft.com/es-es/cli/azure/install-azure-cli


# Remove previous ML CLI
az version
az extension remove -n azure-cli-ml
az extension remove -n ml

# Add ML CLI
az extension add -n ml -y
# Test version
az ml -h

az extension update -n ml