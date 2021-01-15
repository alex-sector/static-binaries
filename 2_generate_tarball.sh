#!/bin/sh

tar -zcvf binaries.tgz \
    -C output \
    --owner=root \
    --group=root \
    {aarch64,i686,mips,x86_64}-linux-musl/{s,}bin


