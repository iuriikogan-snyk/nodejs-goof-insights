#!/usr/bin/env bash

# **BEFORE RUNNING THIS SCRIPT CHANGE THE VARS IN setenv.sh or ensure they are available in your environment**

# Exit the script on any error, unset variable, or command failure in a pipeline.
set -ou pipefail

# Deploy the demo application and required databases
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
        ports:
        - containerPort: 3000
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
      targetPort: 3000
      protocol: TCP
  selector:
    app: nodejs-goof
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nodejs-goof-ingress
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
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: nodejs-goof
spec:
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: rootpassword
        - name: MYSQL_DATABASE
          value: goofdb
        - name: MYSQL_USER
          value: goofuser
        - name: MYSQL_PASSWORD
          value: goofpassword
        ports:
        - containerPort: 3306
---
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: nodejs-goof
spec:
  selector:
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb
  namespace: nodejs-goof
spec:
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo:5.0
        env:
        - name: MONGO_INITDB_ROOT_USERNAME
          value: admin
        - name: MONGO_INITDB_ROOT_PASSWORD
          value: adminpassword
        - name: MONGO_INITDB_DATABASE
          value: goofdb
        ports:
        - containerPort: 27017
---
apiVersion: v1
kind: Service
metadata:
  name: mongodb
  namespace: nodejs-goof
spec:
  selector:
    app: mongodb
  ports:
    - port: 27017
      targetPort: 27017
EOL

# Wait for pods to become ready
echo 'waiting for nodejs-goof pods to become ready....'
kubectl wait --for=condition=ready pod -l app=nodejs-goof -n nodejs-goof --timeout=90s
echo 'waiting for mysql and mongodb pods to become ready....'
kubectl wait --for=condition=ready pod -l app=mysql -n nodejs-goof --timeout=90s
kubectl wait --for=condition=ready pod -l app=mongodb -n nodejs-goof --timeout=90s

# Get the ingress hostname or IP
INGRESS_HOST=$(kubectl get ingress nodejs-goof-ingress -n nodejs-goof -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
INGRESS_IP=$(kubectl get ingress nodejs-goof-ingress -n nodejs-goof -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Display where the application is available
if [[ -n "$INGRESS_HOST" ]]; then
    echo "nodejs-goof is available at http://$INGRESS_HOST"
elif [[ -n "$INGRESS_IP" ]]; then
    echo "nodejs-goof is available at http://$INGRESS_IP"
else
    echo "Ingress not yet available. Check the status with: kubectl describe ingress nodejs-goof-ingress -n nodejs-goof"
fi
