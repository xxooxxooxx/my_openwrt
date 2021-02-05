#!/bin/bash
#
SDK_VERSION=19.07.6

sudo apt-get update
sudo apt-get install build-essential ccache ecj fastjar file g++ gawk \
gettext git java-propose-classpath libelf-dev libncurses5-dev \
libncursesw5-dev libssl-dev python python2.7-dev python3 unzip wget \
python3-distutils python3-setuptools rsync subversion swig time \
xsltproc zlib1g-dev -y
wget https://downloads.openwrt.org/releases/$SDK_VERSION/targets/x86/64/openwrt-imagebuilder-$SDK_VERSION-x86-64.Linux-x86_64.tar.xz
wget https://downloads.openwrt.org/releases/$SDK_VERSION/targets/x86/64/openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64.tar.xz
tar xf openwrt-imagebuilder-$SDK_VERSION-x86-64.Linux-x86_64.tar.xz
tar xf openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64.tar.xz
H_PATH=$(pwd)
cd openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64
./scripts/feeds update -a
./scripts/feeds install -a

#echo "src-link custom $H_PATH/package" >> $(pwd)/feeds.conf.default
#sed -i "\$a\src-link custom ${H_PATH}/package" $(pwd)/feeds.conf.default
sed -i "\$a\src-git custom https://github.com/xxooxxooxx/my_openwrt.git" $(pwd)/feeds.conf.default

./scripts/feeds update custom
./scripts/feeds install -a -p custom
./scripts/feeds uninstall tinc
./scripts/feeds install -p custom tinc

make defconfig
for i in ../package/* ; do
  if [[ -d "$i" ]]; then
    make package/${i##*/}/{clean,compile} -j
  fi
done
cd - &>/dev/null
pwd>>PATH.txt
tree openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64/bin/packages/x86_64>LIST.txt
