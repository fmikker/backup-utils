#!/bin/sh
# Borg cron backup script with desktop notifications
# Meant to be run as root
#
# Copyright (C) 2016 Olivier Bilodeau
# Licensed under the MIT License
# Additions 2017 Fredrik Mikker
# configuration

USER=root
export BORG_PASSPHRASE='password'
REPOSITORY=backup@hostname:root-disk
COMPRESSION=zlib,9
EXCLUDES=/root/.borgexcludes
# derived information
export BORG_CACHE_DIR=/root/.cache/borg/
USERID=`id -u $USER`

borg create -v --stats                      \
	--compression $COM PRESSION              \
	$REPOSITORY::'{hostname}-{now:%Y-%m-%d}'\
	/ \
	--exclude-from $EXCLUDES

if [[ $? == 0 ]]; then
        MSG="Backup success "
	echo $MSG | systemd-cat --identifier "borgbackup" --priority "info"
        ICON=document-send
else
        MSG="Backup failed! See the system log for more information."
	echo $MSG | systemd-cat --identifier "borgbackup" --priority "crit"
        ICON=dialog-warning
fi
sudo -u $USER DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USERID/bus notify-send 'BorgBackup' "$MSG" --icon=$ICON

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machine's archives also.
borg prune -v $REPOSITORY --prefix '{hostname}-' \
--keep-daily=7 --keep-weekly=4 --keep-monthly=6
