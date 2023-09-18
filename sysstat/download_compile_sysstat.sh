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
echo "########################################"
echo "步骤1/1 下载并安装 sysstat"
echo "#######################################"

cd /workspace
git clone https://github.com/sysstat/sysstat
cd sysstat
git checkout v12.7.4

apt install flex bison make -y
./configure --host=${CROSS_COMPILER_PREFIX}
make -j8 V=1
make install DESTDIR=/sysroot

############################################################






###########################################################
echo "########################################"
echo "执行成功！ 拷贝所有生成文件到当前目录"
echo "#######################################"
cp -r /sysroot /mnt
###########################################################

