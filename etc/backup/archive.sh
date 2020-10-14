#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

echo "#### $(date) --- backup archiv start;  ####"

if [ ! -d "$tmp_backup_source" ]; then
  mkdir $tmp_backup_source
else
  rm -r $tmp_backup_source/*
fi

echo "$(date) --- create a archive of backup"

# the archive from the backup directory will be created
tar -cf $tmp_backup_source/"$(hostname)-$(date '+%Y-%m-%d').tar.gz" $backup_source

echo "$(date) --- crypt the archive"

# encrpt the backup
gpg --batch --yes --trust-model always -r $mail_gnupg_id -e "$(hostname)-$(date '+%Y-%m-%d').tar.gz"

echo "$(date) --- send the archive to cloud"

# check mount point and copy backup to cloud
if [[ $(grep -qs "$magenta_mount" /proc/mounts) ]]; then
  rm $magenta_mount/backup/$(hostname)*
  cp /tmp/backup/* $magenta_mount/backup/
else
  mount $magenta_mount
  rm $magenta_mount/backup/$(hostname)*
  cp /tmp/backup/* $magenta_mount/backup/
fi

echo "clean tmp files"
if [[ -d "$tmp_backup_source" ]]; then
  rm $tmp_backup_source/*
fi

echo "$(date) --- archiv backup finished"
