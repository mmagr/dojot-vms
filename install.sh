#!/bin/bash -x

# docker
apt-get install -y \
    apt-transport-https ca-certificates curl
    python software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /tmp/docker.gpg
apt-key add /tmp/docker.gpg
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce

# docker compose
curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# download release
mkdir -p /opt/${1}
cd /opt/${1}
repo="https://github.com/dojot/docker-compose/archive/${1}.tar.gz"
wget -O- $repo | tar zxf -

# pull images
docker-compose pull
docker-compose up

# give the services some time to boot
sleep 30
./kong.config.sh
./create.user.sh
