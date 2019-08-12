# Phpunit 单元测试

## 前言

在多次尝试多次失败，再尝试的情况下，跑通了一个测试demo，参考了一些文章

- http://bayescafe.com/php/getting-started-with-phpunit.html

- http://www.yii-china.com/post/detail/460.html

## 安装

巨坑的安装之路，访问phpunit中文网**http://www.phpunit.cn/**，目前提供三个版本
都有对应支持的PHP版本，一定要对号下载。

![介绍](./phpunit-01.png)

然后事情并没有这么简单，所有的下载连接都是**404**

![404](./phpunit-02.png)

机智的我找到了官网，查看**https://phpunit.de/**

```
➜ wget https://phar.phpunit.de/phpunit.phar

➜ chmod +x phpunit.phar

➜ sudo mv phpunit.phar /usr/local/bin/phpunit

➜ phpunit --version
PHPUnit 6.5.0 by Sebastian Bergmann and contributors.
```

下载的版本是最新版本，根据下载的地址，找到了所有的历史版本，**https://phar.phpunit.de/**

![list](./phpunit-03.png)
![list](./phpunit-05.png)

由于我使用的是**PHP 5.6.32 (cli) (built: Nov 28 2017 17:52:20)**，我下载了对应的版本

```
 # 下载
 ➜ wget https://phar.phpunit.de/phpunit-5.6.2.phar
 # 加权限
 ➜ chmod +x phpunit-5.6.3.phar
 # 移目录
 ➜ mv phpunit-5.6.3.phar /usr/local/bin/phpunit
 # 查看版本
 ➜ phpuint --version
```

## 测试项目

### laravel 

- 安装laravel 5.1 

```
➜ composer create-project laravel/laravel your-project-name --prefer-dist "5.1.*"
```

- 执行测试demo

```
➜ phpunit tests
```

![demo](./phpunit-04.png)

#### 简单介绍

- Laravel默认两个文件夹 Feature and Unit
- Unit tests里面文件中的测试主要用来测试比较小，功能相对独立，通常是一个函数
- Feature tests 用来测试比较大的，通常是测试一个完成的HTTP请求，返回一个JSON

#### 使用方法

- Laravel提供了命令行操作
``` 
$ php artisan make:test UserTest                //创建Feature测试
 
$ php artisan make:test UserTest --unit         //创建unit测试
```

- 然后phpstorm快捷键 `shift + Ctrl + F10`

#### 测试Demo

```php
<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithoutMiddleware;

class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     *
     * @return void
     */
    public function testBasicTest()
    {
        $response = $this->get('/');

        $response->assertStatus(200);
    }
}
```


### yii 

### 安装

- 源码安装

```
➜ wget https://github.com/yiisoft/yii2/releases/download/2.0.12/yii-basic-app-2.0.12.tgz

➜ tar -zxvf yii-basic-app-2.0.12.tgz
```

- `composer` 安装

```
➜ composer create-project --prefer-dist yiisoft/yii2-app-basic basic
```

### 部署 

-  nginx 文件指向 **basic/web/** 目录, rewrite规则

```nginxconfig
location / {
        # Redirect everything that isn't a real file to index.php
        try_files $uri $uri/ /index.php$is_args$args;
    }
```

### 执行

```bash
$ vendor/bin/codecept run
```


### 为指定模型创建测试用例

```bash
$ vendor/bin/codecept generate:test unit models/Subject
```

> 生成 `tests/unit/models/SubjectTest.php`


