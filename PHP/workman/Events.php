<?php
/**
 * This file is part of workerman.
 */

/**
 * 用于检测业务代码死循环或者长时间阻塞等问题
 * 如果发现业务卡死，可以将下面declare打开（去掉//注释），并执行php start.php reload
 * 然后观察一段时间workerman.log看是否有process_timeout异常
 */
// declare(ticks=1);

use \GatewayWorker\Lib\Gateway;
use \Workerman\Lib\Timer;

/**
 * 主逻辑
 * 主要是处理 onConnect onMessage onClose 三个方法
 * onConnect 和 onClose 如果不需要可以不用实现并删除
 */

    // 心跳间隔15秒
    define('DATAPACKET_TIME', 15);
    define('HEARTBEAT_TIME', 10);
    define('WEBAPP', realpath(dirname(__FILE__) . '/../../../') . '/');
    define('LOGGER', WEBAPP . 'Temporary/Logger/');
    define('LOG_PREFIX', 'workerman_server');


    // 初始化状态
    $packArr = array();
    $getSwitch = new getSwitch();
    $list = $getSwitch->off_all_terminal(0);

    if(is_string($list)){
        echo $list . PHP_EOL;
    }

class Events {

    /**
     * 当businessWorker进程启动时触发
     * @param $businessWorker
     */
    public static function onWorkerStart($businessWorker) {

        self::_echo("PS : ", " waiting for client ..." . PHP_EOL, true);
    }


    /**
     * 当businessWorker进程退出时触发
     * @param $businessWorker
     */
    public static function onWorkerStop($businessWorker) {

        self::_echo("PS : ", "The paperless WorkerStop ... "  . PHP_EOL, true);
    }

    /**
     * 当客户端连接时触发
     * 如果业务不需此回调可以删除onConnect
     *
     * @param int $client_id 连接id
     */
    public static function onConnect($client_id) {

        self::_echo($client_id, " # new connection from client, IP:" . $_SERVER['REMOTE_ADDR'].":" .$_SERVER['REMOTE_PORT'] . PHP_EOL, true);


        // 连接过期时间监测
        Timer::add(1, function(){
            $connections = Gateway::getAllClientSessions();
            $time_now = time();

            foreach($connections as $client_id => $session) {

                // 心跳包时间间隔
                if (!empty($session['lastMessageTime']) && $time_now - $session['lastMessageTime'] > HEARTBEAT_TIME) {

                    self::_echo($client_id, '> '. '!!! # HeartBeat time Waiting overtime,' . HEARTBEAT_TIME . PHP_EOL, true);
                }

                // 有可能该connection还没收到过消息，则lastMessageTime设置为当前时间
                if (empty($session['lastMessageTime'])) {

                    Gateway::updateSession($client_id, array(
                        'lastMessageTime'   => $time_now
                    ));

                    continue;
                }

                // 上次通讯时间间隔大于心跳间隔，则认为客户端已经下线，关闭连接
                if ($time_now - $session['lastMessageTime'] > DATAPACKET_TIME) {

                    self::_echo($client_id, " # Waiting overtime " . DATAPACKET_TIME .", IP:" . $_SERVER['REMOTE_ADDR'].":" .$_SERVER['REMOTE_PORT']. PHP_EOL, true);

                    Gateway::closeClient($client_id);

                    if(isset($session["iServerID"]) && $session["iServerID"] > 0){
                        $getSwitch = new getSwitch();
                        $info = $getSwitch->off_all_terminal($session["iServerID"]);

                        if(is_string($info)){
                            self::_echo($client_id, '> '. '! # ' . iconv("utf-8", "GBK",$info). PHP_EOL, true);
                        }
                    }
                }

            }
        });
    }

   /**
    * 当客户端发来消息时触发
    * @param int $client_id 连接id
    * @param mixed $message 具体消息
    */
   public static function onMessage($client_id, $message) {

       // 记录时间心跳测试
       Gateway::updateSession($client_id, array(
           'lastMessageTime'   => time()
       ));

       self::on_message($client_id, $message);
   }

