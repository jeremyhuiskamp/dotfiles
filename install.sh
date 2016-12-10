#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RUNTIME=$(date "+%Y-%m-%dT%H:%M:%S")

for src in bash_profile bashrc gitconfig gitignore_global irbrc tmux.conf vim; do
	[ -f ~/.${src} -o -d ~/.${src} ] && mv ~/.${src} ${BASEDIR}/backups/${src}.${RUNTIME}
	ln -s ${BASEDIR}/${src} ~/.${src}
done