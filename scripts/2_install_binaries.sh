#!/bin/sh

SOCAT_VERSION="1.7.3.4"
DROPBEAR_VERSION="2019.78"
NMAP_VERSION="7.80"
TCPDUMP_VERSION="4.9.3"
OPENSSH_VERSION="8.2p1"

ARCHS=`grep -v '^#' /arch.txt| cut -d: -f 1`

mkdir /build 2>/dev/null ; cd /build

curl -LO https://matt.ucc.asn.au/dropbear/releases/dropbear-${DROPBEAR_VERSION}.tar.bz2
tar jxvf dropbear-${DROPBEAR_VERSION}.tar.bz2
curl -LO http://nmap.org/dist/nmap-${NMAP_VERSION}.tar.bz2
tar xjvf nmap-${NMAP_VERSION}.tar.bz2
curl -LO http://www.dest-unreach.org/socat/download/socat-${SOCAT_VERSION}.tar.gz
tar xzvf socat-${SOCAT_VERSION}.tar.gz
curl -LO https://www.tcpdump.org/release/tcpdump-${TCPDUMP_VERSION}.tar.gz
tar xzvf tcpdump-${TCPDUMP_VERSION}.tar.gz
curl -LO https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${OPENSSH_VERSION}.tar.gz
tar xzvf openssh-${OPENSSH_VERSION}.tar.gz

make_me() {
    make && make strip; make install ; make clean
}

# nmap/  libssh2 has a very old config.sub
curl 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' >  /tmp/config.sub


for ARCH in ${ARCHS} ; do 
    export LD_LIBRARY_PATH="/usr/${ARCH}/lib/"
    export LD="/opt/cross/${ARCH}/bin/${ARCH}-ld -L${LD_LIBRARY_PATH}"
    export CC="/opt/cross/${ARCH}/bin/${ARCH}-gcc -static -fPIC -L${LD_LIBRARY_PATH}"
    export CXX="/opt/cross/${ARCH}/bin/${ARCH}-g++ -static -static-libstdc++ -fPIC -L${LD_LIBRARY_PATH}"
    export CPATH="/usr/${ARCH}/include"

    # Disable strip  for unsupported architectures (nmap/ncat)
    export STRIP=/bin/true

    ##################################### DROPBEAR ##################################### 

    cd /build/dropbear-${DROPBEAR_VERSION}
    echo "** Configuring DROPBEAR for ${ARCH}"
    # no harden -> ld: cannot find -lssp_nonshared
    ./configure --prefix=/usr/${ARCH}/ --host=${ARCH} --enable-static --disable-harden
    make_me

    ##################################### NMAP ##################################### 
    
    cd /build/nmap-${NMAP_VERSION}
    # No dynamic option for linker !!
    sed -i 's#-Wl,-E##g' ./configure
    echo "** Configuring NMAP for ${ARCH}"
    cp /tmp/config.sub libssh2/config.sub
    ./configure \
            --without-ndiff \
            --without-zenmap \
            --without-nmap-update \
            --host=${ARCH} \
            --prefix=/usr/${ARCH} 
    make_me

    ##################################### Socat ##################################### 

    cd /build/socat-${SOCAT_VERSION}
    echo "** Configuring SOCAT for ${ARCH}"
    ./configure --prefix=/usr/${ARCH} --host=${ARCH} 
    make_me

    ##################################### tcpdump ##################################### 
    
    cd /build/tcpdump-${TCPDUMP_VERSION}
    echo "** Configuring tcpdump for ${ARCH}"
    ./configure  --prefix=/usr/${ARCH} --host=${ARCH}
    make_me

    ##################################### OpenSSH ##################################### 

    cd /build/openssh-${OPENSSH_VERSION}
    echo "** Configuring OPENSSH for ${ARCH}"
    ./configure --prefix=/usr/${ARCH} --with-pie=no --host=${ARCH} --disable-strip
    make_me

done


