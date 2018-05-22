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


- 安装完成后，就可以进入后台查看效果了。最简单的方式是在项目根目录下运行`php artisan serve`，然后在浏览器中访问`http://localhost:8000/admin`，这样就可以进入登录认证页面，我们可以使用如下演示账户：

  ```
  email: admin@admin.com
  password: password
  ```

  ​