   /**
    * 当用户断开连接时触发
    * @param int $client_id 连接id
    */
   public static function onClose($client_id) {

       $iServerID= isset($_SESSION['iServerID']) ?$_SESSION['iServerID'] :0;

        if(isset($iServerID) && $iServerID > 0){
            $getSwitch = new getSwitch();
            $info = $getSwitch->off_all_terminal($iServerID);

            if(is_string($info)){
                self::_echo($client_id, '> '. '! # ' . iconv("utf-8", "GBK",$info). PHP_EOL, true);
            }
        }

        self::_echo($client_id, " # connection closed client , IP:" . $_SERVER['REMOTE_ADDR'].":" . $_SERVER['REMOTE_PORT'] . PHP_EOL, true);
    }

    /**
     * 数据连接
     * @param $connection
     * @param $data
     */
    public static function on_message($connection, $data){

        global $packArr;

        // 残包处理
        if(isset($packArr[$connection]) && !empty($packArr[$connection])){
            $data = $packArr[$connection] . $data;
            unset($packArr[$connection]);
        }

        $head_info = @unpack('a4MSG_TAG_HEADER/CucVer/CucCode/vusMsgType/VulMsgLen/VulSessionId/VulSenderId/vusSeqNo/vusHcrc', $data);

        // 数据合法性验证

        if(strlen($data) < 24){

            $packArr[$connection] = $data;
            self::_echo($connection, '!!!! # error data,String length is not enough :' . $data . PHP_EOL, true);
            Gateway::sendToCurrentClient('# error data : ' . $data . PHP_EOL);
            return;
        }

        if ($head_info === false || $head_info['MSG_TAG_HEADER'] === null || $head_info['MSG_TAG_HEADER'] != 'ITCL') {

            self::_echo($connection, '!!!! # error head:' . $data . PHP_EOL, true);
            Gateway::sendToCurrentClient('# error head : ' . $data . PHP_EOL);
            return;
        }

        $head = pack('a4CCvVVVvv', $head_info['MSG_TAG_HEADER'], $head_info['ucVer'], $head_info['ucCode'], $head_info['usMsgType'], $head_info['ulMsgLen'], $head_info['ulSessionId'], $head_info['ulSenderId'], $head_info['usSeqNo'], $head_info['usHcrc']);

        $use_info = mb_substr($data, 0, $head_info['ulMsgLen']);

        $packet = mb_substr($data, $head_info['ulMsgLen']);

        $use_info = iconv('gbk', 'utf-8', str_replace($head,"",$use_info));

        $body_info = @json_decode($use_info, true);
        if ($body_info === null || strlen($use_info) < ($head_info['ulMsgLen']-24)) {

            $packArr[$connection] = $data;
            self::_echo($connection, '!!!! # error body:' . $data . PHP_EOL, true);
            Gateway::sendToCurrentClient("# error body : " . $data  . PHP_EOL);
            return;

        }else{

            if($body_info['iCmdEnum'] == 101){
                // 记录时间心跳测试
                Gateway::updateSession($connection, array(
                    'lastHeartbeat'   => time()
                ));

                self::_echo($connection, '< ' . iconv("utf-8","GBK",json_encode(array('head' => $head_info, 'body' => $body_info), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, false);
            }else{
                self::_echo($connection, '< ' . iconv("utf-8","GBK",json_encode(array('head' => $head_info, 'body' => $body_info), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, true);
            }
        }


        // 处理业务逻辑
        $session_info = Gateway::getSession($connection);
        $info = self::process_info($list = array (
            'head' => $head_info,
            'body' => $body_info,
            'lstInfo' => array (
                'iRoomID'       => isset($session_info['iRoomID']) ? $session_info['iRoomID'] : null, // 会议室ID
                'iMeetingID'    => isset($session_info['iMeetingID']) ? $session_info['iMeetingID'] : null, // 会议id
                'iServerID'     => isset($session_info['iServerID']) ? $session_info['iServerID'] : null // 服务器ID
        )));

        // 判断输出
        if(empty($info)) {

            self::_echo($connection, '> ' . '# nothing output...' . PHP_EOL, true);
        }else if(is_string($info)){

            self::_echo($connection, '> '. '! # ' . iconv("utf-8", "GBK",$info). PHP_EOL, true);
        }else{

            $result = self::request_info($list, $info);

            Gateway::sendToCurrentClient($result['string']);

            if($result['body']['iCmdEnum'] == 102){

                self::_echo($connection, '> ' . iconv("utf-8", "GBK",json_encode(array('head'=>$result['head'],'body'=>$result['body']), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, false);
            }else{

                self::_echo($connection, '> ' . iconv("utf-8", "GBK",json_encode(array('head'=>$result['head'],'body'=>$result['body']), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, true);

            }

            // 保留会议室id&& 服务器id
            if($list['head']['usMsgType'] == 103 && $info['body']['iResult'] == 200){

                Gateway::bindUid($connection, $list['body']['iServerID']);

                Gateway::updateSession($connection, array(
                    'iRoomID'   => $info['body']['iMeetRoomID'],
                    'iServerID' => $list['body']['iServerID']
                ));

                //  C server 服务器异常断开， 自动下发会议
                $getSwitch = new getSwitch();
                $check = $getSwitch->check_server($list['body']['iServerID']);

                if(!empty($check)){

                    $check_info = self::process_info($check_list = array(
                        'head' => $head_info,
                        'body' => array(
                            'iCmdEnum'      => 150,
                            'lstServerId'   => array($list['body']['iServerID']),
                            'iMeetingID'    => $check['id']
                        ),
                        'lstInfo' => array()
                    ));

                    Gateway::updateSession($connection, array(
                        'iMeetingID'   => $check_info['body']['iMeetingID']
                    ));

                    $check_result = self::request_info($check_list, $check_info);
                    Gateway::sendToCurrentClient($check_result['string']);

                    self::_echo($connection, '# The server has a meeting ,mid : '. $check_info['body']['iMeetingID'] . PHP_EOL, true);
                    self::_echo($connection, '> '. iconv("utf-8","GBK",json_encode(array('head'=>$check_result['head'],'body'=>$check_result['body']), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, true);

                }
            }else if($list['head']['usMsgType'] == 103 && $info['body']['iResult'] == 400){
                // 注册失败关闭连接
                Gateway::closeClient($connection);
            }

            // 判断是否广播
            if (isset($info['broadcast']) && $info['broadcast'] == true) {

                foreach ($info['lstServerId'] as $iServerId) {

                    // 如果不在线就先存起来
                    if (!Gateway::isUidOnline($iServerId)) {
                        // 假设有个your_store_fun函数用来保存未读消息(这个函数要自己实现)
                        //your_store_fun($iServerId);
                    } else {
                        // 在线就转发消息给对应的uid
                        Gateway::sendToUid($iServerId, $result['string']);

                        // 修改服务器ID数据
                        $result['head']['ulSenderId'] = $iServerId;

                        $client_id = Gateway::getClientIdByUid($iServerId)[0];

                        if($result['body']['iCmdEnum'] == 150){

                        Gateway::updateSession($client_id, array(
                            'iMeetingID'   => $result['body']['iMeetingID']
                        ));
                    }

                        self::_echo($client_id, '> # The broadcast ' . iconv("utf-8", "GBK", json_encode(array('head'=>$result['head'],'body'=>$result['body']), JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)) . PHP_EOL, true);

                    }

                }
            }
        }

        // 处理粘包
        if(!empty($packet) && strlen($packet) > 24){

            self::_echo($connection, "# The data packet warning : " . $data . PHP_EOL, true);

            self::on_message($connection, $packet);
        }
    }

    // 业务逻辑处理
    public static function process_info($data) {

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
    public static function request_info($data, $output){

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
    public static function _echo($id, $message, $type) {

        $message = $id . strftime(' %H:%M:%S ', time()) . $message;
        echo $message . PHP_EOL;

        if($type){
            $directory = defined('LOGGER') ? constant('LOGGER') : '';
            $log_prefix = defined('LOG_PREFIX') ? constant('LOG_PREFIX') : __FILE__;
            file_put_contents(strftime($directory . $log_prefix . '_%Y%m%d.log', time()), $message, FILE_APPEND);
        }
    }
}
