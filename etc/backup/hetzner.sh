#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

# https://www.hetzner.de/storage/storage-box
# fill the BORG_PASSPHRASE in /usr/local/etc/backup/config.sh
# activate Hetzner Storage with hetzner='yes' > /usr/local/etc/backup/config.sh

echo "#### $(date) --- backup hetzner start;  ####"

if [[ "$borg_init_hetzner" = yes ]]; then
  ### check Drive is mounted
  if [[ ! $(mountpoint -q $hetzner_mount) ]]; then
    export BORG_PASSPHRASE="$BORG_PASSPHRASE"
    borg create $hetzner_mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source

  else
    # mount the Drive
    mount $hetzner_mount

    # create the backup to  Drive
    borg create $hetzner_mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source
  fi

else

  if [[ ! $(mountpoint -q $hetzner_mount) ]]; then
    # init the borg repo /mnt/Drive/hostname

    # export the key you have to write to file /usr/local/etc/backup/config.sh
    export BORG_PASSPHRASE="$BORG_PASSPHRASE"

    # create the folder for borg init
    mkdir -pv $hetzner_mount/backup/$(hostname -s)

    # run borg init
    borg init -e repokey $hetzner_mount/backup/$(hostname -s)

    # write to config that repo is init
    sed -i "s|borg_init_hetzner='no'|borg_init_hetzner='yes'|g" /usr/local/etc/backup/config.sh

    # create the backup to  Drive
    borg create $hetzner_mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source

  else
    # mount the Drive
    mount $hetzner_mount

    # export the key you have to write to file /usr/local/etc/backup/config.sh
    export BORG_PASSPHRASE="$BORG_PASSPHRASE"

    # create the folder for borg init
    mkdir -pv $hetzner_mount/backup/$(hostname -s)

    # run borg init
    borg init -e repokey $hetzner_mount/backup/$(hostname -s)

    # write to config that repo is init
    sed -i "s|borg_init_hetzner='no'|borg_init_hetzner='yes'|g" /usr/local/etc/backup/config.sh

    # create the backup to  Drive
    borg create $hetzner_mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source
  fi
fi

echo "#### $(date) --- backup hetzner end;  ####"
