#!/bin/bash

# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo update

kubectl create ns monitoring
helm upgrade --install --debug prometheus prometheus-community/prometheus -n monitoring
