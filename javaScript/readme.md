## JavaScript
### 常见问题

#### 1. 百度云盘web下载大文件
```javascript
window.navigator.__defineGetter__ ('platform', function () {return ''});
```