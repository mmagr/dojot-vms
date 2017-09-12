#!/bin/bash

# download release
mkdir -p /opt/${1}
cd /opt/${1}
repo="https://github.com/dojot/docker-compose/archive/${1}.tar.gz"
wget -O- $repo | tar zxf -


cd /opt/${1}/docker-compose-${1}
/usr/local/bin/docker-compose pull
