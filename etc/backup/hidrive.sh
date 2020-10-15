#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

# https://www.strato.de/cloud-speicher/
# fill the BORG_PASSPHRASE in /usr/local/etc/backup/config.sh
# activate the hidrive with hidrive=yes > /usr/local/etc/backup/config.sh
# hidrive_user > /usr/local/etc/backup/config.sh

echo "#### $(date) --- backup hidrive start;  ####"

if [[ "$borg_init_hidrive" = yes ]]; then
  ### check hidrive is mounted
  if [[ ! $(mountpoint -q $hidrive_mount) ]]; then
    export BORG_PASSPHRASE="$BORG_PASSPHRASE"
    borg create $hidrive_mount/users/$hidrive_user/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source

  else
    # mount the HiDrive
    mount $hidrive_mount

    # create the backup to Strato HiDrive
    borg create $hidrive_mount/users/$hidrive_user/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source
  fi

else

  if [[ ! $(mountpoint -q $hidrive_mount) ]]; then
    # init the borg repo /mnt/hidrive/hostname

    # export the key you have to write to file /usr/local/etc/backup/config.sh
    export BORG_PASSPHRASE="$BORG_PASSPHRASE"

    # create the folder for borg init
    mkdir -pv $hidrive_mount/users/$hidrive_user/backup/$(hostname -s)

    # run borg init
    borg init -e repokey $hidrive_mount/users/$hidrive_user/backup/$(hostname -s)

    # write to config that repo is init
    sed -i "s|borg_init_hidrive='no'|borg_init_hidrive='yes'|g" /usr/local/etc/backup/config.sh

    # create the backup to Strato HiDrive
    borg create $hidrive_mount/users/$hidrive_user/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source

  else
    # mount the HiDrive
    mount $hidrive_mount

    # export the key you have to write to file /usr/local/etc/backup/config.sh
    export BORG_PASSPHRASE="$BORG_PASSPHRASE"

    # create the folder for borg init
    mkdir -pv $hidrive_mount/users/$hidrive_user/backup/$(hostname -s)

    # run borg init
    borg init -e repokey $hidrive_mount/users/$hidrive_user/backup/$(hostname -s)

    # write to config that repo is init
    sed -i "s|borg_init_hidrive='no'|borg_init_hidrive='yes'|g" /usr/local/etc/backup/config.sh

    # create the backup to Strato HiDrive
    borg create $hidrive_mount/users/$hidrive_user/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source
  fi
fi

echo "#### $(date) --- backup hidrive end;  ####"
