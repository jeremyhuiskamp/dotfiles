#!/bin/bash

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# set content of prompt
export PS1='\W$ '
export PS1="\[\e[0;34m\]$PS1\[\e[0m\]"

alias ls='ls -F'
alias ll='ls -l'   # list details
alias la='ls -a'   # list all
alias lla='ls -al' # list all with details
alias lh='ls -lh'  # directory listings with 'smart' sizes using G, M and K
alias unzip='unzip -q' # don't print the names of files being extracted

alias vi='vim -C' # run vim in somewhat vi compatible mode

alias bc='bc -q'

alias tcpdump='sudo tcpdump -Xlen -s 0'

alias eject='diskutil eject'
# real umount is not reliable on os x
alias umount='diskutil umount'
alias mount='diskutil mount'

alias sshc='vim ~/.ssh/config'

# re-source bashrc
alias bashrc='. ~/.bashrc'

alias xf='xmllint --format -'

# favourite gui hex editor:
alias hex='open -a "Hex Fiend"'

# list contents of a zip file (usually a jar)
jv() {
    unzip -l "$@" | less
}

# list contents of a tar file
tv() {
    tar tvvzf $@ | LESS=FIX less
}

# add public ssh key on $1
key() {
    cat ~/.ssh/id_rsa.pub | ssh "$1" '
        [ ! -e ~/.ssh/authorized_keys ] && {
            mkdir -p ~/.ssh
            chmod 700 ~/.ssh
            touch ~/.ssh/authorized_keys
            chmod 600 ~/.ssh/authorized_keys
        }
        cat >> ~/.ssh/authorized_keys'
}

# wrapper to start visual java keytool editor
pc() {
    java -jar ~/tools/versions/portecle-1.7/portecle.jar &
}

dcmtxt() {
    dcm2txt -w 512 "$@" | less
}
alias d2t=dcmtxt

## This is my git porcelain. There are many like it, but this one is mine. ##
# TODO:
# - fold into proper git aliases
# - find out which features have been added to git itself

# LESS options:
# I - ignore case in searches
# F - if all can be shown in one screen, quit
# R - raw control characters, allows display of colour
# X - don't send screen clearing commands, needed with F

alias gst='git status'

# git diff, properly piped into less
gd() {
    LESS=IR git diff --color $@
}

# git diff with stats
gds() {
    LESS=FXIR git diff --stat --color $@
}

# git diff of the index
gdc() {
    LESS=IR git diff --cached --color $@
}

# combo of gd and gdc
gdh() {
    LESS=IR git diff HEAD --color $@
}

# git diff of the index with stats
gdcs() {
    LESS=FXIR git diff --cached --stat --color $@
}

# git log since
gls() {
    SINCE="$1"
    shift
    LESS=IR git log --author=jeremy --since="$SINCE" --reverse --color --branches "$@"
}

# show commits not pushed on current branch
gnp() {
    branch=$(git branch | egrep '^\*' | awk '{print $2}')
    LESS=FXIR git log --oneline origin/$branch..$branch --color "$@"
}

# show commits fetched but not merged on current branch
gnm() {
    branch=$(git branch | egrep '^\*' | awk '{print $2}')
    LESS=FXIR git log --pretty=format:'%C(yellow)%h%Creset %s %Cblue(%an)' $branch..origin/$branch --color "$@"
}

# show Not Merged or Pushed
gnmp() {
    NP=$(gnp $@)
    if [ ! -z "$NP" ]; then
        echo 'Not pushed:'
        echo "$NP"
    fi
    NM=$(gnm $@)
    if [ ! -z "$NM" ]; then
        [ -z "$NP" ] || echo
        echo 'Not merged:'
        echo "$NM"
    fi
}

# show commits not pushed on current branch, with patch
gnpp() {
    branch=$(git branch | egrep '^\*' | awk '{print $2}')
    LESS=IR git log --oneline origin/$branch..$branch --color -p "$@"
}

# fast forward in the current branch (only works for remotes/origin branches)
gff() {
    # please don't have spaces or metacharaters in your branch name!
    branch=$(git branch | egrep '^\*' | awk '{print $2}')
    remote=$(git branch -r | egrep '^ *origin/'$branch'$')
    if [ "$remote" ]; then
        git merge --ff-only $remote
    else
        echo "No origin branch to merge" 1>&2
    fi
}

# rebases onto the remotes/origin branch of the same name
# not sure why rebase doesn't have an option for this already
gro() {
    # please don't have spaces or metacharaters in your branch name!
    branch=$(git branch | egrep '^\*' | awk '{print $2}')
    remote=$(git branch -r | egrep '^ *origin/'$branch'$')
    if [ "$remote" ]; then
        git rebase $remote
    else
        echo "No origin branch to rebase" 1>&2
    fi
}

# squash the last $1 commits together
# (careful with your arguments here, there's no error checking)
gsq() {
    git rebase -i HEAD~$1
}

# shortcut for git cherry-pick that appends the hash of the
# picked commit to the message and opens an editor before
# committing
alias gcp='git cherry-pick -x -e'

# git pull, but only do fast forward merges
alias gp='git pull --ff-only'

alias gsh='LESS=IR git show --color'

# git rm all files in the current directory that have been deleted by something else
alias grd='git diff --name-only --diff-filter=D --relative -z -- . | xargs -0 git rm'

alias gsync='git fetch && gnmp'

# for forwarding over ssh connections:
export GIT_AUTHOR_NAME=$(git config user.name)
export GIT_AUTHOR_EMAIL=$(git config user.email)

set -o vi

alias doco=docker-compose
alias tf=terraform

[ type kubectl &>/dev/null ] && source <(kubectl completion bash)
[ type minikube &>/dev/null ] && source <(minikube completion bash)

# careful of subprocesses when exporting vars:
# https://stackoverflow.com/questions/7390497/bash-propagate-value-of-variable-to-outside-of-the-loop
while read f; do
	. $f
done < <(find "$HOME/.bashrc.d/" -name '*.sh')
