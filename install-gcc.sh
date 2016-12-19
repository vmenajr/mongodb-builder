#!/bin/bash
function abend() {
  echo "Abend: $@"
  exit -1
}

# Build folder
BUILD=${1}
echo
echo "Build Folder: ${BUILD}"
echo
cd ${BUILD} || abend "Cannot access ${BUILD} build folder..."
make install-strip

# gcc installs .so files in /usr/local/lib64...
echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf
ldconfig -v || abend "Failed to rebuild ld cache"

# Install alternatives
rm -f /bin/gcc /bin/g++
alternatives --verbose --install /bin/g++ g++ /usr/local^Cin/gcc 10 --slave /bin/g++ g++ /usr/bin/g++
alternatives --verbose --install /bin/gcc gcc /usr/local/bin/gcc 20 --slave /bin/g++ g++ /usr/local/bin/g++


# ensure that alternatives are pointing to the new compiler and that old one is no longer used
#dpkg-divert --divert /usr/bin/gcc.orig --rename /usr/bin/gcc
#dpkg-divert --divert /usr/bin/g++.orig --rename /usr/bin/g++
#update-alternatives --install /usr/bin/cc cc /usr/local/bin/gcc 999

#Libraries have been installed in:
   #/usr/local/lib/../lib64

#If you ever happen to want to link against installed libraries
#in a given directory, LIBDIR, you must either use libtool, and
#specify the full pathname of the library, or use the `-LLIBDIR'
#flag during linking and do at least one of the following:
   #- add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     #during execution
   #- add LIBDIR to the `LD_RUN_PATH' environment variable
     #during linking
   #- use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   #- have your system administrator add LIBDIR to `/etc/ld.so.conf'

#See any operating system documentation about shared libraries for
#more information, such as the ld(1) and ld.so(8) manual pages.


echo "Success"

