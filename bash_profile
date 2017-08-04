# I = case insensitive search
# R = process control characters (like terminal colours)
# X = disable termcap (usually disables clearing of screen)
# F = exit immediately if content doesn't fill the screen
export LESS=IR

export EDITOR=vim
export PAGER=less
export GOPATH=$HOME/src/self/go

export PATH=$PATH:$GOPATH/bin

# macports:
PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export PATH=$PATH:$HOME/bin
# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
