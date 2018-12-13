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

## 常见错误

- 允许`php artisan backup:run`
>   Expected response code 250 but got code "530", with message "530 5.7.1 Authenti  
    cation required                                                                  
    "        
删除或完善`.env`配置文件中的邮箱信息

```ini
MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```
                                                                        
              
