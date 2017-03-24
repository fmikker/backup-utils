#!/bin/sh
# Borg cron backup script with desktop notifications
# Meant to be run as root
#
# Copyright (C) 2016 Olivier Bilodeau
# Licensed under the MIT License

# configuration
USER=root
export BORG_PASSPHRASE=''
REPOSITORY=backup@t.ld:repo
COMPRESSION=zlib,9
EXCLUDES=/root/.borgexcludes
# derived information
export BORG_CACHE_DIR=/root/.cache/borg/

borg create -v --stats                      \
	--compression $COMPRESSION              \
	$REPOSITORY::'{hostname}-{now:%Y-%m-%d}'\
	/ \
	--exclude-from $EXCLUDES

if [[ $? == 0 ]]; then
        logger -t borgbackup -p info "Backup success"
else
        logger -t borgbackup -p warning"Backup failed... See root's dead.letter for details."
fi

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machine's archives also.
borg prune -v $REPOSITORY --prefix '{hostname}-' \
--keep-daily=7 --keep-weekly=4 --keep-monthly=6
