# laravel

## 运行环境

## 安装

## 项目目录结构

```text
/ 根目录
   └─ swarm ------------------------------------------ 项目目录
       ├─ app --------------------------------- 核心代码目录
       |   ├─ Console --------------------------------------- artisan 自定义命令
       |   ├─ Events --------------------------------------- 应用公共模块
       |   ├─ Exceptions --------------------------------------- 异常处理目录
       |   ├─ Http --------------------------------------- 应用公共模块
       |   ├─ Jobs --------------------------------------- 应用公共模块
       |   ├─ Listeners --------------------------------------- 应用公共模块
       |   ├─ Mail --------------------------------------- 应用公共模块
       |   ├─ Notifications --------------------------------------- 应用公共模块
       |   ├─ Policies --------------------------------------- 应用公共模块
       |   └─ Providers --------------------------------------- 服务提供者
       ├─ bootstrap --------------------------------- 框架启动和自动加载设置的目录
       ├─ config --------------------------------- 配置文件目录
       ├─ database --------------------------------- 数据迁移及填充目录
       ├─ public --------------------------------- 入口目录
       ├─ resources --------------------------------- 视图、原始资源文件目录
       ├─ routes --------------------------------- 路由定义目录
       ├─ storage --------------------------------- 编译后文件目录
       ├─ tests --------------------------------- 自动测试目录
       └─ vendor --------------------------------- composer依赖目录
      
```

## 项目实践

### 1. 路由

### 2. 中间件

### 3. 分页

- `Illuminate\Pagination\LengthAwarePaginator` 实例

    ```php
    // 传入数据，总数据条数，数据显示条数，当前页码
    $list =  new LengthAwarePaginator( $userList['data'], $userList['total'], $userList['per_page'], $userList['current_page'], [
                'path' => '/users'
            ]);
    
    // 附加参数到分页链接
    $list->appends([
        'mobile' => $info['mobile'],
        'status' => $info['status']
    ])->links();
  
    ```
    
    返回结果：
    
    ```json
      {
         "total": 50,
         "per_page": 15,
         "current_page": 1,
         "last_page": 4,
         "next_page_url": "/users?mobile=13761598554&status=1&page=3",
         "prev_page_url": "/users?mobile=13761598554&status=1&page=1",
         "from": 1,
         "to": 15,
         "data":[
              {
                  // Result Object
              },
              {
                  // Result Object
              }
         ]
      }
    ```
    

- `Illuminate\Pagination\Paginator` 实例

    ```php
    
    // 传入数据，总数据条数，数据显示条数，当前页码
    $list =  Paginator( $userList['data'], $userList['total'], $userList['per_page'], $userList['current_page'], [
                'path' => '/users'
            ]);
    
    // 附加参数到分页链接
    $list->appends([
        'mobile' => $info['mobile'],
        'status' => $info['status']
    ])->links();
  
   ```
    
    返回结果：
    
    ```json    
        {
        "per_page": 15,
        "current_page": 2,
        "next_page_url": null,
        "prev_page_url": "/users?mobile=13761598554&status=1&page=1",
        "from": 16,
        "to": 18,
        "data":[
              {
                  // Result Object
              },
              {
                  // Result Object
              }
         ]
        }
    ```

- 返回 JSON
      
  > Laravel 分页器结果类实现了 
  Illuminate\Contracts\Support\Jsonable 
  接口契约并且提供 toJson 方法，
  所以它很容易将你的分页结果集转换为 Json。
      
  ### 常见问题
  
#### 0.Command is not defined exception
      
 - **Laravel 4**
  
 [参见文档](http://laravel.com/docs/4.2/commands#registering-commands)
    
        Add this line to app/start/artisan.php:
        
        Artisan::add(new NeighborhoodCommand);

- **Laravel 5**

[参见文档](http://laravel.com/docs/master/artisan#registering-commands)

Edit your app/Console/Kernel.php file and add your command to the `$commands` array:

    protected $commands = [
        Commands\NeighborhoodCommand::class,
    ];
    
#### 1. 自定义函数

- 创建文件`app/Support/helpers.php`

- 在`composer.json`中添加

```json
"autoload": {
    "classmap": [
      "database"
    ],
    "psr-4": {
      "App\\": "app/"
    },
    "files": [
      "app/Support/helpers.php"
    ]
  }
```

- 执行 `composer dump-autoload`

#### 2. PHP json_decode 函数解析 json 结果为 NULL 的解决方法

- 打印错误
    
       echo $errorinfo = json_last_error();   //输出4 语法错误
       
- 情况一
    
> 出现这个问题是因为在 json 字符串中反斜杠被转义，只需要用 htmlspecialchars_decode() 函数处理一下 $content 即可：
    
    $content = htmlspecialchars_decode($content);
    
- 情况二
    
> 在保存 json 数据时使用 urlencode() 函数：
    
    $content = urlencode(json_encode($content));
    #解析时使用 urldecode() 函数：
    
    $content = urldecode($content);
    #即可避免反斜杠转义造成的无法解析。
    

#### 3. Controller 重写 validate方法,方便报错返回

```php
 /**
     * 重写 validate，把自定义属性名称放到 rules
     *
     * @param Request $request
     * @param array   $rules
     * @param array   $messages
     * @param array   $customAttributes
     */
    public function validate(Request $request, array $rules, array $messages = [], array $customAttributes = [])
    {
        $customAttributes = [];

        if (is_array($rules)) {
            foreach ($rules as $key => $rule) {
                $ruleWithAttr = explode('#', $rule);
                if (count($ruleWithAttr) == 2) {
                    $customAttributes[$key] = $ruleWithAttr[0];
                    $rules[$key] = $ruleWithAttr[1];
                }
            }
        }

        $validator = $this->getValidationFactory()->make($request->all(), $rules, $messages, $customAttributes);

        if ($validator->fails()) {
            $this->throwValidationException($request, $validator);
        }
    }
```

    


