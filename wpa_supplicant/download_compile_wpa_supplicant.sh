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
echo "步骤1/3 下载并安装 libnl"
echo "#######################################"

cd /workspace
git clone https://github.com/thom311/libnl.git
cd libnl
git checkout libnl3_9_0

apt install flex bison make autoconf pkg-config libtool -y

./autogen.sh
./configure --host=${CROSS_COMPILER_PREFIX}
make -j8 V=1
make install DESTDIR=/sysroot


#2.下载openssl
echo "########################################"
echo "步骤2/3 下载并安装 openssl"
echo "#######################################"
cd /workspace
git clone https://github.com/openssl/openssl.git
cd openssl
git checkout openssl-3.1.0

./Configure linux-aarch64 --prefix=/sysroot/usr/local --cross-compile-prefix=${CROSS_COMPILER_PREFIX}-
make -j8
make install -j8


#3.下载wpa_supplicant
echo "########################################"
echo "步骤3/3 下载并安装 wpa_supplicant"
echo "#######################################"
cd /workspace
git clone http://w1.fi/hostap.git
cd hostap/wpa_supplicant
git checkout hostap_2_9

cp defconfig .config
# 注释CONFIG_CTRL_IFACE_DBUS
cat .config | grep CONFIG_CTRL_IFACE_DBUS
sed -i '/^CONFIG_CTRL_IFACE_DBUS/s/^/#/' .config
cat .config | grep CONFIG_CTRL_IFACE_DBUS
export PKG_CONFIG_LIBDIR=/sysroot/usr/local/lib/pkgconfig
export PKG_CONFIG_SYSROOT_DIR=/sysroot
make CC=${CROSS_COMPILER_PREFIX}-gcc  -j8 V=1 LDFLAGS="-L/sysroot/usr/local/lib/ -static -lpthread -pthread" 
make CC=${CROSS_COMPILER_PREFIX}-gcc  -j8 V=1 LDFLAGS="-L/sysroot/usr/local/lib/" install DESTDIR=$(pwd)/install
############################################################






###########################################################
echo "########################################"
echo "执行成功！ 拷贝到当前目录"
echo "#######################################"
mkdir /mnt/wpa_supplicant
cp -r install/* /mnt/wpa_supplicant
###########################################################

