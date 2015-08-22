Simple script to do a local database backup of a owncloud instance, to be fetched later by the system backup (In this case Bacula).

Intended for a Owncloud instance running in CentOS 7 with systemd, which utilizes the internal journal instead of log files by pipe-ing to systemd-cat, which is sent to a central syslog server (op5 Logger).

Usage:

1. Copy owncloud-db-backup.sh to a suitable folder for binaries (/root/bin/ in my case)
	1.2: Change the settings in the script to correspond to your user, password and database name.
2. Use the cron file supplied and put it in /etc/cron.daily/
3. Test the functinality by using run-parts:
	# run-parts /etc/cron.daily/ -v
4. Monitor your system journal to confirm that the log messages is written:
	# journalctl -f 
