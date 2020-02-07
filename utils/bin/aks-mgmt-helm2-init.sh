#!/bin/bash

echo "Using Helm version:"
helm version --client
echo ""

echo "Working on cluster:"
kubectl cluster-info
echo ""

echo "Input Tiller Namespace: "
read TILLER_NAMESPACE

if [ -z "$TILLER_NAMESPACE" ]
then
      echo "\Tiller Namespace must be set"
      exit 1
fi

echo "Input Tiller Service Account: "
read SERVICE_ACCOUNT

if [ -z "$SERVICE_ACCOUNT" ]
then
      echo "\Tiller Service Account must be set"
      exit 1
fi

echo "Use TLS (y/n)? "
read USE_TLS

if [ -z "$USE_TLS" ]
then
      USE_TLS = "y"
fi

if [ $USE_TLS == "y" ]
then
    CERT_DIR=/tmp/helm-init-$(uuidgen)
    mkdir $CERT_DIR
    echo "Working dir: $CERT_DIR"
    cd $CERT_DIR

    openssl genrsa -out ./ca.key.pem 4096

    openssl req \
    -key ca.key.pem \
    -new -x509 -days 7300 -sha256 \
    -out ca.cert.pem \
    -extensions v3_ca \
    -subj "/C=BR/ST=YourState/L=YourCity/O=YourCompany"
    
    openssl genrsa \
    -out ./tiller.key.pem 4096
    
    openssl genrsa \
    -out ./helm.key.pem 4096

    openssl req \
    -key tiller.key.pem \
    -new \
    -sha256 \
    -out tiller.csr.pem \
    -subj "/C=BR/ST=YourState/L=YourCity/O=HBSIS"
    
    openssl req \
    -key helm.key.pem \
    -new \
    -sha256 \
    -out helm.csr.pem \
    -subj "/C=BR/ST=YourState/L=YourCity/O=HBSIS"
    
    
    openssl x509 -req \
    -CA ca.cert.pem \
    -CAkey ca.key.pem \
    -CAcreateserial \
    -in tiller.csr.pem \
    -out tiller.cert.pem \
    -days 365
    
    openssl x509 -req \
    -CA ca.cert.pem \
    -CAkey ca.key.pem \
    -CAcreateserial \
    -in helm.csr.pem \
    -out helm.cert.pem \
    -days 365
    
    helm init \
    --tiller-tls \
    --tiller-tls-cert tiller.cert.pem \
    --tiller-tls-key tiller.key.pem \
    --tiller-tls-verify \
    --tls-ca-cert ca.cert.pem \
    --upgrade \
    --override 'spec.template.spec.containers[0].resources.limits.memory'="500Mi" \
    --override 'spec.template.spec.containers[0].resources.limits.cpu'="2" \
    --tiller-namespace $TILLER_NAMESPACE \
    --service-account $SERVICE_ACCOUNT

    echo "Working dir: $CERT_DIR"
else
    helm init \
    --upgrade \
    --override 'spec.template.spec.containers[0].resources.limits.memory'="500Mi" \
    --override 'spec.template.spec.containers[0].resources.limits.cpu'="2" \
    --tiller-namespace $TILLER_NAMESPACE \
    --service-account $SERVICE_ACCOUNT
fi
