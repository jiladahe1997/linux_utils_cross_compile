docker run \
-v /root/workspace/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64_be-none-linux-gnu:/cross_compiler \
-v $(pwd):/mnt \
-e CROSS_COMPILER_PREFIX=aarch64_be-none-linux-gnu \
-e CROSS_COMPILER_PATH=/cross_compiler/bin \
-e http_proxy=http://192.168.64.1:7890 \
-e https_proxy=http://192.168.64.1:7890 \
-it \
ubuntu:22.04 /mnt/tcpdump.sh