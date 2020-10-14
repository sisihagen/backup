#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

function borg_init()
{
  # borg init -e repokey /mnt/backup
  declare path="$1"
  shift 1

  borg init -e repokey "$path/backup/$(hostname -s)"
}

function borg_create()
{
  declare mount='$1'
  shift 1

  # check passphrase is set
  if [[ -z "$BORG_PASSPHRASE" ]]; then

    # export the passphrase
    export $BORG_PASSPHRASE

    # create the backup from source file to borg:hostname:date
    borg create $mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source
  else

    # when $BORG_PASSPHRASE is not empty we run direct to update
    borg create $mount/backup/$(hostname -s)::$(date +"%Y_%m_%d") $backup_source
  fi
}
