export ZSH="/Users/renato/.oh-my-zsh"

ZSH_THEME="muse"

plugins=(
  git
  docker
  zsh-completions
)

source $ZSH/oh-my-zsh.sh
source $HOME/.bash_profile

alias pods='kubectl get pods -n'
alias deployments='kubectl get deployments -n'
alias jobs='kubectl get jobs -n'
alias redis='docker run -it --rm redis redis-cli -p 6379'
alias psql='docker run -it --rm -v /tmp:/tmp postgres psql'
alias sqlcmd='docker run --rm --network=bridge -it mcr.microsoft.com/mssql-tools /opt/mssql-tools/bin/sqlcmd'

logs() {
  kubectl -n $1 logs -f $2
}

rollout_history() {
  kubectl -n $1 rollout history deployment.v1.apps/$2
}

rollout_undo() {
  kubectl -n $1 rollout undo deployment.v1.apps/$2
}

apply_deploy() {
  kubectl -n $1 apply -f $2
}

describe_pod() {
  kubectl -n $1 describe pod $2
}

docker_rm_exited() {
  docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
}

pyclean () {
    find . | grep -E "(__pycache__|\.egg-info|build|dist|\.pyc|\.pyo$)" | xargs rm -rf
}

source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

autoload -U compinit && compinit

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"
alias jenv_set_java_home='export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"'

export SBT_OPTS="-Xms1536m -Xmx1536m -XX:+UseG1GC -XX:-UseParNewGC -XX:-UseConcMarkSweepGC"
