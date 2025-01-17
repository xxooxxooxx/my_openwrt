#!/bin/bash
#
SDK_VERSION=24.10.0-rc5
GCC_VER=13.3.0

sudo apt-get update
sudo apt-get install build-essential ccache ecj fastjar file g++ gawk \
gettext git java-propose-classpath libelf-dev libncurses5-dev \
libncursesw5-dev libssl-dev python2 python2.7-dev python3 unzip wget \
python3-distutils python3-setuptools rsync subversion swig time \
xsltproc zlib1g-dev zstd -y

wget https://downloads.openwrt.org/releases/$SDK_VERSION/targets/x86/64/openwrt-imagebuilder-$SDK_VERSION-x86-64.Linux-x86_64.tar.zst
wget https://downloads.openwrt.org/releases/$SDK_VERSION/targets/x86/64/openwrt-sdk-$SDK_VERSION-x86-64_gcc-"$GCC_VER"_musl.Linux-x86_64.tar.zst
tar -I zstd -xf openwrt-imagebuilder-$SDK_VERSION-x86-64.Linux-x86_64.tar.zst
tar -I zstd -xf openwrt-sdk-$SDK_VERSION-x86-64_gcc-"$GCC_VER"_musl.Linux-x86_64.tar.zst
H_PATH=$(pwd)

cd openwrt-sdk-$SDK_VERSION-x86-64_gcc-"$GCC_VER"_musl.Linux-x86_64
cp ../key-build* .
./scripts/feeds update -a
./scripts/feeds install -a

#echo "src-link custom $H_PATH/package" >> $(pwd)/feeds.conf.default
#sed -i "\$a\src-link custom ${H_PATH}/package" $(pwd)/feeds.conf.default
sed -i "\$a\src-git custom https://github.com/xxooxxooxx/my_openwrt.git" $(pwd)/feeds.conf.default
sed -i "\$a\src-git openclash https://github.com/vernesong/OpenClash.git" $(pwd)/feeds.conf.default
sed -i "\$a\src-git my_strongswan https://github.com/xxooxxooxx/strongSwan-on-OpenWrt.git" $(pwd)/feeds.conf.default

./scripts/feeds update custom
./scripts/feeds install -a -p custom
#./scripts/feeds uninstall tinc
#./scripts/feeds install -p custom tinc

./scripts/feeds update openclash
./scripts/feeds install -a -p openclash

./scripts/feeds update my_strongswan
./scripts/feeds uninstall strongswan
./scripts/feeds install -p my_strongswan strongswan

make defconfig
make package/luci-base/compile -j
make package/luci-app-openclash/compile -j
make package/strongswan/compile -j

. ../main/DEFAULT
STR=$DEFAULT
STR="${STR} luci-app-openclash strongswan-mod-bypass-lan"

# install theme-argon
#git clone https://github.com/jerrykuku/luci-theme-argon.git
#git clone https://github.com/jerrykuku/luci-app-argon-config.git
#mv luci-app-argon-config luci-theme-argon -t package
#mv luci-theme-argon package
#./scripts/feeds update -a
#./scripts/feeds install -a
#make package/luci-theme-argon/compile -j
#make package/luci-app-argon-config/compile -j
#STR="${STR} luci-theme-argon"
#STR="${STR} luci-theme-argon luci-app-argon-config"

#for i in ../package/* ; do
for i in feeds/custom/package/* ; do
  if [[ -d "$i" ]]; then
#    make package/${i##*/}/{clean,compile} V=s -j
    make package/${i##*/}/compile -j
    STR="${STR} ${i##*/}"
  fi
done

#cp -a bin/packages/x86_64/base/luci-theme-argon*.ipk bin/packages/x86_64/custom/
#cp -a bin/packages/x86_64/base/luci-app-argon-config*.ipk bin/packages/x86_64/custom/

cp -a bin/packages/x86_64/openclash/*.ipk bin/packages/x86_64/custom/
cp -a bin/packages/x86_64/my_strongswan/strongswan-mod-bypass-lan*.ipk bin/packages/x86_64/custom/

make package/index V=sc
cd - &>/dev/null

cp -a openwrt-sdk-$SDK_VERSION-x86-64_gcc-"$GCC_VER"_musl.Linux-x86_64/bin/packages/x86_64/custom packages
#cp -a ./main/bin packages

#cat >./main/files/etc/opkg/distfeeds.conf <<-EOF
#	src/gz openwrt_core https://downloads.openwrt.org/releases/$SDK_VERSION/targets/x86/64/packages
#	src/gz openwrt_base https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/base
#	src/gz openwrt_luci https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/luci
#	src/gz openwrt_packages https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/packages
#	src/gz openwrt_routing https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/routing
#	src/gz openwrt_telephony https://downloads.openwrt.org/releases/$SDK_VERSION/packages/x86_64/telephony
#EOF

cd openwrt-imagebuilder-$SDK_VERSION-x86-64.Linux-x86_64
sed -i "/option check_signature/d" $(pwd)/repositories.conf
sed -i "\$a\src custom file://$H_PATH/packages" $(pwd)/repositories.conf
sed -i "s/^CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=2048/g" $(pwd)/.config

make image PROFILE=generic PACKAGES="$STR" \
           FILES=../main/files/ \
           DISABLED_SERVICES="led tor ipset-dns tinc ipsec 3proxy swanctl"

cd - &>/dev/null
cp -a openwrt-imagebuilder-$SDK_VERSION-x86-64.Linux-x86_64/bin/targets/x86/64 bin

#tree openwrt-sdk-$SDK_VERSION-x86-64_gcc-12.3.0_musl.Linux-x86_64/bin/packages/x86_64>LIST.txt
