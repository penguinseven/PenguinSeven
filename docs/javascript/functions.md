# 常用函数

> 1.  判断ie版本
```javascript
function isIE(ver){
	var b = document.createElement('b');
	b.innerHTML = '<!--[if IE ' + ver + ']><i></i><![endif]-->';
	return b.getElementsByTagName('i').length === 1;
};

// for example : 

isIE(6);
isIE(7);
isIE(8);
```

> 2. 获取cookie
```javascript
// w3c获取cookie函数

function getCookie(c_name) {
	if (document.cookie.length > 0) {
		c_start = document.cookie.indexOf(c_name + "=")
		if (c_start != -1) {
			c_start = c_start + c_name.length + 1
			c_end = document.cookie.indexOf(";", c_start)
			if (c_end == -1)
				c_end = document.cookie.length
			return unescape(document.cookie.substring(c_start, c_end))
		}
	}
	return ""
}

```

> 3. 防抖和节流

函数防抖（debounce）：当持续触发事件时，一定时间段内没有再触发事件，
事件处理函数才会执行一次，如果设定的时间到来之前，又一次触发了事件，
就重新开始延时。举个栗子，持续触发scroll事件时，并不执行handle函数，
当1000毫秒内没有触发scroll事件时，才会延时触发scroll事件。

函数节流（throttle）：当持续触发事件时，保证一定时间段内只调用一次事件处理函数。
节流通俗解释就比如我们水龙头放水，阀门一打开，水哗哗的往下流，秉着勤俭节约的优良传统美德，
我们要把水龙头关小点，最好是如我们心意按照一定规律在某个时间间隔内一滴一滴的往下滴。
举个栗子，持续触发scroll事件时，并不立即执行handle函数，每隔1000毫秒才会执行一次handle函数。

- 防抖实例：

```vue
<script>
const delay = (function () {
 let timer = 0
 return function (callback, ms) {
  clearTimeout(timer)
  timer = setTimeout(callback, ms)
 }
})()
export default {
methods：{
fn() {
   delay(() => {
    //执行部分
   }, 500)
}
}
}
</script>
```

- 节流实例：

```javascript

var throttle = function(func, delay) {      
  var timer = null;      
  return function() {        
    var context = this;        
    var args = arguments;        
    if (!timer) {          
      timer = setTimeout(function() {            
        func.apply(context, args);            
        timer = null;          
      }, delay);        
    }      
  }    
}    
function handle() {      
  console.log(Math.random());    
}    
window.addEventListener('scroll', throttle(handle, 1000));


```