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
if [[ -f "$tmp_backup_source/$(hostname)-$(date '+%Y-%m-%d').tar.gz" ]]; then
  gpg --batch --yes --trust-model always -r $mail_gnupg_id -e $tmp_backup_source/"$(hostname)-$(date '+%Y-%m-%d').tar.gz"
fi

if [[ -f "$tmp_backup_source/$(hostname)-$(date '+%Y-%m-%d').tar.gz.gpg" ]]; then
  rm $tmp_backup_source/"$(hostname)-$(date '+%Y-%m-%d').tar.gz"
fi

echo "$(date) --- send the archive to cloud"

# check mount point and copy backup to cloud
# I send it to magenta cloud
if [[ -f "$tmp_backup_source/$(hostname)-$(date '+%Y-%m-%d').tar.gz.gpg" ]]; then


  if [[ ! $(mountpoint -q /mnt/m-cloud) ]]; then
    # check a backup is on cloud
    if [[ $(ls $magenta_mount/backup | grep $(hostname -s)) ]]; then
      # when a backup is in cloud we delete older files
      rm $magenta_mount/backup/$(hostname)-*
    fi

    if [[ -f "$tmp_backup_source/$(hostname)-$(date '+%Y-%m-%d').tar.gz.gpg" ]]; then
      # copy new update to cloud
        mv -v "$tmp_backup_source/$(hostname)-$(date '+%Y-%m-%d').tar.gz.gpg" $magenta_mount/backup/
      fi
  else
    # cloud mounten
      mount $magenta_mount
      # run task like before
    if [[ -f "$magenta_mount/backup/$(hostname)-*" ]]; then
      # when a backup is in cloud we delete older files
      rm $magenta_mount/backup/$(hostname)-*
    fi

    if [[ -f "$tmp_backup_source/$(hostname)-$(date '+%Y-%m-%d').tar.gz" ]]; then
        # copy new update to cloud
        mv -v "$tmp_backup_source/$(hostname)-$(date '+%Y-%m-%d').tar.gz.gpg" $magenta_mount/backup/
      fi
  fi

fi

echo "$(date) --- archiv backup finished"
