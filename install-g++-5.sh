#!/bin/bash
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get -y update
apt-get -y install gcc-5 g++-5
/vagrant/configure-alternatives.sh 5

