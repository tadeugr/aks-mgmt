#!/bin/bash

# Get kubeconfig from Service Account
#
# Required env vars
#   server Kubernetes API endpoint
#   clusterName Cluster name that will be used in kubeconfig context
#   saName Service Acount name
#   saNs Service Acount namespace

# START validations

if [ -z "$server" ]
then
      echo "\$server variable must be set"
      exit 0
fi

if [ -z "$clusterName" ]
then
      echo "\$clusterName variable must be set"
      exit 0
fi

if [ -z "$saName" ]
then
      echo "\$saName variable must be set"
      exit 0
fi

if [ -z "$saNs" ]
then
      echo "\$saNs variable must be set"
      exit 0
fi

# END validations

echo "Setting variables"
secretName=$(kubectl -n $saNs get secret | grep $saName | awk '{print $1}')
ca=$(kubectl -n $saNs get secret $secretName -o jsonpath='{.data.ca\.crt}')
token=$(kubectl -n $saNs get secret $secretName -o jsonpath='{.data.token}')
tokenDecode=$(echo $token | base64 --decode)

echo "Creating temporary folder"
cd "$(mktemp -d)" || exit 1

echo "Writing kubeconfig file"
echo "
apiVersion: v1
kind: Config
clusters:
- name: $clusterName
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: $clusterName
  context:
    cluster: $clusterName
    user: $saName
current-context: $clusterName
users:
- name: $saName
  user:
    token: ${tokenDecode}
" > $saName.kubeconfig

echo "kubeconfig created: `pwd`/$saName.kubeconfig"