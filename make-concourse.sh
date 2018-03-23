#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root (e.g. sudo $0)"
    exit
fi

apt-get update
apt-get -y install python-minimal python-yaml unzip

# install
mkdir -p /opt/concourse/bin
mkdir -p /opt/concourse/etc
cp -p opt/concourse/bin/* /opt/concourse/bin/
cp -p opt/concourse/etc/* /opt/concourse/etc/

source /opt/concourse/bin/_userdata.sh

curl -s -L -o concourse "$CONCOURSE_BINARY_URL"
curl -s -L -o fly "$FLY_BINARY_URL"
chmod a+x concourse
chmod a+x fly
cp -p concourse /opt/concourse/bin/
cp -p fly /opt/concourse/bin/

cp -p etc/systemd/system/concourse-web.service /etc/systemd/system/
cp -p etc/systemd/system/concourse-worker.service /etc/systemd/system/
cp -p etc/systemd/system/concourse-bootstrap-fly.service /etc/systemd/system/

systemctl --system daemon-reload
systemctl enable concourse-web
systemctl enable concourse-worker
systemctl enable concourse-bootstrap-fly

adduser --system --group concourse
chown -R concourse:concourse /opt/concourse

update-initramfs -u
