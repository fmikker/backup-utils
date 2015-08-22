#!/bin/bash 
mysqldump --lock-tables -u <INSERT USERNAME> -p<INSERT PASSWORD> owncloud_data > /owncloud/backup/owncloud-sqlbkp_`date +"%Y%m%d"`.bak

if [ $? -eq 0 ]

	then

echo "Owncloud database backup successful" | systemd-cat --identifier "owncloud-db-backup" --priority "info"

exit 0

	else

echo "Owncloud database backup failed!" | systemd-cat --identifier "owncloud-db-backup" --priority "warn"

exit 1

fi
