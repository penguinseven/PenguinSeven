# Auth
>适用laravel版本5.3+


## auth:web


## auth:api

###  `config/auth.php`文件中

```php
 'api' => [
            'driver' => 'token',
            'provider' => 'users',
        ],
```

###  为User表配置字段

项目下执行命令`php artisan make:migration update_users_table_for_api_token --table=users`生成迁移文件.

### 修改迁移文件

```php
    /**
     * Run the migrations.
     *
     * @return void
     */
  public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            //字段名固定,长度建议32以上
            $table->string('api_token', 64)->unique();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('api_token');
        });
    }
```

### 访问用户信息

```php
Auth::guard('api')->user();
```
