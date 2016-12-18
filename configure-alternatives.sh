#!/bin/bash

if [ -z "$1" ]; then
    echo "usage: $0 version" 1>&2
    exit 1
fi

if [ ! -f "/usr/bin/gcc-$1" ]; then
    echo "/usr/bin/gcc-$1 not installed" 1>&2
    exit 1
fi

if [ ! -f "/usr/bin/g++-$1" ]; then
    echo "/usr/bin/g++-$1 not installed" 1>&2
    exit 2
fi

if ! sudo update-alternatives --list gcc; then
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8
fi
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${1} 50 --slave /usr/bin/g++ g++ /usr/bin/g++-${1}
sudo update-alternatives --set gcc /usr/bin/gcc-${1}
sudo update-alternatives --list gcc 

