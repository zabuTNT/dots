command -v kubectl >/dev/null 2>&1 || return 0

source <(kubectl completion bash)
complete -F __start_kubectl k

export KUBECONFIG="$HOME/.kube/config"
[ -d "$HOME/.krew/bin" ] && PATH="$HOME/.krew/bin:$PATH"
