# Backup

## spatie/laravel-backup

### 安装

- 使用composer安装

```bash
$ composer require "spatie/laravel-backup:^3.0.0"
```

- 注册服务提供者（config/app.php）

```php
'providers' => [
    // ...
    Spatie\Backup\BackupServiceProvider::class,
];
```

- 发布配置文件`config/laravel-backup.php`

```bash
$ php artisan vendor:publish --provider="Spatie\Backup\BackupServiceProvider"
```
