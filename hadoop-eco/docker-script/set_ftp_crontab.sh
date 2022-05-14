#!/bin/sh

crontab -l > mycron
echo "* * * * * cd $1; make ftp-download >/dev/null 2>&1" >> mycron
crontab mycron
rm mycron
