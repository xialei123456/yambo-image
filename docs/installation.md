# 一、环境准备

### 更新系统并安装依赖
```
sudo yum update -y
sudo yum install -y wget gcc-gfortran make cmake
sudo yum install -y m4 zlib-devel libtool
sudo yum install -y openmpi openmpi-devel
```
# 二、源码下载与编译安装

### 1. 下载并解压Yambo.5.3.0源码，下载目录以/home为例

```
cd /home
wget https://github.com/yambo-code/yambo/archive/refs/tags/5.3.0.tar.gz
tar -xzf yambo-5.3.0.tar.gz
cd yambo-5.3.0
```
若国内服务器连接github超时，则手动下载。
### 2. 修改源码修复lapack安装目录问题（https://github.com/yambo-code/yambo/pull/193）
参考官方解决方案，对lapack安装目录进行修复(https://github.com/yambo-code/yambo/commit/2ce9b0f0761832014b021981fb33694a6c966e09)
```
file="lib/lapack/Makefile.loc"
sed -i '28c
\t( cmake -DCMAKE_C_COMPILER=$(cc) -DCMAKE_Fortran_COMPILER=$(fc) -DCMAKE_INSTALL_PREFIX=$(LIBPATH) -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_LIBDIR=lib .. ) >> ${compdir}/log/config_$(PACKAGE)_static.log 2>&1 ; \\' "$file"
sed -i '30c
\t( cmake -DCMAKE_C_COMPILER=$(cc) -DCMAKE_Fortran_COMPILER=$(fc) -DCMAKE_INSTALL_PREFIX=$(LIBPATH) -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_LIBDIR=lib .. ) >> ${compdir}/log/config_$(PACKAGE)_shared.log 2>&1 ; \\' "$file"
```
### 3. 配置与编译安装,指定CPPFLAGS以正确预处理。
`make core`会自动下载未指定的所需依赖库，如遇网络问题，可以手动下载并移动至lib/archives目录下，库名和版本可参考该目录下的package.list文件。
```
./configure CPPFLAGS="-P"
make core
```
可选，编译所有可执行文件
```
make all
```

# 三、 为Yambo配置系统环境变量并删除多余文件
### 1. 创建目录，移动可执行文件
```
mkdir /opt/yambo-5.3.0
mv /home/yambo-5.3.0/bin /opt/yambo-5.3.0
```
### 2. Yambo配置
```
sudo cat > /etc/profile.d/yambo.sh << 'EOF'
#!/bin/bash
export YAMBO_HOME=/opt/yambo-5.3.0
export PATH=$YAMBO_HOME/bin:$PATH
EOF
sudo chmod +x /etc/profile.d/yambo.sh
```
### 3. 激活配置，删除压缩包和多余文件
```
source /etc/profile
rm /home/yambo-5.3.0.tar.gz
rm -rf /home/yambo-5.3.0
```
Yambo软件使用可参考官方教程：https://wiki.yambo-code.eu/wiki/index.php?title=Tutorials

PS:用于实际计算使用时，Yambo软件一般需要与基础泛函计算软件如Quantum ESPRESSO或ABINIT结合使用。
