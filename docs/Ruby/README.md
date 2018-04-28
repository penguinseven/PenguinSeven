## Ruby

### 1. 安装

- 下载 （http://www.ruby-lang.org/en/downloads/） 教程版本：2.4.1

- 解压

```bash
tar -zxvf ruby-2.4.1.tar.gz
```

- 编译安装

```shell
cd ruby-2.4.1
# prefix是将ruby安装到指定目录，也可以自定义
./configure –-prefix=/usr/local/ruby 
# 安装
make && make install 
```

- Ruby环境变量配置

```bash
vi /etc/profile

# 添加路径
export PATH=/usr/local/ruby/bin:$PATH
# 刷新配置文件
source /etc/profile

```