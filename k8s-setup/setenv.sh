t#!/usr/bin/env bash

set -eou pipefail

# Set the required vars here before running deploy.sh
# ensure you have the env vars listed here set
#
# export SNYK_CONNECTOR_SA_TOKEN=
# export SNYK_ORG_ID=
# export IMAGE_NAME=
#
# you can change the values here or have them available in your env prior to running the script 

# Function to check if a required variable is set
check_required_var() {
  local var_name=$1
  if [ -z "${!var_name:-}" ]; then
    echo "Error: Required environment variable $var_name is not set."
    exit 1
  fi
}

# Only export if not already set (optional variables)
export CLUSTER_NAME="${CLUSTER_NAME:="dev"}"

# Check if required variables are set, ask user to set them if missing
check_required_var "SNYK_CONNECTOR_SA_TOKEN"
check_required_var "SNYK_ORG_ID"
check_required_var "SNYK_TOKEN"
check_required_var "IMAGE_NAME"

# Export required variables (after check)

export SNYK_CONNECTOR_SA_TOKEN="${SNYK_CONNECTOR_SA_TOKEN}"
export SNYK_ORG_ID="${SNYK_ORG_ID}"
export IMAGE_NAME="${IMAGE_NAME}" # image name for deploy-demo.sh (you can use 'iuriikogan/nodejs-goof:linux-arm64' or your own)

# Uncomment next 2 lines if deploying monitor
# export SNYK_INTEGRATION_ID="${SNYK_INTEGRATION_ID:-}"
# export SNYK_MONITOR_SA_TOKEN="${SNYK_MONITOR_SA_TOKEN:-}"

# Notify user of any defaults applied (except password)
echo "CLUSTER_NAME is set to ${CLUSTER_NAME}"
echo "SNYK_MONITOR_SA_TOKEN is set"
echo "SNYK_CONNECTOR_SA_TOKEN is set"
echo "SNYK_ORG_ID is set to ${SNYK_ORG_ID}"
echo "IMAGE_NAME is set to ${IMAGE_NAME}"
