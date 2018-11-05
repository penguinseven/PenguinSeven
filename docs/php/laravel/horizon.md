# horizon

> Laravel Horizon ，它为 Laravel Redis 队列提供了一个漂亮的仪表板和代码驱动的配置系统。此工具完全开源，你可以在 GitHub 上找到它

## 安装

- 引入依赖

```bash
$ composer require laravel/horizon
```

- 安装之后使用`vendor:publish`命令

```bash
$ php artisan vendor:publish --provider="Laravel\Horizon\HorizonServiceProvider"
```

## 配置