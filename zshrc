# start or attach to tmux
if [[ -z "$TMUX" ]]; then
  # TODO: revisit the idea of re-connecting to an existing shell.
  # I more often accidentally connect from multiple clients than
  # fail to connect to an existing background shell.

  # Don't do this for now because, eg, VisualStudio tries to start a new shell,
  # gets connected to tmux, and then weird things happen.
  #tmux new-session -A -s "$USER-zsh" /bin/zsh
  echo "not starting zsh tmux session due to other things like IDEs that don't play well with it"

  # Now we're back to the original shell, having either
  # closed or detached from the session.  We continue with
  # setup so that we have a usable shell outside of tmux.
else
  # until zsh is my default shell, make sure this tmux
  # session keeps starting new shells with zsh:
  tmux set-option default-shell /bin/zsh
fi

# enable git prompts, as per
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Zsh
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%F{red}(%b)%f'

# exit code in red, if not 0 & bold blue current path:
# idea: add some red ()s to differentiate from other shell output
#   eg, `fd` tends to prefix output with a blue string
PROMPT='%(?..%F{red}?%?%f )%B%F{blue}%1~%#%f%b '
# show git info and date/time on the right
RPROMPT='${vcs_info_msg_0_} %D %*'

# enable completion:
autoload -Uz compinit
compinit

# vi mode:
bindkey -v

# basic history niceties
# https://scriptingosx.com/2019/06/moving-to-zsh-part-3-shell-options/
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# generated by /usr/local/opt/fzf/install and lightly edited:
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

# aliases
# TODO: move to separate file
alias ls='ls -F'
alias unzip='unzip -q' # don't print the names of files being extracted
alias bc='bc -q'
alias tcpdump='sudo tcpdump -Xlen -s 0'
alias sshc='vim ~/.ssh/config'
alias xf='xmllint --format -'
alias hex='open -a "Hex Fiend"'

# I = case insensitive search
# R = process control characters (like terminal colours)
# X = disable termcap (usually disables clearing of screen)
# F = exit immediately if content doesn't fill the screen
export LESS=IR
export PAGER=less
export EDITOR=nvim

# For man pages, we need a maximum width, but it should
# be smaller if the terminal is smaller, so MANWIDTH needs
# to be calculated on the fly.  This still doesn't work
# well if the terminal is resized while man is open, but
# that doesn't seem solveable.
alias man='MANWIDTH=$((COLUMNS > 80 ? 80 : COLUMNS)) man'

if type jenv &>/dev/null; then
  eval "$(jenv init -)"
  export JAVA_HOME=$(jenv javahome)
fi

# Things still to do:
# - git aliases / functions
# - a zshrc.d?
# - anything obviously missing from my bash stuff

autoload -U +X bashcompinit && bashcompinit

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

