#!/bin/bash

# ==========================================
# ==========================================
# 1. 修复 mtwifi-cfg 和 lutil 的文件冲突 (必须保留 WiFi)
# ==========================================
echo "正在修复 mtwifi-cfg 与 lutil 的文件冲突..."
# 修复：MTK的包通常在 feeds/ 目录下，不仅仅是在 package/ 目录下
MTWIFI_MAKEFILE=$(find . -name Makefile -path "*mtwifi-cfg*" | head -n 1)

if [ -n "$MTWIFI_MAKEFILE" ]; then
    MTWIFI_DIR=$(dirname "$MTWIFI_MAKEFILE")
    echo "找到 Makefile 路径: $MTWIFI_MAKEFILE"
    
    # 修复：正确的文件名是 lutil 而不是 l1util
    # 彻底删除 mtwifi-cfg 自带的 lutil 文件夹，防止覆盖系统包
    rm -rf "$MTWIFI_DIR/files/sbin/lutil"
    rm -rf "$MTWIFI_DIR/files/lutil"
    
    # 修复：删除 Makefile 中所有涉及 lutil 的安装和链接行
    sed -i '/lutil/d' "$MTWIFI_MAKEFILE"
    echo "mtwifi-cfg 冲突修复完成！"
else
    echo "警告：未能找到 mtwifi-cfg 的 Makefile 文件，请检查源码目录！"
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