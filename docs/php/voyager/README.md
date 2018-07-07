# VOYAGER

## 简介

laravel 后台管理扩展包

官网：<https://the-control-group.github.io/voyager/>

Github：<https://github.com/the-control-group/voyager>

视频演示：<https://devdojo.com/episode/laravel-admin-package-voyager>

## 安装

- 创建一个现有的**Laravel**项目

  ```
  $ composer create-project laravel/laravel
  ```

  ​

- 引入扩展包

  ```
  $ composer require tcg/voyager
  ```

  ​

- 创建配置文件  **.env**

    ```
    DB_HOST=localhost
    DB_DATABASE=homestead
    DB_USERNAME=homestead
    DB_PASSWORD=secret
    ```

- 然后注册**Voyager**服务提供者以及图片处理服务到配置文件`config/app.php`的`providers`数组：

  ```
  TCG\Voyager\VoyagerServiceProvider::class,
  Intervention\Image\ImageServiceProvider::class,
  ```

  ​

- 最后，我们可以通过以下命令安装Voyager：

  ```
  php artisan voyager:install
  ```
  
  ```
  # 自动生成管理员
  php artisan voyager:install --with-dummy
  ```


- 安装完成后，就可以进入后台查看效果了。最简单的方式是在项目根目录下运行`php artisan serve`，然后在浏览器中访问`http://localhost:8000/admin`，这样就可以进入登录认证页面，我们可以使用如下演示账户：

  ```
  email: admin@admin.com
  password: password
  ```


## 技巧


### 覆盖view

```text
/ flug-info
   ├─ browse.blade.php -------------------- 列表文件
   ├─ edit-add.blade.php ------------------ 编辑文件
  

```

### 自定义Controller

- 配置config/voyager

```php
<?php
 /*
    |--------------------------------------------------------------------------
    | Controllers config
    |--------------------------------------------------------------------------
    |
    | Here you can specify voyager controller settings
    |
    */

    'controllers' => [
            // 'namespace' => 'TCG\\Voyager\\Http\\Controllers',
            'namespace' => 'App\\Http\\Controllers\\Voyager',
        ],
```

- 生成控制器

```bash
php artisan voyager:controllers
```

### 自定义路由& 路由覆盖

```php
<?php

Route::group(['prefix' => 'admin'], function () {

    // Custom
   Route::group(['as'=>'custom.'], function (){

       // 系统设置
       Route::get('/system', ['uses' => 'SystemController@index', 'as' => 'system']);
   });

    // Voyager
    Voyager::routes();

    //Overriding Routes
    // Route::post('login', ['uses' => 'MyAuthController@postLogin', 'as' => 'postlogin']);
});
```


## 安装easyWechat

### 引入扩展包

- 使用`composer`进行安装

```bash 
$ composer require "overtrue/laravel-wechat:~4.0"
```

- 在 `config/app.php` 注册 `ServiceProvider` 和 `Facade` (Laravel 5.5 无需手动注册)
  
```php
 'providers' => [
      // ...
      Overtrue\LaravelWeChat\ServiceProvider::class,
  ],
  'aliases' => [
      // ...
      'EasyWeChat' => Overtrue\LaravelWeChat\Facade::class,
  ],
```

- 创建配置文件：

```bash
$ php artisan vendor:publish --provider="Overtrue\LaravelWeChat\ServiceProvider"
```

- 修改应用根目录下的 `config/wechat.php` 中对应的参数即可。

- 每个模块基本都支持多账号，默认为 `default`。



## 常见问题

### mysql数据库版本低于5.7.7，可能会出现 “Specified key was too long error.”的报错

- 修改App/Providers/AppServiceProvider.php文件，代码如下；

```php
use Illuminate\Support\Facades\Schema;

public function boot()
{
    Schema::defaultStringLength(191);
}
```
  ​