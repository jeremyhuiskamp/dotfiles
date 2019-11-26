#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RUNTIME=$(date "+%Y-%m-%dT%H:%M:%S")

mkdir -p ~/.config

for src in config/nvim bash_profile bashrc bashrc.d gitconfig gitignore_global irbrc tmux.conf vim psqlrc zshrc; do
	# remove existing symlinks:
	[ -L ~/.${src} ] && rm ~/.${src}
	# back up existing real files:
	if [ -e ~/.${src} ]; then
		backup=${BASEDIR}/backups/${src}.${RUNTIME}
		mkdir -p $(dirname ${backup})
		mv ~/.${src} ${backup}
	fi
	ln -s ${BASEDIR}/${src} ~/.${src}
done
