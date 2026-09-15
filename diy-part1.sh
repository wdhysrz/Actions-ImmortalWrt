#!/bin/bash

# 修改默认 IP 地址为 192.168.6.1
sed -i 's/192.168.1.1/192.168.6.1/g' package/base-files/files/bin/config_generate