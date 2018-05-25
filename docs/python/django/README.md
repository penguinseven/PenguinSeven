# Django

## 安装

```bash
sudo pip install Django
```

## 初始化项目

```bash
django-admin startproject weDjango
```

## 启动项目

```bash
python manage.py runserver
```

## 后台admin

- 创建用户

- 访问

## 创建应用

- 创建

```bash
python manage.py startapp blog
```

- 修改配置,添加应用

```python
# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'blog'
]
```

- 解析应用目录

```bash

```