concourse-ec2
## Simple script to deploy Concourse-CI on an EC2 (Ubuntu 16.04) instance

The following instructions bring together parts from Pivotal's Concourse CI AMI, and Digital Ocean's Concourse CI setup guide. It assumes that SSL is terminated at a load-balancer (e.g. AWS ELB) or that other software (HA-Proxy + Let's Encrypt) will be used but are not covered here.

This is a public repository and no secrets are kept here. All installation specific information is set as **User Data** on the EC2 instance.

### Create an EC2 instance (recommend one with local SSDs for ConcourseCI performance)

Select AMI: Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
(m3.large 1x32 SSD)

#### Configure Instance Details

During EC2 instance creation, you must expand the 'Advanced Details' section and enter customized 'User Data'. The following items should be chosen specifically for your installation:

- hostname (this is the web host name for accessing concourse UI)
- password (for the 'ci' user)
- concourse_db_url (for the PostgreSQL database, often RDS) which has the following parts:
  - 'concourse' (default db username)
  - 'password' the password for the db user
  - 'test-concourse' the name of the RDS database
  - an aws account specific part of the RDS database URL
- concourse_binary_url (the version of the 'concourse' binary executable to download)
- fly_binary_url (for the matching version of the 'fly' binary executable)

The Concourse CI downloadable binary versions are at https://concourse-ci.org/downloads.html


#### Advanced Details (User Data):
```
hostname: <dns-name-of-concourse-host-or-elb>
username: ci
password: <choose-your-password>
concourse_db_url: postgres://concourse:password@test-concourse.<specific-to-your-aws-account>.us-east-1.rds.amazonaws.com:5432/concourse
concourse_binary_url: https://github.com/concourse/concourse/releases/download/v3.9.2/concourse_linux_amd64
fly_binary_url: https://github.com/concourse/concourse/releases/download/v3.9.2/fly_linux_amd64
```

#### Security Group:

Should allow Inbound:
- ssh (TCP port 22)
- TCP port 8080 (from load balancer, reverse-proxy, or restricted access to concourse web app)
- TCP port 443 (if setting up SSL on same host)

### Procedure

Note that the following procedure is for use on a freshly created EC2 instance.

**WARNING**: On dual-SSD systems, existing `/dev/xvdb` and `/dev/xvdc` volumes will be initialized as `RAID0` without prompting!

```bash
sudo su
curl -sL -o download-files.sh 'https://rawgit.com/helpful-com/concourse-ec2/master/download-files.sh'
chmod a+x download-files.sh

./download-files.sh

./make-chrony.sh
./make-ssd-fs.sh
./make-concourse.sh

reboot
```

Once rebooted, open web browser to the 'hostname' url.
