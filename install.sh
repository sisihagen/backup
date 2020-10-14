#!/usr/bin/env bash
### created 14.10.2020
### Silvio Siefke <siefke@mail.ru>
### Simple Public License (SimPL)

echo "You want install the scipt and had read the Readme? yes|no"
read -r install

if [[ "$install" = yes ]]; then
  if [[ $EUID -ne 0  ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
  else
    echo "I need path to install? /usr/local/etc/backup"
    read -r path

    if [[ -z "$path" ]]; then
      echo "I need a path!"
      exit 1
    else
      # create path
      mkdir -pv /usr/local/etc/backup
      mkdir -pv /var/log/backup

      # install the shell scripts
      for files in $(ls ./etc/backup/*.sh); do
        install -D -m 755 -o root $files $path
      done

      # install source, target and backup script
      install -D -m 644 -o root ./etc/backup/source.txt $path
      install -D -m 644 -o root ./etc/backup/target.txt $path
      install -D -m 755 -o root ./bin/backup.sh /usr/local/bin

      ### user ask for using systemd
      echo "your system using systemd yes|no"
      read -r systeminit

      if [[ "$systeminit" = yes ]]; then
        install -D -m 644 -o root ./etc/systemd/system/backup.timer /etc/systemd/system
        install -D -m 644 -o root ./etc/systemd/system/backup.service /etc/systemd/system
        systemctl daemon-reload
      fi

      # activate
      echo "You now need to fill up the variables.sh in $path!"
      echo "You need to activate the systemd files then."
      echo "systemctl enable --now backup.timer"
    fi
  fi
fi
