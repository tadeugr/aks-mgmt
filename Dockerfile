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
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash  && \
    az aks install-cli  && \
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true  && \
    chsh -s /usr/bin/zsh root
COPY zshrc /root/.zshrc
CMD [ "zsh" ]