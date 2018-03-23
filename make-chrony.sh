#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root (e.g. sudo $0)"
    exit
fi

apt-get update
apt-get -y install chrony

sed -i "\@^server 169.254.169.123 prefer iburst@d" /etc/chrony/chrony.conf
PATTERN="`grep '^\(pool\|server\).*$' /etc/chrony/chrony.conf |head -1`"
sed -i "s/^\(${PATTERN}\)$/server 169.254.169.123 prefer iburst\n\1/" /etc/chrony/chrony.conf
/etc/init.d/chrony restart
chronyc sources -v
