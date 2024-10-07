# Deployment Setup

This document outlines how to set up the environment for deploying a Kubernetes cluster with Calico CNI, NGINX Ingress, and various components such as Snyk Connector and a vulnerable demo application. This setup has been tested with Docker Desktop and Kind.

This setup creates a secure Kubernetes cluster with a vulnerable demo application for testing and monitoring purposes.

### !! DO NOT DEPLOY INTO PRODUCTION ENVIRONMENTS !!

## Pre-requisites

Ensure that the following tools are installed on your system:

- Docker Desktop 4.23.0
- Kind 0.19.0
- Kubectl
- Helm

You can install the tools with the following commands:

```bash
brew install kind
brew install kubectl
brew install helm
```

## Script Overview

This repository includes several scripts that automate the deployment process. **Before running any scripts, ensure that the environment variables in `setenv.sh` are correctly set up or available in your environment.**

- **deploy.sh**: The main deployment script, which supports different deployment options.
- **deploy-cluster.sh**: Script to deploy a Kind Kubernetes cluster with Calico CNI and NGINX Ingress.
- **deploy-connector.sh**: Script to deploy the Snyk Connector for Kubernetes monitoring.
- **deploy-demo.sh**: Script to deploy a vulnerable Node.js demo application.
- **prepare.sh**: Prepares the environment by ensuring the necessary dependencies and configurations.

## Usage

To deploy the environment, you can use the `deploy.sh` script, which offers several options:

```bash
Usage: bash deploy.sh [--cluster] [--connector] [--monitor] [--demo] [--all] [--demo-connector-only]
```

### Options

- `--cluster`: Deploy the Kind cluster.
- `--connector`: Deploy the Snyk Connector.
- `--monitor`: Deploy the Snyk Monitor (Optional).
- `--demo`: Deploy the vulnerable demo application.
- `--all`: Deploy everything (Cluster, Connector, Monitor, and Demo).
- `--demo-connector-only`: Deploy only the demo application and the connector.

## Step-by-Step Deployment

### 1. Deploy the Kubernetes Cluster

The `deploy-cluster.sh` script sets up a Kind Kubernetes cluster with Calico CNI and NGINX Ingress. Run the following to deploy the cluster:

```bash
bash deploy.sh --cluster
```

The script detects the OS and uses the appropriate configuration for macOS or Linux. It also installs Calico for network policies and NGINX as the ingress controller.

### 2. Deploy the Snyk Connector

To deploy the Snyk Connector for monitoring Kubernetes resources, use the following command:

```bash
bash deploy.sh --connector
```

This step requires the **SNYK_CONNECTOR_SA_TOKEN** and **SNYK_ORG_ID** environment variables. If these are not set in the environment, the script will prompt you to input them.

### 3. Deploy the Demo Application

To deploy the vulnerable Node.js demo application, run:

```bash
bash deploy.sh --demo
```

This will deploy two versions of the Node.js application: an external-facing version in the `nodejs-goof` namespace and an internal version in the `nodejs-goof-internal` namespace. Both will be monitored by the Snyk Connector.

### 4. Deploy All Components

For a full setup, including the cluster, connector, monitor, and demo, use:

```bash
bash deploy.sh --all
```

### 5. Demo and Connector Only

To deploy only the demo and connector without the cluster, use:

```bash
bash deploy.sh --demo-connector-only
```

## Monitoring the Deployment

To check the status of the deployments and pods, use the following commands:

```bash
kubectl get pods --all-namespaces
kubectl get nodes
```

### Example Output:

```bash
NAMESPACE              NAME                                      READY   STATUS    RESTARTS   AGE
kube-system            coredns-558bd4d5db-vnt5l                  1/1     Running   0          2m
kube-system            etcd-kind-control-plane                   1/1     Running   0          3m
ingress-nginx          ingress-nginx-controller-ff8d85b77-hm4w   1/1     Running   0          1m
nodejs-goof            nodejs-goof-6c8b5d97f6-nrb48              1/1     Running   0          50s
```

### Accessing the Demo Application

Once the demo application is running, you can access it via the Ingress controller. The application is deployed with an NGINX Ingress resource to expose it at the root `/` path.

To confirm the ingress is set up correctly, run:

```bash
kubectl get ingress -n nodejs-goof
```

### Troubleshooting

- Ensure Docker Desktop is running.
- Verify that environment variables are correctly set up by sourcing `setenv.sh`.
- If any deployments fail, check the logs for errors using `kubectl logs`.

### This setup creates a secure Kubernetes cluster with a vulnerable demo application for testing and monitoring purposes. !!DO NOT DEPLOY INTO PRODUCTION ENVIRONMENTS!! The Snyk Connector provides real-time monitoring and reporting of vulnerabilities within the cluster

