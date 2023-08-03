# my_openwrt x86_64

用GitHub Actions自动编译自己的OpenWrt固件

特性，基于官方固件可使用官方源安装软件包  
也可自己添加官方没有的包，比如自己开发的，把软件包目录放package即可自动编译并自动集成到固件里  
也可以直接使用网上已存在的仓库，见build.sh 27行  
DEFAULT 定义需要集成到固件里的软件包(官方，用空格分隔)名字  

[GitHub Actions的官方文档](https://docs.github.com/zh/actions/quickstart)

+ 自动编译package目录里的每个软件包，注意，如果Makefile定义的包名字和官方Feeds冲突，将不会编译
需要在build.sh里额外执行
```
./scripts/feeds uninstall tinc          //删除官方包
./scripts/feeds install -p custom tinc  //安装自定义包
find ./package -name tinc               //确认
``` 
+ files目录，需要替换官方固件文件


+ build.sh
```
SDK_VERSION=23.05.0-rc2  //SDK版本
GCC_VER=12.3.0           //GCC版本
sed -i "s/^CONFIG_TARGET_ROOTFS_PARTSIZE=.*$/CONFIG_TARGET_ROOTFS_PARTSIZE=2048/g" $(pwd)/.config  //69行，修改固件可读写分区大小(2048)
```
+ 下载固件

切换到分支gh-pages

bin目录即是编译好的固件

+ 也可以单独安装自编译软件包
```
echo "src/gz custom https://xxooxxooxx.github.io/my_openwrt/packages" >>/etc/opkg/distfeeds.conf
wget https://xxooxxooxx.github.io/my_openwrt/packages/public.key
opkg-key add public.key
opkg update
```
+ 安装到虚拟机
```
wget https://github.com/xxooxxooxx/my_openwrt/raw/gh-pages/bin/openwrt-23.05.0-rc2-x86-64-generic-ext4-combined.img.gz
gunzip openwrt-23.05.0-rc2-x86-64-generic-ext4-combined.img.gz
qm importdisk <vmid> openwrt-23.05.0-rc2-x86-64-generic-ext4-combined.img local-lvm
```
