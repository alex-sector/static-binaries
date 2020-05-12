#!/bin/sh

mkdir -p /build/musl
git clone https://github.com/GregorR/musl-cross.git /build/musl

cd  /build/musl  

for ARCH in `grep -v '^#' /arch.txt| cut -d- -f 1`; do
    cp config.sh config.sh_old
    echo "ARCH=${ARCH}" >> config.sh
    echo "GCC_BUILTIN_PREREQS=yes" >> config.sh
    echo "[+] Building musl-cross ${ARCH}"
    ./build.sh
    echo "[+] Finished building musl-cross ${ARCH}"
    ./clean.sh
    cp config.sh_old config.sh
done
rm -rf /build/musl
