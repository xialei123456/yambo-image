#!/bin/bash

# 一、环境准备
### 更新系统并安装依赖
sudo yum update -y
sudo yum install -y wget gcc-gfortran make cmake
sudo yum install -y m4 zlib-devel libtool
sudo yum install -y openmpi openmpi-devel

# 二、源码下载与编译安装
## 1. 下载并解压Yambo.5.3.0源码,下载目录以/home为例
cd /home
### 若国内服务器连接github超时，可手动下载。
wget https://github.com/yambo-code/yambo/archive/refs/tags/5.3.0.tar.gz
tar -xzf yambo-5.3.0.tar.gz
cd yambo-5.3.0

### 如果你的机器将某些库如lapack安装在lib64文件夹下而非lib下，你需要对源码进行小的修改（https://github.com/yambo-code/yambo/pull/193）。
## 2. 参考原仓库下解决方案，对lapack安装目录进行修复(https://github.com/yambo-code/yambo/commit/2ce9b0f0761832014b021981fb33694a6c966e09)
file="lib/lapack/Makefile.loc"
sed -i '28c\
\t( cmake -DCMAKE_C_COMPILER=$(cc) -DCMAKE_Fortran_COMPILER=$(fc) -DCMAKE_INSTALL_PREFIX=$(LIBPATH) -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_LIBDIR=lib .. ) >> ${compdir}/log/config_$(PACKAGE)_static.log 2>&1 ; \\' "$file"
sed -i '30c\
\t( cmake -DCMAKE_C_COMPILER=$(cc) -DCMAKE_Fortran_COMPILER=$(fc) -DCMAKE_INSTALL_PREFIX=$(LIBPATH) -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_LIBDIR=lib .. ) >> ${compdir}/log/config_$(PACKAGE)_shared.log 2>&1 ; \\' "$file"

## 3. 配置与编译安装,指定CPPFLAGS以正确预处理。
### make core会自动下载未指定的所需依赖库，如遇网络问题，可以手动下载并移动至lib/archives目录下，库名和版本可参考该目录下的package.list文件。
./configure CPPFLAGS="-P"
make core
### 可选
make all

# 三、 添加Yambo可执行文件至系统环境变量
echo 'export PATH="/home/yambo-5.3.0/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
