#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

source /usr/local/etc/backup/variables.sh
source /usr/local/etc/backup/config.sh
source /usr/local/etc/backup/function.sh

### activate logfile
exec >> $LOG 2>&1 && tail $LOG

echo "#### $(date) - Backup start; ####"

if [[ -f "$LOG" ]]; then
  truncate -s 0 $LOG
fi

echo "#### $(date) - clear the backup folder; ####"

if [[ -d "$backup_source" ]] ; then
  if [[ "$(ls -A $backup_source)" ]]; then
    rm -r $backup_source/*
  fi
fi

echo "#### $(date) - create backup folder; ####"

### first make the backup from source to target
### source folders
readarray -t source < $folder/$source

### target folders
readarray -t target < $folder/$target

# run through the target array and create folders
for d in "${target[@]}"; do

  # check if folder exists and when not create it
  if [[ ! -d "$d" ]]; then
    mkdir -p "$d"
  fi
done

echo "$(date) - sync the folders from source to target"

# sync the the backup
for ((i=0;i<${#source[@]};++i)); do
    rsync -avq "${source[i]}/" "${target[i]}/"
done

echo "$(date) - save source and target file"

if [[ -d $backup_source/etc ]]; then

  # copy source.txt and target.txt to backup folder
  for txt in $(ls $folder/*.txt); do
    cp $txt $backup_source/etc
  done

  if [[ $mysql = "yes" ]]; then
    mysqldump -u root --all-databases --result-file=$backup_source/databases.sql
  fi

  if [[ -f "/etc/arch-release" ]]; then
    pacman -Qqe > $backup_source/etc/pkglist.txt
  fi

  if [[ -f "/etc/debian_version"  ]]; then
    dpkg-query -f '${binary:Package}\n' -W > $backup_source/etc/pkglist.txt
  fi

else

  mkdir -p $backup_source/etc

  # copy source.txt and target.txt to backup folder
  for txt in $(ls $folder/*.txt); do
    cp $txt $backup_source/etc
  done

  if [[ $mysql = "yes" ]]; then
    mysqldump -u root --all-databases --result-file=$backup_source/databases.sql
  fi

  if [[ -f "/etc/arch-release" ]]; then
    pacman -Qqe > $backup_source/etc/pkglist.txt
  fi

  if [[ -f "/etc/debian_version"  ]]; then
    dpkg-query -f '${binary:Package}\n' -W > $backup_source/etc/pkglist.txt
  fi
fi

echo "$(date) - save the backup to cloud"

if [[ "$hetzner" = yes ]]; then
  source /usr/local/etc/backup/hetzner.sh
fi

if [[ "$hidrive" = yes ]]; then
  source /usr/local/etc/backup/hidrive.sh
fi

if [[ "$netcup" = yes ]]; then
  source /usr/local/etc/backup/netcup.sh
fi

if [[ "$archive" = yes ]]; then
  source /usr/local/etc/backup/archive.sh
fi

echo "$(date) - send mail when is activate"

if [[ $mutt = yes ]]; then
  mutt -s 'Backup $(hostname)' $recipient < "Backup had run" -a /var/log/backup/backup.log
fi

if [[ $mpack = yes ]]; then
  /usr/bin/mpack -s "Backup $(hostname)" /var/log/backup/backup.log $recipient
fi

if [[ $local = yes ]]; then
  (echo Subject: Backup, $(hostname) ; echo; cat /var/log/backup/backup.log) | sendmail -i -f backup@$(hostname) $recipient
fi

echo "$(date) - clean backup dir"
if [[ -d "$backup_source" ]]; then
  rm -r $backup_source
fi

echo "$(date) - backup finished"
