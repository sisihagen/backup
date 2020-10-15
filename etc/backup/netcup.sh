#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

# https://www.netcup.de/vserver/vstorage.php
# fill the BORG_PASSPHRASE in /usr/local/etc/backup/config.sh
# activate the Netcup Storage with netcup=yes > /usr/local/etc/backup/config.sh

eecho "#### $(date) --- backup netcup start;  ####"

if [[ "$borg_init_netcup" = yes ]]; then
  ### check Drive is mounted
  if [[ ! $(mountpoint -q $hetzner_mount) ]]; then
    export BORG_PASSPHRASE="$BORG_PASSPHRASE"
    borg create $netcup_mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source

  else

    # mount the Drive
    mount $hetzner_mount

    # create the backup to Drive
    borg create $netcup_mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source
  fi

else

  if [[ ! $(mountpoint -q $hetzner_mount) ]]; then
    # export the key you have to write to file /usr/local/etc/backup/config.sh
    export BORG_PASSPHRASE="$BORG_PASSPHRASE"

    # create the folder for borg init
    mkdir -pv $netcup_mount/backup/$(hostname -s)

    # run borg init
    borg init -e repokey $netcup_mount/backup/$(hostname -s)

    # write to config that repo is init
    sed -i "s|borg_init_netcup='no'|borg_init_netcup='yes'|g" /usr/local/etc/backup/config.sh

    # create the backup to Drive
    borg create $netcup_mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source

  else
    # mount the Drive
    mount $hetzner_mount

    # export the key you have to write to file /usr/local/etc/backup/config.sh
    export BORG_PASSPHRASE="$BORG_PASSPHRASE"

    # create the folder for borg init
    mkdir -pv $netcup_mount/backup/$(hostname -s)

    # run borg init
    borg init -e repokey $netcup_mount/backup/$(hostname -s)

    # write to config that repo is init
    sed -i "s|borg_init_netcup='no'|borg_init_netcup='yes'|g" /usr/local/etc/backup/config.sh

    # create the backup to Drive
    borg create $netcup_mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source
  fi
fi

echo "#### $(date) --- backup hetzner end;  ####"
