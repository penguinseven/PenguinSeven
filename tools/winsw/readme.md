### winsw  常见问题

#### 1. 安装服务

```cmd
winsw.exe install
```

#### 2. 卸载服务

```cmd
winsw.exe uninstall
```

#### 3. 使用示例

1. 下载最新版的 Windows Service Wrapper 程序，比如我下载的名称是 "winsw-1.9-bin.exe"，
    然后，把它命名成你想要的名字（比如: "myapp.exe"，当然，你也可以不改名）

2. 将重命名后的 myapp.exe 复制到 nginx 的安装目录（我这里是 "F:\nginx-0.9.4"）

3. 在同一个目录下创建一个Windows Service Wrapper的XML配置文件，名称必须与第一步重命名时使用的名称一致（比如我这里是 "myapp.xml",  如果，你没有重命名，则应该是 "winsw-1.9-bin.xml"）
   文件内容如下：
   
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<service>
  <id>nginx</id>
  <name>nginx</name>
  <description>nginx</description>
  <executable>F:\nginx-0.9.4\nginx.exe</executable>
  <logpath>F:\nginx-0.9.4\</logpath>
  <logmode>roll</logmode>
  <depend></depend>
  <startargument>-p F:\nginx-0.9.4</startargument>
  <stopargument>-p F:\nginx-0.9.4 -s stop</stopargument>
</service>


```

#### 4. 命令行下执行以下命令，以便将其安装成Windows服务

```cmd
F:\nginx-0.9.4> myapp.exe install
```