my_openwrt

```
echo "src/gz custom https://xxooxxooxx.github.io/my_openwrt/packages" >>/etc/opkg/distfeeds.conf
wget https://xxooxxooxx.github.io/my_openwrt/packages/public.key
opkg-key add public.key
opkg update
```
