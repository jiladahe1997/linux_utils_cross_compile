# linux_utils_cross_compile
This is a collection of how to cross-compile linux utils commands, such as: iperf, tcpdump, sar, lsblk ,etc

# 使用方法：
以tcpdump为例，cd tcpdump && ./run.sh 即可

需要根据自己的需求修改 run.sh中的
/root/workspace/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64_be-none-linux-gnu
CROSS_COMPILER_PREFIX
CROSS_COMPILER_PATH

三个变量