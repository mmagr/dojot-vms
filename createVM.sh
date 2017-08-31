#!/bin/bash


cat > /tmp/dojot_install.sh <<EOF
#!/bin/bash -x

# docker
apt-get install -y \
  apt-transport-https ca-certificates curl gnupg2 \
  software-properties-common python

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    \$(lsb_release -cs) \
    stable"
apt-get update
apt-get install -y docker-ce
groupadd docker

# run docker daemon, so that pulls work
start-stop-daemon --start --background --exec "/usr/bin/dockerd" -- > /dev/null 2>&1

# docker compose
curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-\$(uname -s)-\$(uname -m) > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# download release
mkdir -p /opt/${1}
cd /opt/${1}
repo="https://github.com/dojot/docker-compose/archive/${1}.tar.gz"
wget -O- \$repo | tar zxf -

# pull images
cd docker-compose-${1}
/usr/local/bin/docker-compose pull
# /usr/local/bin/docker-compose up

# give the services some time to boot
# sleep 60
# ./kong.config.sh
# ./create.user.sh
EOF

virt-builder debian-9 \
             --firstboot-command 'useradd -m -p "" -G "docker" dojot ; chage -d 0 dojot' \
             --root-password password:dojot-root \
             --hostname dojot-vm --network \
             --run /tmp/dojot_install.sh \
             -o $2
