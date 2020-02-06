FROM ubuntu:18.04

RUN echo "Start apt-get update" && \
    apt-get update -qq && \
    echo "Finish apt-get update" && \
    echo "Start apt-get install" && \
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
    echo "Finish apt-get install" && \
    echo "Start set locale" && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    echo "Finish set locale" && \
    echo "Start install azure cli" && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash  && \
    echo "Finish install azure cli" && \
    echo "Start install kubectl" && \
    az aks install-cli  && \
    echo "Finish install kubectl" && \
    echo "Start install zsh" && \
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true  && \
    chsh -s /usr/bin/zsh root && \
    echo "Finish install zsh" && \
    echo "Start install krew" && \
    set -x; cd "$(mktemp -d)" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.3/krew.{tar.gz,yaml}" && \
    tar zxvf krew.tar.gz && \
    KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" && \
    "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz && \
    "$KREW" update && \
    echo "Finish install krew" && \
    echo "Start install krew extensions" && \
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && \
    kubectl krew install whoami && \
    echo "Finish install krew extensions"
COPY zshrc /root/.zshrc
ENV LC_ALL="en_US.UTF-8"
CMD [ "zsh" ]