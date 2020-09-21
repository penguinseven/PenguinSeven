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

-- -------
-- string 定义方式
-- -------

a = "string 1"
b = 'string 2'
c = [[string 3]]


-- ----------
-- string 函数
-- ----------

-- 字符串转大写
print(string.upper(a))

-- 字符串转小写
print(string.lower(b))

-- 字符替换
print(string.gsub(c, "str", "arr", 1))

-- 字符查找
print(string.find("this is lua test", "lua"))

-- 字符反转
print(string.reverse("lua"))

-- 字符格式化
print(string.format("this is : %d",3))

-- 字符长度
print(string.len("this is logo"))

-- 字符截取
print(string.sub("this is long", 3 , 9))

-- ----------
-- 杨辉三角
-- ---------

str = ""
a = 24

for i=0, a
do
   if i > (a/2) then
        str = string.rep("*", 2*(a-i)+ 1)
   else
        str = string.rep("*", 2*i + 1)
   end

   space = string.rep(" ", math.abs(a/2-i))

   print(space .. str)
end


```

- `function` 由 C 或 lua 编写的函数

```lua
print(type(type)) --> function

-- ---------
-- 可变参数
-- ---------

function add(...)
  local s = 0
  for i,v in ipairs{...}
  do
          s = s + i
  end
  return s
end


print(add(4,5,6,7,8))


-- --------------
-- 最大值，多值返回
-- --------------

function maxValue(a)
  local maxK = 1
  local maxV = a[maxK]

  for k,v in ipairs(a)
  do
      if v > maxV
      then
          maxK = k
          maxV = v
      end
  end

  return maxV,maxK
end

```

- `userdata` 存储在变量中的c数据结构

- `thread` 表示执行的独立线路，用于执行协同程序

- `table` 其实是一个“关联数组”， 数组的索引可以是数字、字符串、表类型

## 变量以及作用域

> Lua 变量有三种类型：全局变量、局部变量、表中的域。

- 作用域

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

- 赋值语句

```lua
-- 拼接语句
a = "hello" .. " " .. " word"

-- 多个变量同时赋值
a,b = 0,1

-- 个数不匹配时
a,b = 1     <--> a=1;b=nil
a,b = 1,2,3   <--> a=1;b=2 多余的被忽略

```

- 索引

> 对 table 的索引使用方括号 []。Lua 也提供了 . 操作。

```lua
site = {}
site["key"] = "www.baidu.com"

print(site['key'])
print(site.key)
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