#!/usr/bin/env bash

# **BEFORE RUNNING THIS SCRIPT CHANGE THE VARS IN setenv.sh or ensure they are available in your environment**

# Exit the script on any error, unset variable, or command failure in a pipeline.
set -ou pipefail

# Record the start time
start=$(date +%s)
# Detect the OS
OS=$(uname)

if [[ "$OS" = "Darwin" ]]; then
    echo "Deploying Kind cluster with calico CNI and nginx ingress"
    kind create cluster --name "${CLUSTER_NAME:=dev}" --config ./kind/kind-ingress-arm64.yaml

elif [[ "$OS" = "Linux" ]]; then
    echo "Deploying Kind cluster with calico CNI and nginx ingress"
    kind create cluster --name "${CLUSTER_NAME:=dev}" --config ./kind/kind-ingress-amd64.yaml

else
    echo "Unsupported OS"
fi


## deploy the Calico CNI

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/calico.yaml

echo 'waiting for calico pods to become ready....' 

kubectl wait --for=condition=ready pod -l k8s-app=calico-node -A --timeout=90s

## Deploy NGINX Ingress Controller
if [[ $OS == "Darwin" ]]; then
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml -n ingress-nginx
elif [[ $OS == "Linux" ]]; then
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml -n ingress-nginx
else
    echo "Unsupported OS: ($OS)"
fi

kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=90s

echo "Deployed kind in :" $(( $(date +%s) - start )) "seconds"