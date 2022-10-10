#!/bin/bash
# Ref: https://dev.azure.com/reinhardseifert/_git/DatabricksDevOps?path=%2Fpipelines%2Fbuild-cluster.yml
# dapi6c34d4d16daa0f75b783a51c8057046c

# Base script variables
DEBUG=0
BASE_DIR=$(dirname)
BASE_ABSOLUTE_DIR="$( cd "$BASE_DIR" && pwd )"
ROOT_LOCAL_DIR="$BASE_ABSOLUTE_DIR"

echo "ROOT LOCAL DIR: ${ROOT_LOCAL_DIR}"
# Python binary
export PYTHON_BIN="python3"
[[ $(whereis -b python3 | awk -F ":" '{print $2}') == "" ]] &&  export PYTHON_BIN="python"

# Received arguments
CMD=$1

# Local CICD workspace folder (downloaded from GIT) where notebooks are located
export WORKSPACE_LOCAL_DIR="$ROOT_LOCAL_DIR/workspace"
# Local CICD configuration folder (downloaded from GIT) where configuration files are located
export CONFIG_LOCAL_DIR="$ROOT_LOCAL_DIR/pipelines/config"
# Scripts directory
export SCRIPTS_LOCAL_DIR="$ROOT_LOCAL_DIR/pipelines/scripts"
# Docker root folder
export DOCKER_LOCAL_DIR="$ROOT_LOCAL_DIR/docker"

case  "$CMD"  in
    "test")
	    SUBSCRIPTION=${2}
        RESOURCE_GROUP=${3}
        WORKSPACE_NAME=${4}

	    python3 -m amlops.cicd.entrypoint test-aml-connection -s "${SUBSCRIPTION}" -g "${RESOURCE_GROUP}" -w "${WORKSPACE_NAME}"
	    ;;

    "train")

        SUBSCRIPTION=${2}
        RESOURCE_GROUP=${3}
        WORKSPACE_NAME=${4}
        ENVIRONMENT_NAME=${5}
        DOCKERFILE=${6}
        EXPERIMENT_NAME=${7}
        
        # Resolve Dockerfile and Docker root content folder
        DOCKER_TRAINING_LOCAL_DIR="$DOCKER_LOCAL_DIR/training"
        DOCKERFILE="$DOCKER_TRAINING_LOCAL_DIR/Dockerfile"
        DOCKER_SOURCE_FOLDER="$DOCKER_TRAINING_LOCAL_DIR"

        # Check if model configuration via file exists
        if [ -f "$CONFIG_LOCAL_DIR/training/training.yml" ]
        then
            echo "Fichero de configuracion existe, se pasa como parametro"
            MODEL_OPTIONS=${MODEL_OPTIONS}" -tc ""$CONFIG_LOCAL_DIR/training/training.yml"""
        else
            echo "Model configuracion file not exsits ""$CONFIG_LOCAL_DIR/training/training.yml"
        fi
        
        # Check for hyperparameters configuration if exists
        HYPERPARAMETER_CONFIG_FILE="$CONFIG_LOCAL_DIR/training/hyperparameters.yml"
        HYPERPARAMETER_OPTIONS=""
        if [ -f "$HYPERPARAMETER_CONFIG_FILE" ]
        then
            echo "Fichero de configuracion existe de hiperparametros, se pasa como parametro"
            HYPERPARAMETER_OPTIONS=${HYPERPARAMETER_OPTIONS}" -hc ""$HYPERPARAMETER_CONFIG_FILE"""
        else
            echo "Model configuracion file not exsits ""$HYPERPARAMETER_CONFIG_FILE"
        fi

        echo "Launching training..."
        #echo python3 -m amlops.cicd.entrypoint train-model -s "${SUBSCRIPTION}" -g "${RESOURCE_GROUP}" -w "${WORKSPACE_NAME}" -en "${ENVIRONMENT_NAME}" -d  "${DOCKERFILE}" -ds "${DOCKER_SOURCE_FOLDER}" -e "${EXPERIMENT_NAME}" ${MODEL_OPTIONS} ${HYPERPARAMETER_OPTIONS}
        python3 -m amlops.cicd.entrypoint train-model -s "${SUBSCRIPTION}" -g "${RESOURCE_GROUP}" -w "${WORKSPACE_NAME}" -en "${ENVIRONMENT_NAME}" -d  "${DOCKERFILE}" -ds "${DOCKER_SOURCE_FOLDER}" -e "${EXPERIMENT_NAME}" ${MODEL_OPTIONS} ${HYPERPARAMETER_OPTIONS}
        ;;

    "deploy-bath")

        SUBSCRIPTION=${2}
        RESOURCE_GROUP=${3}
        WORKSPACE_NAME=${4}
        ARTIFACTS_FOLDER=${5}

        # Resolve Dockerfile and Docker root content folder
        DOCKER_CONSUMING_LOCAL_DIR="$DOCKER_LOCAL_DIR/consuming"
        DOCKERFILE="$DOCKER_CONSUMING_LOCAL_DIR/Dockerfile"
        DOCKER_SOURCE_FOLDER=$DOCKER_CONSUMING_LOCAL_DIR
        INFERENCE_CONFIGURATION_FILE="$CONFIG_LOCAL_DIR/consuming/inference.yml"

        INFERENCE_OPTIONS=""

        # Check if model configuration via file exists
        if [ -f $INFERENCE_CONFIGURATION_FILE ]
        then
            INFERENCE_OPTIONS=${INFERENCE_OPTIONS}" -ic ""$CONFIG_LOCAL_DIR/consuming/inference.yml"""
        fi

        echo "Launching inference publication..."
        echo "python3" "$SCRIPTS_LOCAL_DIR/azureml_utils.py" deploy-model-batch -s "${SUBSCRIPTION}" -g "${RESOURCE_GROUP}" -w "${WORKSPACE_NAME}" -en "${ENVIRONMENT_NAME}" -d  "${DOCKERFILE}" -ds "${DOCKER_SOURCE_FOLDER}" ${INFERENCE_OPTIONS} -af "${ARTIFACTS_FOLDER}"
        echo "$ARTIFACTS_FOLDER"
        python3 -m amlops.cicd.entrypoint deploy-model-batch -s "${SUBSCRIPTION}" -g "${RESOURCE_GROUP}" -w "${WORKSPACE_NAME}" -en "${ENVIRONMENT_NAME}" -d  "${DOCKERFILE}" -ds "${DOCKER_SOURCE_FOLDER}" ${INFERENCE_OPTIONS} -af "${ARTIFACTS_FOLDER}"
        ;;

    *)              
esac 

exit 0
