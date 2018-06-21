# Git 版本库
 
## 常用命令 
 
### 0. 初始化

     # 创建项目 
     mkdir paperless
     cd paperless
     git init
     echo "# paperless" >> README.md
     git add README.md
     git commit -m "first commit"
     git remote add origin https://git.coding.net/penguinseven/paperless.git
     git push -u origin master
     
     ## 已有项目
     git remote add origin https://git.coding.net/penguinseven/paperless.git
     git push -u origin master
     

### 1.  保存用户名，密码

每次操作都需要输入用户名和密码感觉很繁琐，解决方法，在本地的工程文件夹的.git下打开config文件
添加：(再输入一次用户名密码后就可以保存住了。)


```cmd
    [credential]
         helper = store
```

### 2. 修改git 源

```cmd
git remote set-url origin/master http://xxx
```

### 3.tag标签

> Git 中的tag指向一次commit的id，通常用来给开发分支做一个标记，如标记一个版本号。

### 1. 打标签

    git tag -a v1.01 -m "Relase version 1.01"
    
> 注解：git tag 是打标签的命令，-a 是添加标签，其后要跟新标签号，-m 及后面的字符串是对该标签的注释。

### 2. 提交标签到远程仓库

    git push origin -tags
    
> 注解：就像git push origin master 把本地修改提交到远程仓库一样，-tags可以把本地的打的标签全部提交到远程仓库。

### 3. 删除标签

    git tag -d v1.01
    
> 注解：-d 表示删除，后面跟要删除的tag名字

### 4. 删除远程标签

    git push origin :refs/tags/v1.01
    
> 注解：就像git push origin :branch_1 可以删除远程仓库的分支branch_1一样， 冒号前为空表示删除远程仓库的tag。

### 5. 查看标签

    git tag
    # 或者  
    git tag -l
    

### 6.remote

> 可以通过-all一次提交多个仓库

- 配置远程仓库

```bash
git remote add origin https://url
```

- 再添加一个远程仓库

```bash
git remote set-url --add origin https://url
```

- 注意这里多次添加需要用

```bash
git remote set-url --add
```

- 不然会报错：

```bash
fatal: remote origin already exists.
```

- 或者改名

```bash
git remote add otherOrigin https://url
```

- 一次提交到所有远程仓库

```bash
git push --all
```

>注意  

`git pull` 是 `git pull` (**from**) `origin` (**to**) `master`


`git push` 是 `git push` (**to**) `origin` (**from**) `master`


## 常见问题

### 0. CentOS 系统，自带git不能用

> error: The requested URL returned error: 400 Bad Request while accessing https://git.coding.net/linghuyong/youyiche.git/info/refsfatal: HTTP request failed

- 编译安装2.4

```bash
→ yum -y install vim gcc-c++ gcc make openssl-devel openssl 
→ rpm -e git perl-Git
→wget https://www.kernel.org/pub/software/scm/git/git-2.8.1.tar.gz
→ tar xf git-2.8.1.tar.gz
→ cd git-2.8.1
→ ./configure --prefix=/usr/local/git  --with-curl --with-expat
→ make
→ make install
```

- 错误一：

> 　usr/bin/perl Makefile.PL PREFIX='/usr/local/git' INSTALL_BASE='' --localedir='/usr/local/git/share/locale'
  　　Can't locate ExtUtils/MakeMaker.pm in @INC (@INC contains: /usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib64/perl5 　　/usr/share/perl5 .) at Makefile.PL line 3.
  　　BEGIN failed--compilation aborted at Makefile.PL line 3.
  　　make[1]: *** [perl.mak] Error 2
  　　make: *** [perl/perl.mak] Error 2
  
执行：

```
yum install perl-ExtUtils-MakeMaker package.
```
  
- 出现错误二：

> /bin/sh: msgfmt: command not found

```bash
yum install gettext-devel
```

- 软连接,加入全局变量

```bash
ln -s /usr/local/git/bin/* /usr/bin/
```

- [参考地址](http://blog.51cto.com/sandy521/1718236)
- [参考地址](https://www.cnblogs.com/grimm/p/5368777.html)


### 1.`fatal：refusing to merge unrelated histories` 

- 更新项目

```bash
# 告诉系统我允许合并不相关历史的内容。
git pull origin master --allow-unrelated-histories
```

- [参考地址](https://www.cnblogs.com/lulubai/p/6001334.html)