# Yii-queue

## 安装

- 安装依赖

```bash
$ composer require --prefer-dist yiisoft/yii2-queue
```

- 报错

```bash
Using version ^2.1 for yiisoft/yii2-queue
./composer.json has been updated
Loading composer repositories with package information
Warning: Accessing packagist.phpcomposer.com over http which is an insecure protocol.
Updating dependencies (including require-dev)
Your requirements could not be resolved to an installable set of packages.

  Problem 1
    - yiisoft/yii2 2.0.15.1 requires bower-asset/inputmask ~3.2.2 | ~3.3.5 -> no matching package fou
    - yiisoft/yii2 2.0.15 requires bower-asset/inputmask ~3.2.2 | ~3.3.5 -> no matching package found
    - yiisoft/yii2 2.0.14.2 requires bower-asset/inputmask ~3.2.2 | ~3.3.5 -> no matching package fou
    - yiisoft/yii2 2.0.14.1 requires bower-asset/inputmask ~3.2.2 | ~3.3.5 -> no matching package fou
    - yiisoft/yii2 2.0.14 requires bower-asset/inputmask ~3.2.2 | ~3.3.5 -> no matching package found
    - yiisoft/yii2-queue 2.1.0 requires yiisoft/yii2 ~2.0.14 -> satisfiable by yiisoft/yii2[2.0.14, 2.2, 2.0.15, 2.0.15.1].
    - Installation request for yiisoft/yii2-queue ^2.1 -> satisfiable by yiisoft/yii2-queue[2.1.0].

Potential causes:
 - A typo in the package name
 - The package is not available in a stable-enough version according to your minimum-stability settin
   see <https://getcomposer.org/doc/04-schema.md#minimum-stability> for more details.
 - It's a private package and you forgot to add a custom repository to find it

Read <https://getcomposer.org/doc/articles/troubleshooting.md> for further common problems.

Installation failed, reverting ./composer.json to its original content.

```

引入包`yidas/yii2-bower-asset`, 在`yiisoft/yii2`之前

```bash
"require": {
    "php": ">=5.4.0",
    "yidas/yii2-bower-asset": "~2.0.5", // 在yii之前
    "yiisoft/yii2": "~2.0.5",
    "yiisoft/yii2-bootstrap": "~2.0.0",
    ...
}
```

执行`composer update`, YII基础库升级至`2.0.15`, 再执行`composer require --prefer-dist yiisoft/yii2-queue`则不会出现以下报错

```bash
Using version ^2.1 for yiisoft/yii2-queue
./composer.json has been updated
Loading composer repositories with package information
Warning: Accessing packagist.phpcomposer.com over http which is an insecure protocol.
Updating dependencies (including require-dev)
Your requirements could not be resolved to an installable set of packages.

  Problem 1
    - Installation request for yiisoft/yii2-queue ^2.1 -> satisfiable by yiisoft/yii2-queue[2.1.0].
    - Conclusion: don't install yiisoft/yii2 2.0.15.1
    - Conclusion: don't install yiisoft/yii2 2.0.15
    - Conclusion: don't install yiisoft/yii2 2.0.14.2
    - Can only install one of: yiisoft/yii2[2.0.14, 2.0.12].
    - Can only install one of: yiisoft/yii2[2.0.14, 2.0.12].
    - Can only install one of: yiisoft/yii2[2.0.14, 2.0.12].
    - yiisoft/yii2-queue 2.1.0 requires yiisoft/yii2 ~2.0.14 -> satisfiable by yiisoft/yii2[2.0.14, 2.2, 2.0.15, 2.0.15.1].
    - Conclusion: don't install yiisoft/yii2 2.0.14.1
    - Installation request for yiisoft/yii2 (locked at 2.0.12, required as ~2.0.6) -> satisfiable by 0.12].


Installation failed, reverting ./composer.json to its original content.

```