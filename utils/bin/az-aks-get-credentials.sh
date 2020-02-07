#!/bin/bash

# Get AKS kubeconfig file
#
# Required env vars (set using export command)
#   AKS_RG AKS Resource Group
#   AKS_NAME AKS cluster name

# START validations

if [ -z "$AKS_RG" ]
then
      echo "\$AKS_RG variable must be set"
      exit 0
fi

if [ -z "$AKS_NAME" ]
then
      echo "\$AKS_NAME variable must be set"
      exit 0
fi

FILE=$HOME/.kube/config
if test -f "$FILE"; then
    echo "$FILE already exists. Do you want to merge them (y/n)?"
    read MERGE
fi

if [ "$MERGE" == "n" ]
then
    echo "Aborting."
    exit 0
fi

echo "Get kubeconfig --admin (y/n)?"
read ADMIN
ADMIN_PARAM=""
if [ "$ADMIN" == "y" ]
then
    ADMIN_PARAM="--admin"
fi

az aks get-credentials \
  --resource-group $AKS_RG \
  --name $AKS_NAME \
  $ADMIN_PARAM