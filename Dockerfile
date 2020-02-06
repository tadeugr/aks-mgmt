FROM ubuntu:18.04

RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends\
      apt-transport-https \
      apt-utils \
      build-essential \
      curl \
      ca-certificates \
      git \
      lsb-release \
      python-all \
      rlwrap \
      vim \
      nano \
      jq \
      zsh \
      wget \
      locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash  && \
    az aks install-cli  && \
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true  && \
    chsh -s /usr/bin/zsh root && \
    echo "Start install krew" && \
    set -x; cd "$(mktemp -d)" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.3/krew.{tar.gz,yaml}" && \
    tar zxvf krew.tar.gz && \
    KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" && \
    "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz && \
    "$KREW" update && \
    echo "Finish install krew" && \
    kubectl krew install whoami
COPY zshrc /root/.zshrc
ENV LC_ALL="en_US.UTF-8"
CMD [ "zsh" ]