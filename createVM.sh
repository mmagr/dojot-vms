#!/bin/bash


cat > /tmp/dojot_install.sh <<EOF
#!/bin/bash -x

# docker
apt-get install -y \
  apt-transport-https ca-certificates curl gnupg2 \
  software-properties-common python sudo

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    \$(lsb_release -cs) \
    stable"
apt-get update
apt-get install -y docker-ce

# docker compose
curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-\$(uname -s)-\$(uname -m) > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# download release
mkdir -p /opt/${1}
cd /opt/${1}
repo="https://github.com/dojot/docker-compose/archive/${1}.tar.gz"
wget -O- \$repo | tar zxf -

EOF

cat > /tmp/dojot.init.sh  <<EOF
# configure user
useradd -m -p "" -G "docker,sudo" dojot
chage -d 0 dojot

# pull images
cd /opt/${1}/docker-compose-${1}
/usr/local/bin/docker-compose pull
/usr/local/bin/docker-compose up
# give the services some time to boot
sleep 60
./kong.config.sh
./create.user.sh

EOF
chmod +x /tmp/dojot.init.sh

virt-builder debian-9 \
             --copy-in /tmp/dojot.init.sh:/opt \
             --firstboot-command '/opt/dojot.init.sh' \
             --root-password password:dojot-root \
             --hostname dojot-vm --network \
             --run /tmp/dojot_install.sh \
             -o $1.raw

# qemu-img convert -O vdi   $1.raw $1.vdi
# qemu-img convert -O vmdk  $1.raw $1.vmdk
# qemu-img convert -O qcow2 $1.raw $1.qcow2
# qemu-img convert -O vhd   $1.raw $1.vhd
