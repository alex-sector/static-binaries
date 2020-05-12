#!/bin/sh

mkdir -p output/{aarch64,i686,mips,x86_64}-linux-musl

podman run  \
    -v ./output/aarch64-linux-musl:/usr/aarch64-linux-musl:z \
    -v ./output/i686-linux-musl:/usr/i686-linux-musl:z \
    -v ./output/mips-linux-musl:/usr/mips-linux-musl:z \
    -v ./output/x86_64-linux-musl:/usr/x86_64-linux-musl:z \
    -v  ./scripts/:/scripts:z \
    musl_compiler /scripts/1_install_libraries.sh

podman run  \
    -v ./output/aarch64-linux-musl:/usr/aarch64-linux-musl:z \
    -v ./output/i686-linux-musl:/usr/i686-linux-musl:z \
    -v ./output/mips-linux-musl:/usr/mips-linux-musl:z \
    -v ./output/x86_64-linux-musl:/usr/x86_64-linux-musl:z \
    -v  ./scripts/:/scripts:z \
    musl_compiler /scripts/2_install_binaries.sh



