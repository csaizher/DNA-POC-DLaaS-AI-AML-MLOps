# set base image (host OS) 
FROM mcr.microsoft.com/azureml/base:intelmpi2018.3-ubuntu16.04
 

### Custom additions for specific training ###
# Problem with pip version https://medium.com/analytics-vidhya/fix-modulenotfounderror-no-module-named-ruamel-when-importing-azureml-core-7264d1860612
RUN pip install --upgrade pip==22.2.2
RUN pip install azureml-mlflow mlflow scikit-learn==0.24.2 pandas tqdm matplotlib
RUN pip install azureml-dataset-runtime
RUN pip install azureml-core

# entrypoint azureml.scriptrun = azureml.core.script_run:ScriptRun._from_run_dto 
# with exception (cryptography 37.0.1 (/opt/miniconda/lib/python3.7/site-packages), 
# Requirement.parse('cryptography!=1.9,!=2.0.*,!=2.1.*,!=2.2.*,<37.0.0'))
# RUN pip install "cryptography>=2.3,<36"
# Also, taking into account this message: ERROR: paramiko 2.10.4 has requirement cryptography>=2.5, but you'll have cryptography 2.3.1 which is incompatible.
RUN pip install pyOpenSSL==22.0.0
RUN pip install "cryptography>=2.8,<38"

RUN pip install --upgrade pip
#RUN pip install keyring artifacts-keyring
RUN pip install artifacts-keyring==0.2.9
# Setup pip repository
#RUN pip config set global.index 'https://pkgs.dev.azure.com/DNA-POC-DLaas/DNA-POC-DLaaS/_packaging/ml_architecture/pypi/'
RUN pip config set global.index-url 'https://pkgs.dev.azure.com/DNA-POC-DLaas/DNA-POC-DLaaS/_packaging/ml_architecture/pypi/simple/'
# Also include trusted host SSL certificate for the repository
#RUN pip config set global.trusted-host 'pkgs.dev.azure.com'

# Install mlops package
RUN pip install amlops==1.0.9