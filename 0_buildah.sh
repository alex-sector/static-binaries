container=$(buildah from alpine:3)
buildah run $container sh -c "apk add git wget patch gcc g++ xz flex bison make curl perl file automake autoconf"
buildah copy $container ./scripts /scripts
buildah copy $container ./arch.txt /
buildah run $container sh /scripts/0_install_centosmusl.sh | tee install_musl.log
buildah run $container rm -rf /build
buildah commit --squash $container musl_compiler
