container=$(buildah from centos:6)
buildah run $container yum install -y git wget patch gcc gcc-c++ xz flex bison
buildah copy $container ./scripts /scripts
buildah copy $container ./arch.txt /
buildah run $container sh /scripts/0_install_centosmusl.sh
buildah run $container rm -rf /build
buildah commit --squash $container musl_compiler
