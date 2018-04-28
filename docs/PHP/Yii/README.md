# YII 

## 安装

### 下载文件

```bash
# 基础版
$ wget https://github.com/yiisoft/yii2/releases/download/2.0.12/yii-basic-app-2.0.12.tgz
#高级版
$ wget https://github.com/yiisoft/yii2/releases/download/2.0.12/yii-advanced-app-2.0.12.tgz
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

```textmate

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

> 父模块调用

```php
// 获取子模块
$article = Yii::$app->getModule('article');

// 调用子模块的操作
$article->runAction('default/index');
```

> 路径直接访问

```textmate
# 基础版
url : http://localhost/index.php?r=article/default/index

# 高级版
url : http://localhost/index.php?r=article/default/index
```

> 再次创建子模块

```bash

# module class
app\modules\article\modules\category\Category

# module id
category
```

> 配置，修改文件 **frontend\module\article\Article.php**

```text

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

> **category**模块的访问路径

```textmate
url : http://localhost/index.php?r=article/category/default/index
```




##  常见问题

### 开启GII

- 基础版，修改config\web.php文件，**allowedIPs**

```php
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