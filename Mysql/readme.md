1、总所周知，mysql的命令行执行每一条命令是以分号结尾的，也就是说识别是否为一条命令，是根据分号决定的。
然而存储过程中设计多条语句，很可能出现多个分号，所以直接把存储过程复制到命令号一般都会失败


2、解决方法是需要加一个分隔符，让命令行知道整个存储过程的代码是完整的一块代码,代码如下

```mysql
DELIMITER //     
CREATE PROCEDURE p_name (IN b INTEGER(12))     
begin     
 declare a INTEGER(12);     
 set a=12;     
 INSERT INTO t VALUES (a);     
 SELECT s1* a FROM t;     
End     
//    

```
3、如代码中所示，在存储过程的开头加上“DELIMITER //”,结尾加上“//”就ok了


4、执行后续的sql ，需将结束符重新定义
DELIMITER ；