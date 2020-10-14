# A simple Backup Script


I use it for my Server and write the backups as file and on Webdav Server. To install it run install.sh.

To use this script special the cloud way you need to install davfs and borg. You can also use rsync with usb drive and a archive file copy by yourself to other save place.

On Debian

```bash
apt install davfs2 borgbackup
```

On Arch

```bash
apt install davfs2 borg
```

On Gentoo:

```bash
emerge -av davfs2 borg
```

To work easy with mount points you should write the mount points and login information to a file.

```bash
nano /etc/davfs2/secrets
https://mywebdav.mycloud.com username password
```

```bash
nano /etc/fstab
https://webdav.magentacloud.de/   /mnt/m-cloud  davfs rw,user,noauto 0 0
```

I use this script for me that's why I have Netcup, Strato, Hetzner and Telekom Cloud. If you have other you can use it so long the Provider accept webdav.

If you have Question for it or you know to fix some points, make it smarter, then contact me.
