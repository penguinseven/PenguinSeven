## Java

## 安装jdk1.8

- 下载jdk http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
```bash
wget http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.tar.gz
# 解压
tar -zxvf jdk-8u151-linux-x64.tar.gz
# 移动目录
mv jdk /usr/java
```

- 修改 `/etc/profile` 
```bash
vi /etc/profile

# 添加在最后
export JAVA_HOME=/usr/java
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

# 立即生效
source /etc/profile

```

- 监测是否安装成功

```bash
java -version
```

