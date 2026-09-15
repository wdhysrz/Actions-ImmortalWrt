#!/bin/bash

# 1. 更新并安装 feeds（保证基础依赖正常）
./scripts/feeds update -a
./scripts/feeds install -a

# 2. 移除可能冲突的旧核心和 LuCI 包
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls}

# 3. 克隆 Passwall 源码和依赖包
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages
git clone https://github.com/Openwrt-Passwall/openwrt-passwall package/passwall-luci

# 4. 严格根据要求，只保留 sing-box，删除其他所有代理核心
rm -rf package/passwall-packages/xray-core
rm -rf package/passwall-packages/v2ray-core
rm -rf package/passwall-packages/hysteria
rm -rf package/passwall-packages/naiveproxy
rm -rf package/passwall-packages/trojan-go
rm -rf package/passwall-packages/shadowsocks-rust
# 保留 package/passwall-packages/sing-box