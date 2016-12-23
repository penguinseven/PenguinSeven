 # 常见问题

> 1.  保存用户名，密码
----
每次操作都需要输入用户名和密码感觉很繁琐，解决方法，在本地的工程文件夹的.git下打开config文件
添加：(再输入一次用户名密码后就可以保存住了。)


```cmd
    [credential]
         helper = store
```

> 2. 修改git 源
```cmd
git remote set-url origin/master http://xxx
```
