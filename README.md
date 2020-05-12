# static-binaries

Building scripts for useful static binaries :
 * dropbear
 * OpenSSL
 * nmap (with ncat & nping)
 * socat
 * tcpdump
 * OpenSSH

Actual supported architectures are : 
 * aarch64
 * mips (32 bits)
 * i686
 * x86_64

Other platforms may easily be added (cf. arch.txt)


## Installation 

The first script prepares the compilation environment (musl) and creates the
container. The build process is done on a centos 6 container, so we can natively 
have 2.6 kernel headers.

```
$ sh ./0_buildah.sh
```

The second script will cross compile libraries and binaries :

```
$ sh ./1_cross_compile.sh
```

All the binaries will appear in the output directory.

Compiled binaries are available in the release section, it only includes bin and
sbin folders

