#!/bin/bash
# Github 镜像加速，解决云编译克隆超时
git config --global url."https://mirror.ghproxy.com/https://github.com/".insteadOf "https://github.com/"

# 拉取PassWall2依赖库（内置适配PW2的最新版 sing-box）
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/openwrt-passwall-packages
# 拉取PassWall2 WEB管理面板
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2.git package/openwrt-passwall2

# 修改默认后台地址 192.168.1.1 → 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate
