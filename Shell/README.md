## Shell

### 知识点

#### 1. 条件判断

- if..else..fi

> 测试字符串

条件|意义
:---|:---
$string1 = $string2     |	两个字符串是否相等。Shell 大小写敏感，因此 A 和 a 是不一样的。
$string1 != $string2     |	两个字符串是否不同。
-z $string     |	字符串 string 是否为空。z是 zero 的首字母，是英语「零」的意思。
-n $string     |	字符串 string 是否不为空。n 是英语 not 的首字母，是英语「不」的意思。

EX:
```bash
#!/bin/bash

if [ -z $1 ]
then
    echo "No parameter"
else
    echo "There is parameter"
fi
```

> 测试数字

条件|意义
:---|:---
$num1 -eq $num2 | 两个数字是否相等。和判断字符串所用的符号（ = ）不一样。eq 是 equal 的缩写，是英语「等于」的意思。
$num1 -ne $num2  | 	两个数字是否不同。ne 是 not equal 的缩写，是英语「不等于」的意思。
$num1 -lt $num2  | 	数字 num1 是否小于 num2。lt 是 lower than 的缩写，是英语「小于」的意思。
$num1 -le $num2  | 	数字 num1 是否小于或等于 num2。le 是 lower or equal 的缩写，是英语「小于或等于」的意思。
$num1 -gt $num2  | 	数字 num1 是否大于 num2。gt 是 greater than 的缩写，是英语「大于」的意思。
$num1 -ge $num2  | 	数字 num1 是否大于或等于 num2。ge 是 greater or equal 的缩写，是英语「大于或等于」的意思。

EX:

```bash
#!/bin/bash

if [ $1 -ge 10 ]
then
    echo "You have entered 10 or more"
else
    echo "You have entered less than 10"
fi
```

> 测试文件

条件|意义
:---:|:---
-e $file      |	文件是否存在。e 是 exist 的首字母，表示「存在」。
-d $file      |	文件是否是一个目录。因为 Linux 中所有都是文件，目录也是文件的一种。d 是 directory 的首字母，表示「目录」。
-f $file      |	文件是否是一个文件。f 是 file 的首字母，表示「文件」。
-L $file      |	文件是否是一个符号链接文件。L 是 link 的首字母，表示「链接」。
-r $file      |	文件是否可读。r 是 readable 的首字母，表示「可读的」。
-w $file      |	文件是否可写。w 是 writable 的首字母，表示「可写的」。
-x $file      |	文件是否可执行。x 是 executable 的首字母，表示「可执行的」。
$file1 -nt $file2      |	文件 file1 是否比 file2 更新。nt 是 newer than 的缩写，表示「更新的」。
$file1 -ot $file2      |	文件 file1 是否比 file2 更旧。ot 是 older than 的缩写，表示「更旧的」。

EX:
```bash
#!/bin/bash

read -p 'Enter a directory : ' file

if [ -d $file ]
then
    echo "$file is a directory"
else
    echo "$file is not a directory"
fi

```
#### 2. 函数

### 常见问题