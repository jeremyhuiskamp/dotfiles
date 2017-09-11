# TODO: publish a $BREW_PREFIX in main bashrc if more tools need this
# calling brew adds a lot of time to shell startup...
if command -v brew &>/dev/null; then
	arcanist_completion="$(brew --prefix arcanist)/libexec/resources/shell/bash-completion"
	if [ -r "$arcanist_completion" ]; then
		source "$arcanist_completion"
	fi
fi
