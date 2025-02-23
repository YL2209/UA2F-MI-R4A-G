#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 修改 argon 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci-light/Makefile
# sed -i 's/.nowrap:not(.td){white-space:nowrap}/.nowrap:not(.td){white-space:unset}/g' package/feeds/luci/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
rm -rf package/feeds/luci/luci-theme-argon
git clone https://github.com/YL2209/luci-theme-argon.git package/luci-theme-argon

rm -rf package/feeds/luci/luci-app-ua2f
git clone https://github.com/YL2209/luci-app-ua2f.git package/luci-app-ua2f
git clone https://github.com/YL2209/luci-app-campus-network-login.git package/luci-app-campus-network-login

# 修改 UA2F 的版本
sed -i 's/^PKG_VERSION:=.*/PKG_VERSION:=4.8.4/' package/feeds/packages/ua2f/Makefile
sed -i 's/^PKG_HASH:=.*/PKG_HASH:=0d4cce0649fc1eca6b5f337dde954977b2731d961138c19e2d936005531ca1d5/' package/feeds/packages/ua2f/Makefile

# 增加 UA2F 需要的从 CONFIG_NETFILTER_NETLINK_GLUE_CT=y
awk '/# Netfilter Extensions/{print; getline; if ($0 ~ /^\*/) {print; print "CONFIG_NETFILTER_NETLINK_GLUE_CT=y"} else {print $0; print "CONFIG_NETFILTER_NETLINK_GLUE_CT=y"}; next} 1' .config > .config.tmp && mv .config.tmp .config

#更改主机型号，支持中文。 
sed -i 's/model = "Xiaomi Mi Router 4A Gigabit Edition"/model = "小米4A千兆版校园网专用"/g' target/linux/ramips/dts/mt7621_xiaomi_mi-router-4a-gigabit.dts

# 修改主机名字（不能纯数字或者使用中文）
sed -i 's/ImmortalWrt/NAOKUO/g' package/base-files/files/bin/config_generate

# 修改默认 wifi 名称 ssid 为 NAOKUO
sed -i 's/ssid=ImmortalWrt/ssid=NAOKUO/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改默认 wifi 加密模式
sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改默认 wifi 密码 key 为 12345678
sed -i '/set wireless.default_${name}.encryption=psk2/a\			set wireless.default_${name}.key=12345678' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改版本名称
# sed -i 's/ImmortalWrt/编译时间 $(TZ=UTC-8 date "+%Y.%m.%d") @ NAOKUO/g' include/trusted-firmware-a.mk
sed -i 's/ImmortalWrt/NAOKUO/g' include/u-boot.mk
sed -i 's/ImmortalWrt/NAOKUO/g' include/version.mk

# 去除 SSH
cat /dev/null > package/network/services/dropbear/files/dropbear.config



