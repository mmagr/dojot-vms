#!/bin/bash

# docker
apt-get install -y \
  apt-transport-https ca-certificates curl gnupg2 \
  software-properties-common python sudo

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"
apt-get update
apt-get install -y docker-ce

# docker compose
curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-$(uname -s)-$(uname -m) > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# download release
# TODO: version should come as an argument
vsn='0.1.0-dojot-RC2'
mkdir -p /opt/${vsn}
cd /opt/${vsn}
repo="https://github.com/dojot/docker-compose/archive/${vsn}.tar.gz"
wget -O- $repo | tar zxf -

# pull images
cd /opt/${vsn}/docker-compose-${vsn}
/usr/local/bin/docker-compose pull
/usr/local/bin/docker-compose up -d
# give the services some time to boot
sleep 90
./kong.config.sh
./create.user.sh
