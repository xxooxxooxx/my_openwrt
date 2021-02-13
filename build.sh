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
cp ../key-build* .
./scripts/feeds update -a
./scripts/feeds install -a

#echo "src-link custom $H_PATH/package" >> $(pwd)/feeds.conf.default
#sed -i "\$a\src-link custom ${H_PATH}/package" $(pwd)/feeds.conf.default
sed -i "\$a\src-git custom https://github.com/xxooxxooxx/my_openwrt.git" $(pwd)/feeds.conf.default

./scripts/feeds update custom
./scripts/feeds install -a -p custom
./scripts/feeds uninstall tinc
./scripts/feeds install -p custom tinc

. ../main/DEFAULT
STR=$DEFAULT

make defconfig
#for i in ../package/* ; do
for i in feeds/custom/package/* ; do
  if [[ -d "$i" ]]; then
#    make package/${i##*/}/{clean,compile} -j
#    make package/${i##*/}/compile -j
    STR="${STR} ${i##*/}"
  fi
done

#make package/index
cd - &>/dev/null

#cp -a openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64/bin/packages/x86_64/custom packages
cp -a ./main/bin packages

cat >./main/files/etc/opkg/distfeeds.conf <<-EOF
	src/gz openwrt_core https://downloads.openwrt.org/releases/$SDK_VERSION/targets/x86/64/packages
	src/gz openwrt_base https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/base
	src/gz openwrt_luci https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/luci
	src/gz openwrt_packages https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/packages
	src/gz openwrt_routing https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/routing
	src/gz openwrt_telephony https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/telephony
EOF

cd openwrt-imagebuilder-$SDK_VERSION-x86-64.Linux-x86_64
sed -i "\$a\src custom file://$H_PATH/packages" $(pwd)/repositories.conf
ls -al
cat repositories.conf
echo STR=$STR

make image PROFILE=Generic PACKAGES="$STR"

ls bin/targets/x86/64/ -al

#tree openwrt-sdk-$SDK_VERSION-x86-64_gcc-7.5.0_musl.Linux-x86_64/bin/packages/x86_64>LIST.txt
