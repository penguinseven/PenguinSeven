# 常见问题

> 1. 任务队列
---
```php
        
        //  查询任务定时器
        Timer::add(1, function () use (&$queue, $getSwitch) {
    
            $list = $getSwitch->get_all_task();  // 从数据库里查询出来的数组，条件是状态为0，逻辑ID做数组下标
    
            $task = array_diff_key($list, $queue);
    
            $queue = array_merge($queue, $task);
    
        });
        
        // 处理数据
        Timer::add(0.2, function () use (&$queue, $getSwitch) {
    
            $bunk = current($queue);
    
            $getSwitch->set_task_status((int)$bunk['id'], 1); // 修改状态为1
    
            $task = array_shift($queue);  // 修改状态再弹出数组
    
            // 重置内部指针
            reset($queue);
    
            /* CODE 处理$task任务 */
    
    
        });
```
问题1：

1. 任务重复（需要锁）