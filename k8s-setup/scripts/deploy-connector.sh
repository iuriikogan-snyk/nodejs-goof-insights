#!/usr/bin/env bash

# **BEFORE RUNNING THIS SCRIPT CHANGE THE VARS IN setenv.sh or ensure they are available in your environment**

# Exit the script on any unset variable
set -ou pipefail

# Record the start time
start=$(date +%s)

# Deploy the snyk-connector

kubectl create ns snyk-connector

kubectl create secret generic snyk-connector-secret -n snyk-connector --from-literal=snykServiceAccountToken="$SNYK_CONNECTOR_SA_TOKEN"

helm repo add kubernetes-scanner https://snyk.github.io/kubernetes-scanner
helm repo update

helm upgrade --install snyk-connector -n snyk-connector \
	--set "secretName=snyk-connector-secret" \
	--set "config.clusterName=dev" \
	--set "config.routes[0].organizationID=${SNYK_ORG_ID}" \
	--set "config.routes[0].clusterScopedResources=true" \
	--set "config.routes[0].namespaces[0]=*"  \
	kubernetes-scanner/kubernetes-scanner

echo 'waiting for kubernetes-connector pods to become ready....'
kubectl -n snyk-connector wait --for=condition=ready pod -l app.kubernetes.io/name=kubernetes-scanner --timeout=90s

echo 'Deployed Snyk Connector in: '$(( $(date +%s) - start )) "seconds"
