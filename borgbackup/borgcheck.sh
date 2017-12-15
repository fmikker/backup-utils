#!/bin/sh
# Borg cron backup script with desktop notifications
# Meant to be run as root
#
# Copyright (C) 2016 Olivier Bilodeau
# Licensed under the MIT License

# configuration
USER=root
export BORG_PASSPHRASE='password'
REPOSITORY=backup@:root-disk
COMPRESSION=zlib,9
EXCLUDES=/root/.borgexcludes
# derived information
export BORG_CACHE_DIR=/root/.cache/borg/

borg check -v --show-rc $REPOSITORY

if [[ $? == 0 ]]; then
        logger -t borgbackup -p info "Borg repository check successfully completed"
else
        logger -t borgbackup -p error "Borg repository check failed!"
fi

