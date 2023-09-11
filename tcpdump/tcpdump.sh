#!/bin/bash

# 此脚本用于在docker环境中执行，编译tcpdump并拷贝到/mnt中


####################################################### 
# 检查环境变量
if [[ -z "${CROSS_COMPILER_PREFIX}" ]]; then
  echo "error: you must specific environment variable 'CROSS_COMPILER_PREFIX'"
  echo "such as: CROSS_COMPILER_PREFIX = aarch64-none-linux"
  exit 1
fi

export PATH=$PATH:$CROSS_COMPILER_PATH
if ! command -v ${CROSS_COMPILER_PREFIX}-gcc &> /dev/null
then
    echo "${CROSS_COMPILER_PREFIX}-gcc could not be found, be sure it's in PATH"
    exit 1
fi

# 设置代理
export http_proxy=http://192.168.64.1:7890
export https_proxy=http://192.168.64.1:7890

# 安装常用命令
apt update
apt install git -y
mkdir /sysroot
mkdir /workspace && cd /workspace
##########################################################






##########################################################
# 1. 下载libpcap
echo "download and build libpcap"
cd /workspace
git clone https://github.com/the-tcpdump-group/libpcap
cd libpcap
git checkout libpcap-1.10.4

apt install flex bison make -y

./configure --host=${CROSS_COMPILER_PREFIX}
make -j8 V=1
make install DESTDIR=/sysroot


#2.下载tcpdump
echo "download and build 下载tcpdump"
cd /workspace
git clone https://github.com/the-tcpdump-group/tcpdump
cd tcpdump
git checkout tcpdump-4.99.4

apt install pkg-config -y
export PKG_CONFIG_LIBDIR=/sysroot/usr/local/lib/pkgconfig
export PKG_CONFIG_SYSROOT_DIR=/sysroot
./configure --host=${CROSS_COMPILER_PREFIX}
make -j8 V=1
############################################################






###########################################################
echo "success! copy tcpdump to /mnt"
cp tcpdump /mnt
###########################################################

