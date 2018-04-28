<?php

    use Workerman\Worker;
    use Workerman\Lib\Timer;
    use Workerman\Connection\TcpConnection;

    require_once './Workerman/Autoloader.php';
    require_once './getSwitch.php';

    define('WEBAPP', realpath(dirname(__FILE__) . '/..') . '/');
    define('LOGGER', WEBAPP . 'Temporary/Logger/');
    define('LOG_PREFIX', 'workerman_server');

    // 是否以守护进程的方式运行(window 下无效)
    //Worker::$daemonize = true;

    // 将屏幕打印输出到Worker::$stdoutFile指定的文件中（进程守护前提下有效）
    //Worker::$stdoutFile = './stdout.log';

    // 设置所有连接的默认应用层发送缓冲区大小（单位：字节）
    TcpConnection::$defaultMaxSendBufferSize = 8*1024*1024;

    // 设置每个连接接收的数据包最大为10MB（单位：字节）
    TcpConnection::$maxPackageSize = 10*1024*1024;

    // 创建一个Worker监听88端口，不使用任何应用层协议
    $tcp_worker = new Worker("tcp://0.0.0.0:88");

    // 传输层协议使用tcp协议
    $tcp_worker->transport = 'tcp';

    // 启动4个进程对外提供服务
    $tcp_worker->count = 1;

    // 心跳间隔15秒
    define('HEARTBEAT_TIME', 15);

    // 服务器初始化
    $getSwitch = new getSwitch();
    $getSwitch->off_all_terminal(0);

    // 当worker运行时
    $tcp_worker->onWorkerStart = function($worker){

        echo " waiting for client ..." . PHP_EOL;

        // 心跳包过期时间监测
        Timer::add(1, function()use($worker){
            $time_now = time();
            foreach($worker->connections as $connection) {

                // 有可能该connection还没收到过消息，则lastMessageTime设置为当前时间
                if (empty($connection->lastMessageTime)) {
                    $connection->lastMessageTime = $time_now;
                    continue;
                }

                // 上次通讯时间间隔大于心跳间隔，则认为客户端已经下线，关闭连接
                if ($time_now - $connection->lastMessageTime > HEARTBEAT_TIME) {

                    _echo($connection->id, " # waiting overtime , ip:  " . $connection->getRemoteIp() . ":" .$connection->getRemotePort() . PHP_EOL, true);

                    $connection->close();

                    if(isset($connection->iServerID) && $connection->iServerID > 0){
                        $getSwitch = new getSwitch();
                        $getSwitch->off_all_terminal($connection->iServerID);
                    }
                }
            }
        });
    };

    // 当客户端连接时触发
    $tcp_worker->onConnect = function ($connection) {

        _echo($connection->id, " # new connection from ip " . $connection->getRemoteIp() . ":" .$connection->getRemotePort() . PHP_EOL, true);

        // 当客户端发来数据时（针对当前客户端）：覆盖了当前worker->onMessage
        $connection->onMessage = "on_message";

        // 当前连接断开时的onClose回调
        $connection->onClose = function ($connection) {

            if(isset($connection->iServerID) && $connection->iServerID > 0){
                $getSwitch = new getSwitch();
                $getSwitch->off_all_terminal($connection->iServerID);
            }

            _echo($connection->id, " # connection closed IP:" . $connection->getRemoteIp() . ":" .$connection->getRemotePort() . PHP_EOL, true);
        };
    };

    // 当客户端发来数据时(针对当前进程有效)（被覆盖）
    $tcp_worker->onMessage = "on_message";


    // 当客户端关闭时触发(被覆盖)
    $tcp_worker->onClose = function ($connection) {

        _echo($connection->id, " # worker closed IP:" . $connection->getRemoteIp() . ":" .$connection->getRemotePort()  . PHP_EOL, true);
    };



    /**
     * 数据连接
     * @param $connection
     * @param $data
     */
    function on_message($connection, $data){

        // 粘包处理
        if(!empty($packet) && strlen($packet) <= 24){
            $data = $packet . $data;
        }

        // 给connection临时设置一个lastMessageTime属性，用来记录上次收到消息的时间
        $connection->lastMessageTime = time();

        $head_info = @unpack('a4MSG_TAG_HEADER/CucVer/CucCode/vusMsgType/VulMsgLen/VulSessionId/VulSenderId/vusSeqNo/vusHcrc', $data);

        // 数据合法性验证
        if ($head_info === false || $head_info['MSG_TAG_HEADER'] === null || $head_info['MSG_TAG_HEADER'] != 'ITCL') {

            _echo($connection->id, '# error head:' . $data . PHP_EOL, true);
            $connection->send('# error head : ' . $data . PHP_EOL);

            return;
        }

        $head = pack('a4CCvVVVvv', $head_info['MSG_TAG_HEADER'], $head_info['ucVer'], $head_info['ucCode'], $head_info['usMsgType'], $head_info['ulMsgLen'], $head_info['ulSessionId'], $head_info['ulSenderId'], $head_info['usSeqNo'], $head_info['usHcrc']);

        $use_info = mb_substr($data, 0, $head_info['ulMsgLen']);

        $packet = mb_substr($data, $head_info['ulMsgLen']);

        $use_info = iconv('gbk', 'utf-8', str_replace($head,"",$use_info));

        $body_info = @json_decode($use_info, true);
        if ($body_info === null) {

            _echo($connection->id, '# error body:' . $data . PHP_EOL, true);
            $connection->send("# error body : " . $data  . PHP_EOL);

            return;
        }else{

            if($body_info['iCmdEnum'] == 101){
                _echo($connection->id, '< ' . iconv("utf-8","GBK",json_encode(array('head' => $head_info, 'body' => $body_info), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, false);
            }else{
                _echo($connection->id, '< ' . iconv("utf-8","GBK",json_encode(array('head' => $head_info, 'body' => $body_info), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, true);
            }
        }


        // 处理业务逻辑
        $info = process_info($list = array(
            'head' => $head_info,
            'body' => $body_info,
            'lstInfo' => array(
                'iRoomID'       => isset($connection->iRoomID) ? $connection->iRoomID : null, // 会议室ID
                'iMeetingID'    => isset($connection->iMeetingID) ? $connection->iMeetingID : null, // 会议id
                'iServerID'     => isset($connection->iServerID) ? $connection->iServerID : null // 服务器ID
            )
        ));

        // 判断输出
        if(empty($info)){

            echo '# nothing output...' . PHP_EOL;
        }else{

            // 保留会议室id&& 服务器id
            if($list['head']['usMsgType'] == 103 && $info['body']['iResult'] == 200){
                $connection->iRoomID = $info['body']['iMeetRoomID'];
                $connection->iServerID = $list['body']['iServerID'];

                // TODO C server 服务器异常断开
                /*$getSwitch = new getSwitch();
                $check = $getSwitch->check_server($connection->iServerID);

                if(!empty($check)){

                    $check_info = process_info($check_list = array(
                        'head' => $head_info,
                        'body' => array(
                            'iCmdEnum'      => 150,
                            'lstServerId'   => array($connection->iServerID),
                            'iMeetingID'    => $check['id']
                        ),
                        'lstInfo' => array()
                    ));

                    $check_result = request_info($check_list, $check_info);
                    $connection->send($check_result['string']);

                    _echo($connection->id, '# The server has a meeting ' . PHP_EOL, true);
                    _echo($connection->id, '> '. iconv("utf-8","GBK",json_encode(array('head'=>$check_result['head'],'body'=>$check_result['body']), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, true);

                }*/
            }

            $result = request_info($list, $info);




            // 判断是否广播
            if (isset($info['broadcast']) && $info['broadcast'] == true) {


                $connection->send($result['string']);

                _echo($connection->id, '> ' . iconv("utf-8","GBK",json_encode(array('head'=>$result['head'],'body'=>$result['body']), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, true);


                foreach ($connection->worker->connections as $con) {

                    if($result['body']['iCmdEnum'] == 150){
                        $con->iMeetingID = $result['body']['iMeetingID'];
                    }

                    // 修改服务器ID数据
                    if(isset($con->iServerID)) {
                        $result['head']['ulSenderId'] = $con->iServerID;
                    }

                    // 指定服务器广播数据

                    if (isset($con->iServerID) && in_array($con->iServerID, $info['lstServerId'])) {
                        $con->send($result['string']);

                        _echo($con->id, '> ' . iconv("utf-8","GBK",json_encode(array('head'=>$result['head'],'body'=>$result['body']), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, true);
                    }
                }
            } else {

                $connection->send($result['string']);

                if($result['body']['iCmdEnum'] == 102){

                    _echo($connection->id, '> ' . iconv("utf-8","GBK",json_encode(array('head'=>$result['head'],'body'=>$result['body']), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, false);
                }else{

                    _echo($connection->id, '> ' . iconv("utf-8","GBK",json_encode(array('head'=>$result['head'],'body'=>$result['body']), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, true);

                }
            }
        }

        // 处理粘包
        if(!empty($packet) && strlen($packet) > 24){

            _echo($connection->id, "# The data packet warning : " . $data . PHP_EOL, true);

            $data = $packet;
            $packet = "";

            on_message($connection, $data);
        }

        if(!empty($packet) && strlen($packet) <= 24){

            _echo($connection->id, "# The data packet error : " . $data . PHP_EOL, true);
        }
    };

    // 业务逻辑处理
    function process_info($data) {

        /**
         * 格式说明：
         * 1，返回数组 array('usMsgType' => 102, 'body' => array('iCmdEnum' => 102))
         * 2，前边是返回的信令号，后边是返回的json字符串编码前数组
         * 3，如果需要广播，添加 'broadcast' => true
         * 4，10001110 信令号为内部标识，用于关闭服务器
         */
        $list = new getSwitch($data['lstInfo']);
        return $list->result($data['body']['iCmdEnum'],  $data['body']);
    }

    // 打包数据
    function request_info($data, $output){

        $data['head']['usMsgType'] = $output['usMsgType'];
        $data['body'] = $output['body'];
        $body = json_encode($data['body'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        $data['head']['ulMsgLen'] = strlen($body) + 24;
        $head = pack('a4CCvVVVvv', $data['head']['MSG_TAG_HEADER'], $data['head']['ucVer'], $data['head']['ucCode'], $data['head']['usMsgType'], $data['head']['ulMsgLen'], $data['head']['ulSessionId'], $data['head']['ulSenderId'], $data['head']['usSeqNo'], $data['head']['usHcrc']);

        return array(
            'head' => $data['head'],
            'body' => $data['body'],
            'string'  => $head . $body
        );
    }

    /**
     *  页面输出
     * @param $id
     * @param $message
     * @param $type
     */
    function _echo($id, $message, $type) {
        $message = $id . strftime(' %H:%M:%S ', time()) . $message;
        echo $message . PHP_EOL;

        if($type){
            $directory = defined('LOGGER') ? constant('LOGGER') : '';
            $log_prefix = defined('LOG_PREFIX') ? constant('LOG_PREFIX') : __FILE__;
            file_put_contents(strftime($directory . $log_prefix . '_%Y%m%d.log', time()), $message, FILE_APPEND);
        }
    }


    // 运行worker
    Worker::runAll();