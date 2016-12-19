#!/bin/bash
function abend() {
  echo "Abend: $@"
  exit -1
}

# Build folder
TEMP=${1}
if [ -z ${TEMP} ]; then
  TEMP=$(mktemp -d) || abend "Error creating a temporary build folder"
fi
if [ ! -d ${TEMP} ]; then
  mkdir -p ${TEMP}
fi


# Build dependencies
BUILD_DEPS="flex-devel.x86_64"

# "download_prerequisites" pulls down a bunch of tarballs and extracts them,
# but then leaves the tarballs themselves lying around
yum -y install ${BUILD_DEPS} || abend "Error installing dependencies: ${BUILD_DEPS}"

# Build temporary folder
cd ${TEMP} || abend "Cannot enter ${TEMP}"
echo
echo "Temp Folder: ${TEMP}"
echo
/usr/src/gcc/configure --disable-multilib --enable-languages=c,c++ || abend "Cannot configure build"
make -j"$(nproc)" || abend "Build failed"

echo "Success: ${TEMP}"
echo
