#!/bin/sh

OPENSSL_VERSION="1.1.1i"
ZLIB_VERSION="1.2.11"
LIBPCAP_VERSION="1.10.0"

mkdir /build 2>/dev/null ; cd /build

ARCHS=`grep -v '^#' /arch.txt| cut -d: -f 1`

curl -LO https://www.tcpdump.org/release/libpcap-${LIBPCAP_VERSION}.tar.gz      
curl -LO https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
curl -LO https://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz

tar zxvf libpcap-${LIBPCAP_VERSION}.tar.gz                                     
tar zxvf openssl-${OPENSSL_VERSION}.tar.gz
tar xzvf zlib-${ZLIB_VERSION}.tar.gz    

make_me() {
    make && make install ; make clean
}

for ARCH in ${ARCHS}; do                                                       
    export OPENSSL_SYSTEM=$(grep ${ARCH} /arch.txt | cut -d: -f 2)                                                                               
    export LD="/opt/cross/${ARCH}/bin/${ARCH}-ld"                              
    export CC="/opt/cross/${ARCH}/bin/${ARCH}-gcc -static"                     

    ##################################### Libpcap ##################################### 

    cd /build/libpcap-${LIBPCAP_VERSION}                                                  
    echo "** Configuring LIBPCAP for ${ARCH}"                                  
    ./configure --host=$ARCH --prefix=/usr/${ARCH} --disable-shared
    make_me

    ##################################### OpenSSL ##################################### 

    cd /build/openssl-${OPENSSL_VERSION}

    echo "** Configuring OpenSSL for ${ARCH}"
    ./Configure no-shared ${OPENSSL_SYSTEM} --prefix=/usr/${ARCH}
    make_me

    ##################################### Zlib ##################################### 

    cd /build/zlib-${ZLIB_VERSION}
    echo "** Configuring ZLIB for ${ARCH}"
    ./configure --static --prefix=/usr/${ARCH}
    make_me

done                                                                           


