# mongodb-builder
Vagrant box builders for mongodb

**Note:** None of the boxes come up automatically on a `vagrant up` to avoid tons of machines getting instantiated at the same time.

## Boxes
1. Centos-72 (centos72)
Box can build up to v3.2 at the moment.  v3.4 requires gcc/g++ > 5.3.

1. Ubuntu-14.04 (trusty)
Box can build up to v3.4

## Build steps
The source is placed under `~vagrant/mongo` by default with the master branch checked out.  Prior to building make sure you checkout the source is at the proper level

e.g. Build latest v3.4 mongod **only**
```
cd ~vagrant/mongo
git checkout v3.4
scons
```

See the official [MongoDB Build Guide](https://github.com/mongodb/mongo/blob/master/docs/building.md)
