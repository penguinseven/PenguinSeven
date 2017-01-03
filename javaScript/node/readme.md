#常见问题

### 1. 安装
```bash
$ ~ sudo apt-get install -y nodejs npm

# 淘宝镜像
$ vi .bashrc
# 添加内容
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"
# 退出，刷新
$ source .bashrc
```
### 2. 软连接
```bash
$ ~ sudo ln -s /usr/local/bin/node /usr/bin/node
$ ~ sudo ln -s /usr/local/bin/npm /usr/bin/npm
```
### 3. 安装express
1. 临时安装
```bash
$ npm install express
```
2. 安装 Express 并将其保存到依赖列表中：
```bash
$ npm install express --save
```
> 安装 Node 模块时，如果指定了 --save 参数，
> 那么此模块将被添加到 package.json 文件中 dependencies 依赖列表中。
> 然后通过 npm install 命令即可自动安装依赖列表中所列出的所有模块。

3. express 应用生成器
```bash
$ npm install express-generator -g

# 生成
$ express myapp

# 安装依赖包
$ npm install

# 启动
$ DEBUG=myapp npm start
```

4. 路由 (实例)

```javascript
// 对网站首页的访问返回 "Hello World!" 字样
app.get('/', function (req, res) {
  res.send('Hello World!');
});

// 网站首页接受 POST 请求
app.post('/', function (req, res) {
  res.send('Got a POST request');
});

// /user 节点接受 PUT 请求
app.put('/user', function (req, res) {
  res.send('Got a PUT request at /user');
});

// /user 节点接受 DELETE 请求
app.delete('/user', function (req, res) {
  res.send('Got a DELETE request at /user');
});
```

