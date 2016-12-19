#!/bin/bash
GCC_VERSION="${1:-6.2.0}"

function abend() {
  echo "Abend: $@"
  exit -1
}

# https://gcc.gnu.org/mirrors.html
GPG_KEYS="
  B215C1633BCA0477615F1B35A5B3A004745C015A
  B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8
  90AA470469D3965A87A5DCB494D03953902C9419
  80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C
  7F74F97C103468EE5D750B583AB00996FC26A641
  33C235A34C46AA3FFB293709A328C3A2C3C45C06
"

# Build dependencies
BUILD_DEPS="flex-devel.x86_64"

# Install verification keys
for key in $GPG_KEYS; do
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || abend "Error importing keys"
done


# "download_prerequisites" pulls down a bunch of tarballs and extracts them,
# but then leaves the tarballs themselves lying around
yum -y install ${BUILD_DEPS} || abend "Error installing dependencies: ${BUILD_DEPS}"

# Download
cd /tmp
curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2" -o gcc.tar.bz2 || abend "Error downloading gcc.tar.bz2"
curl -fSL "http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2.sig" -o gcc.tar.bz2.sig || abend "Error downloading gcc.tar.bz2.sig"

# Verify signature
#rm -r /var/lib/apt/lists/* 
gpg --batch --verify gcc.tar.bz2.sig gcc.tar.bz2 || abend "Failed to verify gcc download signature"

# Extract to usr/src
mkdir -p /usr/src/gcc
tar -xf gcc.tar.bz2 -C /usr/src/gcc --strip-components=1 || abend "Failed extracting to /usr/src/gcc"
rm gcc.tar.bz2* || abend "Cannot remove gcc tar files"

# Download dependencies
cd /usr/src/gcc || abend "Cannot enter gcc folder in usr"
./contrib/download_prerequisites || abend "Failed to download dependencies"
rm *.tar.* || abend "Failed to remove dependency tar files"

# Build temporary folder
dir="$(mktemp -d)" || abend "Error creating a temporary build folder"
cd "$dir" || abend "Cannot enter $dir"
/usr/src/gcc/configure --disable-multilib --enable-languages=c,c++ || abend "Cannot configure build"
make -j"$(nproc)" || abend "Build failed"
#make install-strip
#cd ..
#rm -rf "$dir"

# gcc installs .so files in /usr/local/lib64...
#echo '/usr/local/lib64' > /etc/ld.so.conf.d/local-lib64.conf
#ldconfig -v || abend "Failed to rebuild ld cache"

# ensure that alternatives are pointing to the new compiler and that old one is no longer used
#dpkg-divert --divert /usr/bin/gcc.orig --rename /usr/bin/gcc
#dpkg-divert --divert /usr/bin/g++.orig --rename /usr/bin/g++
#update-alternatives --install /usr/bin/cc cc /usr/local/bin/gcc 999

echo "Success"

