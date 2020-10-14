#!/usr/bin/env bash
### created 28.06.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

folder='/usr/local/etc/backup'

# cloud soulution
hidrive_mount='/mnt/hidrive'
magenta_mount='/mnt/magenta'
hetzner_mount='/mnt/hetzner'
netcup_mount='/mnt/netcup'

# usb sticks
usb='/mnt/backup'

# backup
source='source.txt'
target='target.txt'
backup_source='/backup'
tmp_backup_source='/tmp/backup'

# logging
hidrive_log='/var/log/backup/hidrive.log'
magenta_log='/var/log/backup/magenta.log'
hetzner_log='/var/log/backup/hetzner.log'
netcup_log='/var/log/backup/netcup.log'
archiv_log='/var/log/backup/archiv.log'
usb_log='/var/log/backup/usb.log'
