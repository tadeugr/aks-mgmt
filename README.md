![Docker Image](https://github.com/tadeugr/aks-mgmt/workflows/Docker%20Image/badge.svg)

# Docker Hub

https://hub.docker.com/repository/docker/tadeugr/aks-mgmt

# How to docker run

## Quick and simple

```
docker run -it --rm tadeugr/aks-mgmt
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
* git
* jq
* krew
  * whoami
* kubectl
* locales
* lsb-release
* nano
* python-all
* rlwrap
* vim
* wget
* zsh
