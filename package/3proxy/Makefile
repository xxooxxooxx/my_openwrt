include $(TOPDIR)/rules.mk

PKG_NAME:=3proxy
PKG_VERSION=0.8.13

PKG_MAINTAINER:=muziling <lls924@gmail.com>
PKG_LICENSE:=GPLv2
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/z3APA3A/3proxy.git
PKG_SOURCE_VERSION:=e85b064b52296502a1dab648988a56e510088b76

PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

include $(INCLUDE_DIR)/package.mk

define Package/3proxy
	SUBMENU:=Web Servers/Proxies
	SECTION:=net
	CATEGORY:=Network
	TITLE:=3proxy for OpenWRT
	DEPENDS:=+libpthread +libopenssl
endef

define Package/3proxy/description
	3APA3A 3proxy tiny proxy server
endef

define Package/3proxy/conffiles
/etc/3proxy/3proxy.cfg
/etc/3proxy/bandlimiters
/etc/3proxy/counters
/etc/3proxy/passwd
endef

define Build/Configure
	$(CP) $(PKG_BUILD_DIR)/Makefile.Linux $(PKG_BUILD_DIR)/Makefile
endef

define Package/3proxy/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/3proxy
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/3proxy $(1)/usr/bin/3proxy
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/mycrypt $(1)/usr/bin/mycrypt
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/scripts/3proxy.cfg $(1)/etc/3proxy/3proxy.cfg
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scripts/add3proxyuser.sh $(1)/etc/3proxy/add3proxyuser.sh
	$(INSTALL_CONF) ./files/passwd $(1)/etc/3proxy/passwd
	$(INSTALL_DATA) ./files/bandlimiters $(1)/etc/3proxy/bandlimiters
	$(INSTALL_DATA) ./files/counters $(1)/etc/3proxy/counters
	$(INSTALL_BIN) ./files/3proxy.init $(1)/etc/init.d/3proxy
endef

$(eval $(call BuildPackage,3proxy))

