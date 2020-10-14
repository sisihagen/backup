#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

# https://www.netcup.de/vserver/vstorage.php
# more information in docs/netcup.md

echo "#### $(date) --- backup netcup start;  ####"

if [[ "$borg-init-netcup" = yes ]]; then
  ### check netcup is mounted
  if [[ $(grep -qs "$netcup_mount" /proc/mounts) ]]; then
    # run the backup
    borg_create $netcup_mount
  else
    # mount the netcup
    mount $netcup_mount

    # run the backup
    borg_create $netcup_mount
  fi

else
  if [[ $(grep -qs "$netcup_mount" /proc/mounts) ]]; then
    # init the borg repo /mnt/netcup/hostname
    borg_init $netcup_mount
    sed -i "s|borg-init-netcup='no'|borg-init-netcup='yes'|g" /usr/local/etc/monitor/config.sh

    # run the backup
    borg_create $netcup_mount
  else
    # mount the netcup
    mount $netcup_mount

    # init the borg repo /mnt/netcup/hostname
    borg_init $netcup_mount
    sed -i "s|borg-init-netcup='no'|borg-init-netcup='yes'|g" /usr/local/etc/monitor/config.sh

    # run the backup
    borg_create $netcup_mount
  fi
fi

echo "#### $(date) --- backup netcup end;  ####"
