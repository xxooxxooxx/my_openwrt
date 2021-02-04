# openwrt_tinc1.1

```
cd ~
mkdir openwrt/custom-feed
git clone https://github.com/xxooxxooxx/openwrt_tinc1.1 openwrt/custom-feed/tinc

cd sdk
vi feeds.conf.default
src-link custom /home/user/openwrt/custom-feed

./scripts/feeds update -a
./scripts/feeds install -a

find ./package -name tinc
./scripts/feeds uninstall tinc

./scripts/feeds install -p custom tinc
ls package/feeds/custom/ -al
find ./package -name tinc

make package/tinc/{clean,compile} V=s 

ls bin/packages/x86_64/custom/ -al
-rw-r--r-- 1 user 1000 240347 Jan 10 10:57 tinc_1.1pre17-1_x86_64.ipk
```
# example  
+ /etc/config/tinc
```
config tinc-net vpn
        option enabled 1
        option generate_keys 1
        option key_size  4096
        option Name test
        option Mode switch
        option Interface tun0
        option PrivateKeyFile /etc/tinc/vpn/rsa_key.priv
        option Ed25519PrivateKeyFile /etc/tinc/vpn/ed25519_key.priv
        
config tinc-host test
        option enabled 1
        option net vpn
```
+ /etc/config/network
```
.
config interface 'vpn'
        option ifname 'tun0'
        option proto 'static'
        option netmask '255.255.255.0'
        option ipaddr '10.0.7.20'

config interface 'vpn6'
        option ifname 'tun0'
        option proto 'dhcpv6'
        option reqaddress 'none'
        option reqprefix 'no'
.
```
```
/etc/init.d/tinc start
```
