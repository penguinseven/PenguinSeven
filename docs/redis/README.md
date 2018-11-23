# Redis

## 关于bind
翻看网上的文章，此处多翻译为“指定redis只接收来自于该IP地址的请求，如果不进行设置，那么将处理所有请求，在生产环境中最好设置该项”。这种解释会totally搞糊涂初学者，甚至是错误的。该处的英文原文为

```smartyconfig
  # If you want you can bind a single interface, if the bind option is not 
  # specified all the interfaces will listen for incoming connections. 
  # bind 127.0.0.1
```

该处说明bind的是interface，也就是说是网络接口。服务器可以有一个网络接口(通俗的说网卡)，或者多个。打个比方说机器上有两个网卡，分别为192.168.205.5 和192.168.205.6，如果bind 192.168.205.5，那么只有该网卡地址接受外部请求，如果不绑定，则两个网卡口都接受请求。

OK，不知道讲清楚没有，在举一个例子。在我上面的实验过程中，我是将bind项注释掉了，实际上我还有一种解决方案。由于我redis服务器的地址是 192.168.1.4 。如果我不注释bind项，还有什么办法呢？我可以做如下配置:

```smartyconfig
# bind 192.168.1.4
```

这里很多人会误以为绑定的ip应该是请求来源的ip。其实不然，这里应该绑定的是你redis服务器本身接受请求的ip


> 来源：CSDN 
  原文：https://blog.csdn.net/hel12he/article/details/46911159 
  

## redis.set方法详解
```bash
String set(String key, String value, String nxxx, String expx, long time);
```
该方法是： 存储数据到缓存中，并制定过期时间和当Key存在时是否覆盖。

`nxxx：` 只能取`NX`或者`XX`，如果取`NX`，则只有当key不存在是才进行set，如果取`XX`，则只有当key已经存在时才进行set  

`expx：` 只能取EX或者PX，代表数据过期时间的单位，EX代表秒，PX代表毫秒。  

`time：` 过期时间，单位是expx所代表的单位。  

判断redis是否存在方法：  
```bash
# 的是否为-2，如果是-2,则不存在键。为-1键存在。
1: jedis.get("ts1") 
# 值为true,存在，否则不存在。
2：jedis.exists("ts1") 
```