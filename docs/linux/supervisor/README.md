# Supervisor
Supervisor 是Linux的进程监视器。
它会自动启动您的控制台进程。
安装在Ubuntu上，你需要运行命令:

```bash
sudo apt-get install supervisor
```

`Supervisor` 配置文件通常可用` /etc/supervisor/conf.d`。 你可以创建任意数量的配置文件。

## 示例

- 配置示例(Yii2-queue):

```bash
[program:yii-queue-worker]
process_name=%(program_name)s_%(process_num)02d
command=/usr/bin/php /var/www/my_project/yii queue/listen --verbose=1 --color=0
autostart=true
autorestart=true
user=www-data
numprocs=4
redirect_stderr=true
stdout_logfile=/var/www/my_project/log/yii-queue-worker.log
```

在这种情况下，`Supervisor` 会启动4个 `queue/listen` worker。
输出将写入相应日志文件。 
 
- 配置示例(laravel-horizon):
如果你使用 Supervisor 进程监控器管理你的 horizon 进程，
那么以下配置文件则可以满足需求。
 
```bash
 [program:horizon]
 process_name=%(program_name)s
 command=php /home/forge/app.com/artisan horizon
 autostart=true
 autorestart=true
 user=forge
 redirect_stderr=true
 stdout_logfile=/home/forge/app.com/horizon.log
```