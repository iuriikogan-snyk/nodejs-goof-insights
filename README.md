# Snyk Nodejs-Goof Insights Demo Repository

Repo to help with demo setup for Apprisk

## Quick Start

1. Github actions: Each workflow has a workflow_dispatch: trigger, set the required envs as repository secrets prior to running
2. setup-k8s scripts: in the setup-k8s directory there are deploy scripts for kind, nginx, snyk-connector and a demo application with service/ingress
3. ACloudGuru: you can setup a demo sandbox and deploy either with the deploy-eks workflow, or by deploying a eks cluster and following the instructions for an existing cluster

## I want to deploy Snyk Connector and a demo app to a local kind cluster

Follow instructions in the setup-k8s directory to deploy a kind cluster, with nginx ingress controller, nodejs-demo app and snyk-connector to display OS, Deployed and Public Facing Risk Factors

## I want to deploy Snyk Connector and a demo app to an existing cluster

Follow instrustions in the setup-k8s directory for deploying the demo app and kubernetes connector only

## I want to monitor & tag OS and Container Projects for use with Snyk AppRisk Pro via Github Actions

Run snyk-test workflow with required env vars for snyk org, the tags will be applied and the build image workflow will be triggered which will push build and push your image to Dockerhun=b

## I want to monitor & tag OS and Container Projects for use with Snyk AppRisk Pro via Apply-tags.py script

Follow instructions in the /insights directory [apply-tags.py]

## Original Nodejs-Goof README

[README-GOOF.md](./README-GOOF.md)
