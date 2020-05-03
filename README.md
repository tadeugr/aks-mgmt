![Docker Image](https://github.com/tadeugr/aks-mgmt/workflows/Docker%20Image/badge.svg)

# Docker Hub

https://hub.docker.com/repository/docker/tadeugr/aks-mgmt

# How to docker run

## Quick and simple

```
docker run -it --rm tadeugr/aks-mgmt
```

## Export env vars

```
docker run \
  -it \
  --rm \
  -e AKS_RG='my-aks-resource-group' \
  -e AKS_NAME='my-aks-cluster' \
  tadeugr/aks-mgmt
```

## Mount a volume

If you have a local folder that need be used inside the container.

```
cd path/to/your/project/folder

docker run \
  -it \
  --name aks-mgmt \
  -v "`pwd`":/app \
  tadeugr/aks-mgmt
```

## Expose ports

```
docker run \
  -it \
  --name aks-mgmt \
  -p 80:80 \
  -p 8080:8080 \
  tadeugr/aks-mgmt
```

# General info

* Docker image from ubuntu:18.04
* Default locale: en_US.UTF-8
* Default shell: zsh
* Kubectl autocomplete enabled (also with an alias `k`)

# Tools installed

* apt-transport-https
* azure-cli
* build-essential
* ca-certificates
* curl
* dnsutils
* git
* iputils-ping
* jq
* krew
  * whoami
* kubectl
* locales
* lsb-release
* nano
* nginx
  * One server listening no port 80
  * One server listening no port 8080
* python-all
* rlwrap
* ssh
* tcpdump
* telnet
* vim
* wget
* zsh
  * Theme: agnoster
  * Plugins:
    * git
    * kubectl
