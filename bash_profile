# Start tmux by default, attaching to or creating a common session.
# .bash_profile and .bashrc are, in general, not idempotent (eg, appending to $PATH).
# Start tmux immediately so that, if we create a new session, we're not
# inheriting the parent env and then updating it again.
if [[ -z "$TMUX" ]]; then
	if tmux has-session -t "$USER" &>/dev/null; then
		echo declining to attach to tmux session '"'$USER'"'
		#tmux attach-session -t "$USER"
	else
		echo declining to create new tmux session '"'$USER'"'
		#tmux new-session -s "$USER"
	fi
	# Now we're back to the original shell, having either
	# closed or detached from the session.  We continue with
	# setup so that we have a usable shell outside of tmux.
fi

# I = case insensitive search
# R = process control characters (like terminal colours)
# X = disable termcap (usually disables clearing of screen)
# F = exit immediately if content doesn't fill the screen
export LESS=IR

export EDITOR=nvim
export PAGER=less
export GOPATH=$HOME/src/go

export PATH=$PATH:$GOPATH/bin

# macports:
PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export PATH=$PATH:$HOME/bin

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# https://support.apple.com/en-us/HT208050
# Don't warn about zsh being the default on every new shell.
# TODO: try porting all my bash config to zsh...
export BASH_SILENCE_DEPRECATION_WARNING=1
. "$HOME/.cargo/env"
