#!/bin/bash

sudo apt-get install curl jq

# Install dotnet for pandas and AML pipelines
# NotImplementedError: Linux distribution ubuntu 20.04 does not have automatic support.
# .NET Core 2.1 can still be used via dotnetcore2 if the required dependencies are installed.
# Visit https://aka.ms/dotnet-install-linux for Linux distro specific .NET Core install instructions.
# Follow your distro specific instructions to install `dotnet-runtime-*` and replace `*` with `2.1`.
# 
# Partial error trace
# File "/opt/hostedtoolcache/Python/3.8.12/x64/lib/python3.8/site-packages/amlops/mlopipelines.py", line 47, in create_load_output
#    load_output_filedataset = OutputFileDatasetConfig(name='load_output').read_delimited_files(
#  File "/opt/hostedtoolcache/Python/3.8.12/x64/lib/python3.8/site-packages/azureml/data/_loggerfactory.py", line 132, in wrapper
#    return func(*args, **kwargs)
#  File "/opt/hostedtoolcache/Python/3.8.12/x64/lib/python3.8/site-packages/azureml/data/output_dataset_config.py", line 179, in read_delimited_files
#    dataflow = dprep.Dataflow(self._engine_api)
# Steps to integrate current repository from Azure ML Notebooks


#
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update; \
sudo apt-get install -y apt-transport-https && \
sudo apt-get update && \
sudo apt-get install -y aspnetcore-runtime-2.1

# Required for authentication
pip install azure-cli-core
pip install azureml-core
pip install azure-cli-ml


# Install some python packages requires by the architecture
python -m pip install termcolor azureml-sdk
python -m pip install -U pip setuptools wheel
python -m pip install ruamel.yaml

# Install MLOps framework
pip install amlops==1.1.5
