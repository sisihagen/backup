#!/usr/bin/env bash
### created 11.10.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

# https://www.strato.de/cloud-speicher/
# more information you found in docs/strato.md

echo "#### $(date) --- backup hidrive start;  ####"

if [[ "$borg-init-hidrive" = yes ]]; then
  ### check hidrive is mounted
  if [[ $(grep -qs "$hidrive_mount" /proc/mounts) ]]; then
    # run the backup to Strato HiDrive
    borg_create $hidrive_mount
  else
    # mount the HiDrive
    mount $hidrive_mount

    # create the backup to Strato HiDrive
    borg_create $hidrive_mount
  fi

else
  if [[ $(grep -qs "$hidrive_mount" /proc/mounts) ]]; then
    # init the borg repo /mnt/hidrive/hostname
    borg_init $hidrive_mount
    sed -i "s|borg-init-hidrive='no'|borg-init-hidrive='yes'|g" /usr/local/etc/monitor/config.sh

    # run the backup to Strato HiDrive
    borg_create $hidrive_mount
  else
    # mount the HiDrive
    mount $hidrive_mount

    # init the borg repo /mnt/hidrive/hostname
    borg_init $hidrive_mount
    sed -i "s|borg-init-hidrive='no'|borg-init-hidrive='yes'|g" /usr/local/etc/monitor/config.sh

    # create the backup to Strato HiDrive
    borg_create $hidrive_mount
  fi
fi

echo "#### $(date) --- backup hidrive end;  ####"
