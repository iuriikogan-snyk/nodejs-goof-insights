#!/usr/bin/env bash

# **BEFORE RUNNING THIS SCRIPT CHANGE THE VARS IN setenv.sh or ensure they are available in your environment**

set -ou pipefail

# Exit the script on any error, unset variable, or command failure in a pipeline.

# Record the Start time
start=$(date +%s)

# Deploy the snyk-connector

kubectl create ns snyk-monitor

kubectl create secret generic snyk-monitor -n snyk-monitor \
    --from-literal=dockercfg.json='{}' \
    --from-literal=integrationId="${SNYK_INTEGRATION_ID}" \
    --from-literal=serviceAccountApiToken="${SNYK_MONITOR_SA_TOKEN}"

helm repo add snyk-charts https://snyk.github.io/kubernetes-monitor --force-update

helm upgrade --install snyk-monitor snyk-charts/snyk-monitor \
             --namespace snyk-monitor \
             --set clusterName="dev"

kubectl patch deployment snyk-monitor --type=json -p='[{ "op": "remove", "path": "/spec/template/spec/affinity"}]' -n snyk-monitor

echo 'waiting for snyk-monitor pods to become ready....'
kubectl -n snyk-monitor wait --for=condition=ready pod -l "app.kubernetes.io/name=snyk-monitor" --timeout=120s

echo 'Deployed Snyk Monitor in: '$(( $(date +%s) - start ))"seconds"