#!/bin/bash

az vmss update --resource-group MC_azdo-k8s_group_azdo-k8s_eastus2 --name aks-agentpool-22158225-vmss --remove virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools 0

az vmss update-instances --instance-ids "*" -n aks-agentpool-22158225-vmss -g MC_azdo-k8s_group_azdo-k8s_eastus2

az network lb delete -g MC_azdo-k8s_group_azdo-k8s_eastus2 -n kubernetes
