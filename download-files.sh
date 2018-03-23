#!/bin/bash

for file in make-chrony.sh make-ssd-fs.sh make-concourse.sh etc/systemd/system/concourse-web.service etc/systemd/system/concourse-worker.service etc/systemd/system/concourse-bootstrap-fly.service opt/concourse/bin/_userdata.sh opt/concourse/bin/concourse-web opt/concourse/bin/concourse-worker opt/concourse/bin/extract_yaml_key opt/concourse/bin/fly-bootstrap opt/concourse/etc/host_key opt/concourse/etc/host_key.pub init/concourse-bootstrap-fly.conf opt/concourse/etc/session_signing_key opt/concourse/etc/session_signing_key.pub opt/concourse/etc/worker_key opt/concourse/etc/worker_key.pub; do
  echo "Downloading $file"
# curl -sL --create-dirs -o $file "https://cdn.rawgit.com/helpful-com/concourse-ec2/master/$file"
  curl -sL --create-dirs -o $file "https://rawgit.com/helpful-com/concourse-ec2/master/$file"
  if [[ "$file" == *.sh ]] || [[ "$file" == */bin/* ]]; then
    chmod a+x $file
  fi
done
