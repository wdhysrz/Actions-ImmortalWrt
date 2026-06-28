#!/bin/bash
# 更新并安装passwall全套
./scripts/feeds update passwall passwall2
./scripts/feeds install -a -p passwall
./scripts/feeds install -a -p passwall2

# 修改后台IP地址
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate
