#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

source /usr/local/etc/backup/variables.sh
source /usr/local/etc/backup/function.sh

### logfile
LOG="/var/log/backup/backup.log"

### activate logfile
exec >> $LOG 2>&1 && tail $LOG

if [[ -f "/var/log/backup.log" ]]; then
        truncate -s 0 $LOG
fi

echo "#### $(date) - Backup start; ####"

### first make the backup from source to target
### source folders
readarray -t source < /etc/source.txt

### target folders
readarray -t target < /etc/target.txt

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
    rsync -avu -delete "${source[i]}/" "${target[i]}/"
done

echo "$(date) - save source and target file"
if [[ -d "$backup_dir/etc" ]]; then
  cp /etc/source.txt $backup_dir/etc/source.txt
  cp /etc/target.txt $backup_dir/etc/target.txt

  if [[ $mysql = "yes" ]]; then
    mysqldump -u root --all-databases --result-file=$backup_dir/databases.sql
  fi

  if [[ -f "/etc/arch-release" ]]; then
    pacman -Qqe > /backup/etc/pkglist.txt
  fi

  if [[ -f "/etc/debian_version"  ]]; then
    dpkg-query -f '${binary:Package}\n' -W > /backup/etc/pkglist.txt
  fi
else
  mkdir -p /backup/etc
  cp /etc/source.txt $backup_dir/etc/source.txt
  cp /etc/target.txt $backup_dir/etc/target.txt

  if [[ $mysql = "yes" ]]; then
    mysqldump -u root --all-databases --result-file=$backup_dir/databases.sql
  fi

  if [[ -f "/etc/arch-release" ]]; then
    pacman -Qqe > /backup/etc/pkglist.txt
  fi

  if [[ -f "/etc/debian_version"  ]]; then
    dpkg-query -f '${binary:Package}\n' -W > /backup/etc/pkglist.txt
  fi
fi

echo "$(date) - save the backup to webdav mounts"

if [[ "$hetzner" = yes ]]; then
  source /usr/local/etc/backup/hetzner.sh
fi

if [[ "$hidrive" = yes ]]; then
  source /usr/local/etc/backup/magenta.sh
fi

if [[ "$netcup" = yes ]]; then
  source /usr/local/etc/backup/netcup.sh
fi

if [[ "$archive" = yes ]]; then
  source /usr/local/etc/backup/archive.sh
fi

echo "$(date) - backup finished"

if [[ $mutt = yes ]]; then
  mutt -s 'Backup $(hostname)' $recipient < "Backup had run" -a /var/log/backup/backup.log
fi

if [[ $mpack = yes ]]; then
  /usr/bin/mpack -s "Backup $(hostname)" /var/log/backup/backup.log $recipient
fi

if [[ $local = yes ]]; then
  (echo Subject: Backup, $(hostname) ; echo; cat /var/log/backup/backup.log) | sendmail -i -f backup@$(hostname) $recipient
fi
