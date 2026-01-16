my_openwrt  
```
echo "https://xxooxxooxx.github.io/my_openwrt/packages/packages.adb" >>/etc/apk/repositories.d/customfeeds.list
wget https://xxooxxooxx.github.io/my_openwrt/packages/key-build.pub -O /etc/apk/key-build.pub
apk update  
```
