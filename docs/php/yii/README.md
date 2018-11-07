# YII 

## 安装

### 下载文件

```bash
# 基础版
$ wget https://github.com/yiisoft/yii2/releases/download/2.0.12/yii-basic-app-2.0.12.tgz
#高级版
$ wget https://github.com/yiisoft/yii2/releases/download/2.0.12/yii-advanced-app-2.0.12.tgz
```

### 项目初始化

- 解压文件

```bash
$ cd advanced 
$ php init
```
输出
```bash
Yii Application Initialization Tool v1.0

Which environment do you want the application to be initialized in?

  [0] Development
  [1] Production

  Your choice [0-1, or "q" to quit] 0

  Initialize the application under 'Development' environment? [yes|no] yes

  Start initialization ...

   generate backend/config/main-local.php
   generate backend/config/params-local.php
   generate backend/config/test-local.php
   generate backend/web/index-test.php
   generate backend/web/index.php
   generate common/config/main-local.php
   generate common/config/params-local.php
   generate common/config/test-local.php
   generate console/config/main-local.php
   generate console/config/params-local.php
   generate frontend/config/main-local.php
   generate frontend/config/params-local.php
   generate frontend/config/test-local.php
   generate frontend/web/index-test.php
   generate frontend/web/index.php
   generate yii
   generate yii_test
   generate yii_test.bat
   generate cookie validation key in backend/config/main-local.php
   generate cookie validation key in frontend/config/main-local.php
      chmod 0777 backend/runtime
      chmod 0777 backend/web/assets
      chmod 0777 frontend/runtime
      chmod 0777 frontend/web/assets
      chmod 0755 yii
      chmod 0755 yii_test

  ... initialization completed.

```
- 修改数据库配置文件

```bash
$ vi common/config/main-local.php
```

修改数据库，用户，密码
```php
<?php
return [
    'components' => [
        'db' => [
            'class' => 'yii\db\Connection',
            'dsn' => 'mysql:host=localhost;dbname=advanced_yii',
            'username' => 'root',
            'password' => 'root',
            'charset' => 'utf8',
        ],
        'mailer' => [
            'class' => 'yii\swiftmailer\Mailer',
            'viewPath' => '@common/mail',
            // send all mails to a file by default. You have to set
            // 'useFileTransport' to false and configure a transport
            // for the mailer to send real emails.
            'useFileTransport' => true,
        ],
    ],
];

```

- 创建数据表

```bash
$ php yii migrate
```

输出
```bash
Yii Migration Tool (based on Yii v2.0.10)

Creating migration history table "migration"...Done.
Total 1 new migration to be applied:
	m130524_201442_init

Apply the above migration? (yes|no) [no]:yes
*** applying m130524_201442_init
    > create table {{%user}} ... done (time: 0.010s)
*** applied m130524_201442_init (time: 0.048s)


1 migration was applied.

Migrated up successfully.

```

## 数据库

### 高级版，数据库信息

```mysql
-- ----------------------------
-- Table structure for `user`
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `auth_key` varchar(32) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `password_reset_token` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `role` smallint(6) NOT NULL DEFAULT '10',
  `status` smallint(6) NOT NULL DEFAULT '10',
  `created_at` int(11) NOT NULL,
  `updated_at` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
```


## 项目详解

### YII模块化

- 新增模块, 注意在module下创建一个**article**文件夹，便于区分子模块

```bash

# module class
app\modules\article\Article

# module id
article
```

- 配置, 基础版将该内容复制的**config\web.php** 的 **$config**变量中，
高级版，将内容复制到**config\main.php**中。

```php

<?php
    ......
    'modules' => [
        'article' => [
            'class' => 'frontend\modules\article\Article',
        ],
    ],
    ......
```

- 使用

父模块调用

```php

<?php

// 获取子模块
$article = Yii::$app->getModule('article');

// 调用子模块的操作
$article->runAction('default/index');
```

路径直接访问

```textmate
# 基础版
url : http://localhost/index.php?r=article/default/index

# 高级版
url : http://localhost/index.php?r=article/default/index
```

再次创建子模块

```bash

# module class
app\modules\article\modules\category\Category

# module id
category
```

配置，修改文件 **frontend\module\article\Article.php**

```php
<?php
 /**
     * @inheritdoc
     */
    public function init()
    {
        parent::init();

        $this->modules = [
            'category' => [
                'class' => 'frontend\modules\article\modules\category\Category',
            ],
        ];
        // custom initialization code goes here
    }
    
```

**category**模块的访问路径

```textmate
url : http://localhost/index.php?r=article/category/default/index
```

##  常见问题

### 查询构建器使用**ifnull**会出错 `->select()` 

如何为非数组

```php
<?php
$query->select('id',"IFNULL(id,0)");
```

获取sql之后

```php
'id',ifnull(id, `0)` AS `sVIPChargeAmount`
```

`->select()` 值不是数组，会直接过滤,解决办法:

```php
<?php
$columns = preg_split('/\s*,\s*/', trim($columns), -1, PREG_SPLIT_NO_EMPTY);
```

改为：
```php
<?php
$query->select(['id',"IFNULL(id,0)"]);

```

### 数据查询 `orderBy rand()`

- SQL 随机抽取十名幸运用户

```php
<?php

$query = new Query;             
$query->select('ID, City,State,StudentName')
      ->from('student')                               
      ->where(['IsActive' => 1])
      ->andWhere(['not', ['State' => null]])
      ->orderBy(['rand()' => SORT_DESC])
      ->limit(10);

 // updated orderBy('rand()') 可能查出重复数据，框架自动去重，追加条件 “->distinct()”, 正确查出10条
 
 
```

### 开启GII

- 基础版，修改config\web.php文件，**allowedIPs**

```php
<?php
if (YII_ENV_DEV) {
    // configuration adjustments for 'dev' environment
    $config['bootstrap'][] = 'debug';
    $config['modules']['debug'] = [
        'class' => 'yii\debug\Module',
        'allowedIPs' => ['*.*.*.*','127.0.0.1', '::1'], ,  // 新增
    ];

    $config['bootstrap'][] = 'gii';
    $config['modules']['gii'] = [
        'class' => 'yii\gii\Module',
        'allowedIPs' => ['*.*.*.*','127.0.0.1', '::1'],  // 新增
    ];
}
```

- 高级版， 修改config\main-local.php文件，**allowedIPs**

```php
<?php
if (!YII_ENV_TEST) {
    // configuration adjustments for 'dev' environment
    $config['bootstrap'][] = 'debug';
    $config['modules']['debug'] = [
        'class' => 'yii\debug\Module',
        'allowedIPs' => ['*.*.*.*','127.0.0.1', '::1'],  // 新增
    ];

    $config['bootstrap'][] = 'gii';
    $config['modules']['gii'] = [
        'class' => 'yii\gii\Module',
        'allowedIPs' => ['*.*.*.*','127.0.0.1', '::1'], // 新增
    ];
}
```