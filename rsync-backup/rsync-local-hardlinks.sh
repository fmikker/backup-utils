#!/bin/bash
date=`date "+%Y-%m-%dT%H_%M_%S"`
SRCFOLDERS="/root /home /etc/letsencrypt"
for folder in $SRCFOLDERS; do
  BACKUPDIR=/backup/rsync${folder}
  rsync -az \
              --exclude-from=/root/homebackup_rsync.exclude \
              --link-dest=${BACKUPDIR}/current \
              $folder/ ${BACKUPDIR}/$date
  if [ $? -eq 0 ]; then
    rm ${BACKUPDIR}/current
    ln -s ${BACKUPDIR}/$date ${BACKUPDIR}/current
    oldbackups=`/bin/ls -1 ${BACKUPDIR} | sort -nr | grep -v '\.' | grep -v current | tail -n+9` #+9 keeps the latest 8 backups
    for dir in $oldbackups; do
        rm -r --one-file-system ${BACKUPDIR}/$dir
    done
  fi
done

# If backup fails, for example because someone puts a lot of files in /root
# remove the "broken" backup folders in /backup/rsync/{home,root} and
# link the last OK backup to current (ln -s <folder> current)
