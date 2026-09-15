#!/bin/bash

# ==========================================
# 1. 修复 mtwi-fi-cfg 和 l1util 的文件冲突 (必须保留 WiFi)
# ==========================================
echo "正在修复 mtwi-fi-cfg 与 l1util 的文件冲突..."
MTWIFI_MAKEFILE=$(find package/ -name Makefile -path "*mtwifi-cfg*" | head -n 1)
if [ -n "$MTWIFI_MAKEFILE" ]; then
    MTWIFI_DIR=$(dirname "$MTWIFI_MAKEFILE")
    # 删除自带的老旧 l1util 文件夹，防止覆盖系统的包
    rm -rf "$MTWIFI_DIR/files/l1util"
    # 从 Makefile 中删除所有包含 l1util 的安装和链接行，让它直接使用系统的 l1util
    sed -i '/l1util/d' "$MTWIFI_MAKEFILE"
    echo "mtwi-fi-cfg 冲突修复完成！"
fi

# ==========================================
# 2. 更新和安装基础 feeds
# ==========================================
./scripts/feeds update -a
./scripts/feeds install -a

# ==========================================
# 3. 清理冲突的 Passwall 旧版本
# ==========================================
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/packages/net/{xray-core,v2ray-geodata,sing-box,chinadns-ng,dns2socks,hysteria,ipt2socks,microsocks,naiveproxy,shadowsocks-rust,shadowsocksr-libev,simple-obfs,tcping,v2ray-plugin,xray-plugin,geoview,shadow-tls}

# ==========================================
# 4. 克隆 Passwall 源码
# ==========================================
git clone https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages
git clone https://github.com/Openwrt-Passwall/openwrt-passwall package/passwall-luci

# ==========================================
# 5. 严格根据你的要求：只保留 sing-box，删除其他所有核心
# ==========================================
rm -rf package/passwall-packages/xray-core
rm -rf package/passwall-packages/v2ray-core
rm -rf package/passwall-packages/hysteria
rm -rf package/passwall-packages/naiveproxy
rm -rf package/passwall-packages/trojan-go
rm -rf package/passwall-packages/shadowsocks-rust
# 保留 package/passwall-packages/sing-box