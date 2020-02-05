FROM ubuntu:18.04

RUN apt-get update -qq && \
    apt-get install -qqy --no-install-recommends\
      apt-transport-https \
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
      locales \

RUN locale-gen en_US.UTF-8

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az aks install-cli

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN chsh -s /usr/bin/zsh root
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc > ~/.zshrc
RUN echo 'source <(kubectl completion zsh)' >> ~/.zshrc
RUN echo 'alias k=kubectl' >> ~/.zshrc
RUN echo 'complete -F __start_kubectl k' >> ~/.zshrc
CMD [ "zsh" ]