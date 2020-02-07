export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git kubectl)
source $ZSH/oh-my-zsh.sh
source <(kubectl completion zsh)
alias k=kubectl
complete -F __start_kubectl k
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="/root/utils/bin:$PATH"