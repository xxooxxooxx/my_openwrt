#!/bin/bash
#
SDK_VERSION=19.07.6

sudo apt-get update
sudo apt-get install build-essential ccache ecj fastjar file g++ gawk \
gettext git java-propose-classpath libelf-dev libncurses5-dev \
libncursesw5-dev libssl-dev python python2.7-dev python3 unzip wget \
python3-distutils python3-setuptools rsync subversion swig time \
xsltproc zlib1g-dev -y
wget https://downloads.openwrt.org/releases/$SDK_VERSION/targets/x86/64/openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64.tar.xz
tar xf openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64.tar.xz
cd openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make package/tinc/{clean,compile} V=s
cd -
pwd>PATH.txt
tree openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64/bin/packages/x86_64>LIST.txt
cd -
