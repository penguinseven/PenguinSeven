# akaunting

## 安装

- 拷贝项目

```bash
$ git clone https://github.com/akaunting/akaunting.git
$ cd akaunting
$ composer install
$ cp .env.example .env
$ php artisan key:generate
```

- 配置文件，安装

```bash
$ php artisan install --db-host=localhost \
--db-name=akaunting \
--db-username=akaunting \
--db-password=akaunting \
--company-name=风筝树
```