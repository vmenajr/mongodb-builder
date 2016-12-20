# mongodb-builder
Vagrant box builders for mongodb

**Note:** None of the boxes come up automatically on a `vagrant up` to avoid tons of machines getting instantiated at the same time.

## Required vagrant plugins
1. vagrant-reload: Restarts the box after upgrading. Not **technically** necessary but sometimes I've seen weird issues if you don't reload and this plugin makes it a no-brainer.

###
```
vagrant plugin install <name>
```

## Boxes
1. Centos-72 (centos72)
Box can build up to v3.2 with the stock compiler.  In order to build the rest we must download and compile gcc/g++ v5.4.  The box provisioners automatically download gcc/g++ v5.4 into /usr/src/gcc/5.4.0.  Execute `/vagrant/build-gcc 5.4.0` to launch a fresh build in a temp folder under /tmp and install the new compiler to /opt/gcc/5.4.0 with alternatives configured for the system to allow switching back/forth between stock and custom.

Note: The compiler build can take around 30 minutes.


1. Ubuntu-14.04 (trusty)
Box can build up to v3.4

## Build steps
The source is placed under `~vagrant/mongo` by default with the master branch checked out.  Prior to building make sure you checkout the source at the proper level

e.g. Build latest v3.4 mongod **only**
```
cd ~vagrant/mongo
git checkout v3.4
scons
```

See the official [MongoDB Build Guide](https://github.com/mongodb/mongo/blob/master/docs/building.md)
