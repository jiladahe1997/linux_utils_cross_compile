# linux_utils_cross_compile
This is a collection of how to cross-compile linux utils commands, such as: iperf, tcpdump, sar, lsblk ,etc


# 介绍
本项目实现了Linux上各种实用工具软件例如:iperf、tcpdump、sar、lsblk、lspci、lsusb等工具的一键交叉编译。

<br/>

### 主要针对的场景是：

嵌入式开发环境中，为了节约资源，通常都裁剪了调试工具。 有时候需要进行debug，例如客户发现网络有异常，此时我们需要实用tcpdump抓包进行问题定位。 此时最简单的办法是直接编译一个，上传到对应的单板上。

然而，不同的工具的编译流程和依赖的库均不相同，本项目将每个工具都从头编译了一次，并做成了shell脚本。通过此项目即可一键编译。（需用户提供对应的编译器）


<br/>
<br/>
<br/>

# 原理
使用docker创建一个ubuntu22.04的容器，然后在此容器中进行交叉编译。

<br/>
<br/>

# 使用方法：
以tcpdump为例，

需要根据自己的需求，确认以下4个环境变量：
 1. CROSS_COMPILER_PREFIX：编译器的前缀，例如：aarch64_be-none-linux-gnu，系统会使用aarch64_be-none-linux-gnu-gcc进行后续编译。
 2. CROSS_COMPILER_PATH: 编译器位于主机上的位置，例如：/root/workspace/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64_be-none-linux-gnu
 3. CROSS_COMPILER_BINARY：编译器可执行文件**相对于**CROSS_COMPILER_PATH的位置，假如是/root/workspace/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64_be-none-linux-gnu/bin，则这里直接输入 bin
 4. http_proxy: 编译时会去github下载源码，下载慢时需使用代理，例如：http://192.168.64.1:7890

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
即可。编译完成后会自动将编译的产物拷贝到当前目录，直接上传到单板即可使用。