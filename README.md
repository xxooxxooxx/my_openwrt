my_openwrt  
```
echo "https://xxooxxooxx.github.io/my_openwrt/packages/packages.adb" >>/etc/apk/repositories.d/customfeeds.list
wget https://xxooxxooxx.github.io/my_openwrt/packages/public.key -O /etc/apk/keys/my_public.key
apk update  
```
