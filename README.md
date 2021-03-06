dojot virtual machine image generator
=====================================

This repository contains scripts used to automatically generate virtual machine images
for releases of dojot.

Dependencies
------------

To use them, one must have libguestfs-tools (virt-builder) and qemu-utils (qemu-img) available.
Those scripts have been tested on a fedora 26 environment.

```shell
sudo yum install -y libguestfs-tools libvirt
sudo reboot  # make sure libvirt is properly initialized
```


Running
-------


To generate a set of virtual machines based on a given release of dojot, run the following:

```shell
./createVM <release name>
```

All debian-based generated images have a default `dojot` user configured. The password for this
user should be set on the first login.

Should there be any need to use the root user, its default password is `dojot-root`.
