#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RUNTIME=$(date "+%Y-%m-%dT%H:%M:%S")

for src in config/nvim bash_profile bashrc bashrc.d gitconfig gitignore_global irbrc tmux.conf vim psqlrc; do
	# remove existing symlinks:
	[ -L ~/.${src} ] && rm ~/.${src}
	# back up existing real files:
	[ -e ~/.${src} ] && mv ~/.${src} ${BASEDIR}/backups/${src}.${RUNTIME}
	ln -s ${BASEDIR}/${src} ~/.${src}
done
