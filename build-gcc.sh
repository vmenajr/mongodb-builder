#!/bin/bash
GCC_VERSION="${1:-6.2.0}"
PRIORITY=${GCC_VERSION//.}
SRC=/usr/src/gcc/${GCC_VERSION}
PREFIX=/opt/gcc/${GCC_VERSION}
DST=${PREFIX}/bin
BUILD_DEPS="flex-devel.x86_64"

function abend() {
  echo "Abend: $@"
  exit -1
}

# Build dependencies
yum -y install ${BUILD_DEPS} || abend "Error installing dependencies: ${BUILD_DEPS}"

# Temporary folder
BUILD="$(mktemp -d)" || abend "Error creating a temporary build folder"
cd "$BUILD" || abend "Cannot enter $BUILD"

# Build
echo "Building ${BUILD}..."
${SRC}/configure --prefix=${PREFIX} --disable-multilib --enable-languages=c,c++ || abend "Cannot configure build"
make -j"$(nproc)" || abend "Build failed"
echo "Build Success: ${BUILD}"
echo

# Install
echo "Installing to ${PREFIX}..."
make install-strip

# gcc installs .so files in /usr/local/lib64...
echo "${PREFIX}/lib64" > /etc/ld.so.conf.d/local-lib64.conf
ldconfig -v || abend "Failed to rebuild ld cache"

# Install alternatives
rm -f /bin/cpp /bin/gcc /bin/g++
alternatives --verbose --install /bin/gcc gcc /usr/bin/gcc 10 --slave /bin/g++ g++ /usr/bin/g++ --slave /bin/cpp cpp /usr/bin/cpp
alternatives --verbose --install /bin/gcc gcc ${DST}/gcc ${PRIORITY} --slave /bin/g++ g++ ${DST}/g++ --slave /bin/cpp cpp ${DST}/cpp

echo
echo "Installed to ${PREFIX}..."
echo

