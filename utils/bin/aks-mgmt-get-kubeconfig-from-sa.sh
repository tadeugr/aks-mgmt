#!/bin/bash

# Get kubeconfig from Service Account
#
# Required env vars (set using export command)
#   SERVER Kubernetes API endpoint
#   CLUSTER_NAME Cluster name that will be used in kubeconfig context
#   SA_NAME Service Acount name
#   SA_NS Service Acount namespace

# START validations

if [ -z "$SERVER" ]
then
      echo "\$SERVER variable must be set"
      exit 0
fi

if [ -z "$CLUSTER_NAME" ]
then
      echo "\$CLUSTER_NAME variable must be set"
      exit 0
fi

if [ -z "$SA_NAME" ]
then
      echo "\$SA_NAME variable must be set"
      exit 0
fi

if [ -z "$SA_NS" ]
then
      echo "\$SA_NS variable must be set"
      exit 0
fi

# END validations

echo "Setting variables"
secretName=$(kubectl -n $SA_NS get secret | grep $SA_NAME | awk '{print $1}') || exit 1
ca=$(kubectl -n $SA_NS get secret $secretName -o jsonpath='{.data.ca\.crt}') || exit 1
token=$(kubectl -n $SA_NS get secret $secretName -o jsonpath='{.data.token}') || exit 1
tokenDecode=$(echo $token | base64 --decode) || exit 1

echo "Creating temporary folder"
cd "$(mktemp -d)" || exit 1

echo "Writing kubeconfig file"
echo "
apiVersion: v1
kind: Config
clusters:
- name: $CLUSTER_NAME
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: $CLUSTER_NAME
  context:
    cluster: $CLUSTER_NAME
    user: $SA_NAME
current-context: $CLUSTER_NAME
users:
- name: $SA_NAME
  user:
    token: ${tokenDecode}
" > $SA_NAME.kubeconfig

echo "kubeconfig created: `pwd`/$SA_NAME.kubeconfig"