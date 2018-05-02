## FFMPEG 音视频处理

http://elkpi.com/topics/ffmpeg-f-hls.html

### 常用测试源

```cmd
// 香港
rtmp://live.hkstv.hk.lxdns.com/live/hks

// 香港
http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8


// 亚太第一卫视 
rtmp://v1.one-tv.com/live/mpegts.stream

// apple 测试
http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8

// 大熊兔（点播）：
rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov

// CCTV5+高清
http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8

```

### 常用命令:

#### 1. 将视频流推送到流媒体服务器

```bash
ffmpeg -i rtmp://live.hkstv.hk.lxdns.com/live/hks -c:a copy -c:v copy -f flv rtmp://192.168.17.229:5080/oflaDemo/2
```

#### 2. 视频文件转MP4

```bash
# 视频编码转H264,音频编码转aac，文件格式转MP4
ffmpeg -threads {$threads} -i {$old_video} -preset:v ultrafast -tune zerolatency -codec:v h264 -codec:a aac -strict -2 -y {$new_video};

# 文件格式转MP4
ffmpeg -threads {$threads} -i {$old_video} -vcodec copy -acodec copy -y {$new_video} ;

# 音频编码转aac，文件格式转MP4
ffmpeg -threads {$threads} -i {$old_video} -vcodec copy -acodec aac -strict -2 -y {$new_video} ;

# copy 
ffmpeg -i {$input} -c:a copy -c:v copy -f flv {$out} ;
```

#### 3. 修改文件创建时间

```php
ffmpeg.exe -i 6.mp4 -metadata creation_time="2013-06-22 15:00:00" -acodec copy -vcodec copy output.mp4
```

#### 转成mp4 

转码mp4（资源占用很高，允许15个转码 300M*15 = 45000M）

```bash
/home/webserver/server/ffmpeg -threads 8 -i /root/Desktop/name.mp4 \
-r 25 -map 0 -codec:v h264 -b 500k -maxrate 50k -s 1280x720 \
-codec:a aac -strict -2 -ar 44100 -ab 96k \
-y output.mp4
```

#### ssegment点播   

点播切片（资源低，无需限制，可以多线程统一处理已转码视频）

```bash
/home/webserver/server/ffmpeg -threads 8 -i output.mp4 \
-map 0 -codec:v copy -bsf:v h264_mp4toannexb -codec:a copy \
-f ssegment -segment_format mpegts -segment_list video_1.m3u8 -segment_time 15 video_1_%04d.ts
```

#### ssegment直播（没找到参数只保留一个文件）

```bash
/home/webserver/server/ffmpeg -threads 8 -re -i /root/Desktop/name.mp4 \
-profile:v baseline -level 3.0 -tune zerolatency \
-r 25 -map 0 -codec:v h264 -b 500k -maxrate 50k -s 1280x720 \
-codec:a aac -strict -2 -ar 44100 -ab 96k \
-f ssegment -segment_format mpegts -segment_list_flags +live \
-segment_list video_1.m3u8 -segment_time 5 -segment_list_size 1 -segment_size 1 video_1_%04d.ts
```

#### hls转播       

转播（资源占用较低，允许40个转播120M*40 = 4800M内存）

```bash
/home/webserver/server/ffmpeg -threads 8 -re -i /root/Desktop/name.mp4 \
-profile:v baseline -level 3.0 -tune zerolatency \
-r 25 -map 0 -codec:v h264 -b 500k -maxrate 50k -s 1280x720 \
-codec:a aac -strict -2 -ar 44100 -ab 96k \
-f hls -hls_list_size 1 -hls_time 5 -hls_wrap 1 -start_number 1 video_1.m3u8
```