#!/usr/bin/env bash
### created 28.06.2020 ###
### Silvio Siefke <siefke@mail.ru> ###
### Simple Public License (SimPL) ###

folder='/usr/local/etc/backup'

# cloud soulution
hidrive_mount='/mnt/hidrive'
magenta_mount='/mnt/m-cloud'
hetzner_mount='/mnt/hetzner'
netcup_mount='/mnt/netcup'

# usb sticks
usb='/mnt/backup'

# backup
source='source.txt'
target='target.txt'
backup_source='/tmp/backup'
tmp_backup_source='/tmp/backup'

# logging
LOG="/var/log/backup/backup.log"
hidrive_log='/var/log/backup/hidrive.log'
hetzner_log='/var/log/backup/hetzner.log'
netcup_log='/var/log/backup/netcup.log'
archiv_log='/var/log/backup/archiv.log'

