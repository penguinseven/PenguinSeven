




## 综合 >>>>

## 1. 开发 larvael + vue 项目

## 2. workman 知识点总结

- ### 常用名词解释

    1. 并发连接数  
    
        并发连接数是指服务器当前时刻一共维持了多少TCP连接，
        而这些连接上是否有数据通讯并不关注，
        例如一台消息推送服务器上可能维持了百万的设备连接，
        由于连接上很少有数据通讯，所以这台服务器上负载可能几乎为0，
        只要内存足够，还可以继续接受连接。
        
        并发连接数受限于服务器内存，
        一般24G内存workerman服务器可以支持大概120W并发连接。

    2. 并发请求数
    
        并发请求数一般用QPS（服务器每秒处理多少请求）来衡量，
        而当前时刻服务器上有多少个tcp连接并不十分关注。
        例如一台服务器只有10个客户端连接，
        每个客户端连接上每秒有1W个请求，
        那么要求服务端需要至少能支撑10*1W=10W每秒的吞吐量（QPS）。
        假设10W吞吐量每秒是这台服务器的极限，
        如果每个客户端每秒发送1个请求给服务端，
        那么这台服务器能够支撑10W个客户端。
        
        并发请求数受限于服务器cpu处理能力，
        一台24核workerman服务器可以达到45W每秒的吞吐量(QPS)，
        实际值根据业务复杂度以及代码质量有所变化。
    
    3. 非阻塞
    
    4. 异步
        
        
        
- ### ReactPHP相关
    1. react/mysql
    1. react/redis
    1. react/dns  
    1. react/http-client        http 组件
    1. react/zmp && react/stomp 异步消息队列
    1. react/child-process      进程控制组件

## 3. electron 项目

## 4. upupw 知识点总结  
    
 - ### apache 优化配置
 - ### nginx 优化配置
 - ### php 优化配置
 
## 5. Linux shell 脚本
 - ### nginx-rtmp

## 6. Python 开发

## 7. 流媒体服务器

### 协议选择
 
    延迟要求，是否要求低于5秒的延迟?如果是硬指标，
    就只能选择RTMP或HTTP-FLV流。移动端需要自己编译FFMPEG支持，无法直接播放。
    
    终端适配，是否要求支持PC和移动端(IOS和Android)?
    如果需要广泛支持移动端，HLS是最好的选择。
    
    节约带宽，是否要求支持WebP2P?如果需要支持FlashP2P，
    或者移动端P2P，选择HLS。
 
 - ### nginx-rtmp
 - ### red5
 - ### simple rtmp server
 
 
## 8. 账号

- 订阅号 ： penguin71229@gmail.com
- 小程序：penguinseven@sina.com
- 开放平台：penguinseven@qq.com

## 9.链接

<p>Hosted by <a href="https://pages.coding.me" style="font-weight: bold">Coding Pages</a></p>
 
