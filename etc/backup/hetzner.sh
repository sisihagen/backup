#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

# https://www.hetzner.de/storage/storage-box
# more information you found in docs/hetzner.md

echo "#### $(date) --- backup hetzner start;  ####"

if [[ "$borg-init-hetzner" = yes ]]; then
  ### check hetzner is mounted
  if [[ $(grep -qs "$hetzner_mount" /proc/mounts) ]]; then
    # run the backup to Strato hetzner
    borg_create $hetzner_mount
  else
    # mount the hetzner
    mount $hetzner_mount

    # create the backup to Strato hetzner
    borg_create $hetzner_mount
  fi
else
  if [[ $(grep -qs "$hetzner_mount" /proc/mounts) ]]; then
    # init the borg repo /mnt/hetzner/hostname
    borg_init $hetzner_mount
    sed -i "s|borg-init-hetzner='no'|borg-init-hetzner='yes'|g" /usr/local/etc/monitor/config.sh

    # run the backup
    borg_create $hetzner_mount
  else
    # mount
    mount $hetzner_mount

    # init the borg repo /mnt/hetzner/hostname
    borg_init $hetzner_mount
    sed -i "s|borg-init-hetzner='no'|borg-init-hetzner='yes'|g" /usr/local/etc/monitor/config.sh

    # create the backup
    borg_create $hetzner_mount
  fi
fi

echo "#### $(date) --- backup hetzner end;  ####"
