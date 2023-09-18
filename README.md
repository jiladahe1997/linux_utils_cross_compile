# linux_utils_cross_compile
This is a collection of how to cross-compile linux utils commands, such as: iperf, tcpdump, sar, lsblk ,etc

# 原理
使用docker创建一个ubuntu22.04的容器，然后在此容器中进行交叉编译。

# 使用方法：
以tcpdump为例，

需要根据自己的需求，确认以下4个环境变量：
 - CROSS_COMPILER_PREFIX：编译器的前缀，例如：aarch64_be-none-linux-gnu，系统会使用aarch64_be-none-linux-gnu-gcc进行后续编译。
 - CROSS_COMPILER_PATH: 编译器位于主机上的位置，例如：/root/workspace/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64_be-none-linux-gnu
 - CROSS_COMPILER_BINARY：编译器可执行文件**相对于**CROSS_COMPILER_PATH的位置，假如是/root/workspace/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64_be-none-linux-gnu/bin，则这里直接输入 bin
 - http_proxy: 编译时会去github下载源码，下载慢时需使用代理，例如：http://192.168.64.1:7890

<br/>
然后执行：

```bash
cd tcpdump ; \
CROSS_COMPILER_PREFIX=aarch64_be-none-linux-gnu \
CROSS_COMPILER_PATH=/home/renmingrui/workspace/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64_be-none-linux-gnu \
CROSS_COMPILER_BINARY=bin \
http_proxy=http://192.168.64.1:7890 \
./run.sh 

```
即可