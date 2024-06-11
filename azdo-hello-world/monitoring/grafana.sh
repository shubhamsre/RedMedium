#!/bin/bash

# helm repo add grafana https://grafana.github.io/helm-charts
# helm repo update

helm upgrade --install --debug grafana grafana/grafana -n monitoring -f grafanaValues.yaml
