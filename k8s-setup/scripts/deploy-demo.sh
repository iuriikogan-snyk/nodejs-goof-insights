#!/usr/bin/env bash

# **BEFORE RUNNING THIS SCRIPT CHANGE THE VARS IN setenv.sh or ensure they are available in your environment**

# Exit the script on any error, unset variable, or command failure in a pipeline.
set -ou pipefail

# Deploy the demo application
cat << EOL | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: nodejs-goof 
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-goof 
  namespace: nodejs-goof 
spec:
  selector:
    matchLabels:
      app: nodejs-goof 
  template:
    metadata:
      labels:        
        app: nodejs-goof 
    spec:
      containers:
      - name: nodejs-goof 
        image: ${IMAGE_NAME}
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        env:
        - name: MONGO_URI
          value: mongodb://mongo:27017/goof-mongo
        - name: MYSQL_URI
          value: mysql://goofuser:goofpassword@mysql:3306/goof-mysql
        ports:
        - containerPort: 3001
---
apiVersion: v1
kind: Service
metadata:
  name: nodejs-goof 
  namespace: nodejs-goof
  labels:
    app: nodejs-goof 
spec:
  type: ClusterIP
  ports:
    - port: 1337
      targetPort: 3001
      protocol: TCP
  selector:
    app: nodejs-goof 
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name:  nodejs-goof-ingress
  namespace: nodejs-goof
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nodejs-goof 
            port:
              number: 1337
EOL

cat << EOL | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: nodejs-goof-internal
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodejs-goof-internal
  namespace: nodejs-goof-internal
spec:
  selector:
    matchLabels:  
      app: nodejs-goof-internal
  template:
    metadata:
      labels:
        app: nodejs-goof-internal
    spec:
      containers:
      - name: nodejs-goof-internal
        image: ${IMAGE_NAME}
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        ports:
        - containerPort: 3000
EOL

echo 'waiting for nodejs-goof pods to become ready....'
kubectl wait --for=condition=ready pod -l app=nodejs-goof -n nodejs-goof --timeout=90s