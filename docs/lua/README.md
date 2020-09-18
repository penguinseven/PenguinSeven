# lua

## 安装

- 下载

```shell script

$ curl -R -O http://www.lua.org/ftp/lua-5.3.0.tar.gz
$ tar zxf lua-5.3.0.tar.gz
$ cd lua-5.3.0
$ make linux test
$ make install
```

## 命令行模式

```shell script
$ lua -i
```

## 基础数据类型

- `nil` 

```lua

print(type(nil))  --> nil

-- 赋值等于删除
tab1 = {key1="value",key2="value2","value3"}
tab1.key1 = nil
```

- `boolean` 布尔值， false 和 true

```lua
print(type(true)) --> boolean
```

- `number` 表示双精度的浮点类型

```lua
print(type(10.4)) --> number
```

- `string` 字符串

```lua
print(type("hello world")) --> string
```

- `function` 由 C 或 lua 编写的函数

```lua
print(type(type)) --> function
```

- `userdata` 存储在变量中的c数据结构

- `thread` 表示执行的独立线路，用于执行协同程序

- `table` 其实是一个“关联数组”， 数组的索引可以是数字、字符串、表类型

## 变量以及作用域

> Lua 变量有三种类型：全局变量、局部变量、表中的域。

```lua

a = 5           -- 全局变量
local b = 6     -- 局部变量

function joke()
    c = 7       -- 全局变量
    local d = 8 -- 局部变量
end

joke()
print(c,d)      -- 7,nil


do
    local a =6  -- 局部变量
    b = 5       -- 对全局变量重新赋值
    print(a,b)  -- 输出 6,5
end

print(a,b)      -- 输出 5,5

```


## 其他

- 验证

```lua

--> 逻辑或

if true or 0 then
    print("this is true")
else
    print("this is false")
end

--> 数字 0 是true

if 0 then
    print("数字 0 是 true")
else
    print("数字 0 是 false")
end
```

- `table` 默认下表从1开始

```lua
table1 = {"value1","value2"}

for k,v in pairs(table1) do
    print(k .. "-" .. v)
end 
```

- `function` 支持存储在变量里

```lua
-- --------
-- 匿名赋值变量
-- --------
function facto(n)
    if n == 0 then
        return 1
    else
        return n * facto(n-1)
    end
end

print(facto(5))
facto2 = facto
print(facto2(6))
```

- `function` 支持已匿名方式传参

```lua
-- --------
-- 匿名函数
-- --------
function testFunc(tab, fn)
    for k,v in pairs(tab) do
        print(fn(k,v))
    end
end

tab1 = {key1="value1",key2="value2"}
testFunc(tab1,
function(a,b)
    return a .. " - " .. b
end)
```