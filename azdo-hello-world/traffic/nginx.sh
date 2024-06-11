#!/bin/bash

# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm repo update

# kubectl create ns ingress-nginx
helm upgrade --install --debug ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx -f nginxValues.yaml
