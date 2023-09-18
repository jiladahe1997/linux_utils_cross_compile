#!/bin/bash

# 此脚本用于在docker环境中执行，编译tcpdump并拷贝到/mnt中
set -e

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

# 安装常用命令(apt清华镜像源)
mv /etc/apt/sources.list /etc/apt/sources.list.bkup
tee /etc/apt/sources.list << EOF
deb [trusted=yes] http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb [trusted=yes] http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb [trusted=yes] http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb [trusted=yes] http://security.ubuntu.com/ubuntu/ jammy-security main restricted universe multiverse
EOF

apt update
apt install git -y
mkdir /sysroot
mkdir /workspace && cd /workspace
##########################################################






##########################################################
# 1. 下载libpcap
echo "########################################"
echo "步骤1/2 下载并安装 libpcap"
echo "#######################################"

cd /workspace
git clone https://github.com/the-tcpdump-group/libpcap
cd libpcap
git checkout libpcap-1.10.4

apt install flex bison make -y

./configure --host=${CROSS_COMPILER_PREFIX}
make -j8 V=1
make install DESTDIR=/sysroot


#2.下载tcpdump
echo "########################################"
echo "步骤2/2 下载并安装 tcpdump"
echo "#######################################"
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
echo "########################################"
echo "执行成功！ 拷贝tcpdump到当前目录"
echo "#######################################"
cp tcpdump /mnt
###########################################################

