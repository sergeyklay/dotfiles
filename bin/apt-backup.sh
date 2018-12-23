#!/bin/sh

export APT_BACKUP_DIR=$HOME/Dropbox/apt-backup/$(/bin/date "+%Y%m%d-%H%M%S")-$(uname -n)
mkdir -p $APT_BACKUP_DIR

if [ -d $APT_BACKUP_DIR ]; then
	for file in `ls -1 /etc/apt/sources.list.d | grep -v .save`; do
		cp "/etc/apt/sources.list.d/${file}" ${APT_BACKUP_DIR}/
	done
fi
