# 常用测试源

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

# 常用命令:

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
```

#### 3. 修改文件创建时间
```php
ffmpeg.exe -i 6.mp4 -metadata creation_time="2013-06-22 15:00:00" -acodec copy -vcodec copy output.mp4
```