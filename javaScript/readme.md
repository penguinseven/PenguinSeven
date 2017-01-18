## JavaScript
### 常见问题

#### 1. 百度云盘web下载大文件
```javascript
window.navigator.__defineGetter__ ('platform', function () {return ''});
```

#### 2.浏览器复制
```javascript
var reg = document.querySelector('.register-str');
    reg.select(); // 选中
    document.execCommand("Copy"); // 执行浏览器复制命令
```