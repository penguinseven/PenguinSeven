# koel 二次开发 

## 项目介绍
将koel 项目加入网易163音乐接口

###　参考项目

- [koel](https://github.com/phanan/koel)

- [网易云音乐](https://github.com/sqaiyan/netmusic-node)

- [网易云音乐nodejs api](https://github.com/Binaryify/NeteaseCloudMusicApi)

- [网易云音乐命令行版本](https://github.com/darknessomi/musicbox)

### 涉及相关

#### 1. 登录
- AES 加密
    
   >AES加密的具体算法为:AES-128-CBC，输出格式为base64  
    AES加密时需要指定iv：0102030405060708  
    AES加密时需要padding
     
  - python
    
  ```python
    def aesEncrypt(text, secKey):
        pad = 16 - len(text) % 16
        text = text + pad * chr(pad)
        encryptor = AES.new(secKey, 2, '0102030405060708')
        ciphertext = encryptor.encrypt(text)
        ciphertext = base64.b64encode(ciphertext)
        return ciphertext
  ```
  
   - node
  
  ```node
   function aesEncrypt(text, secKey) {
        const _text = text
        const lv = new Buffer('0102030405060708', "binary")
        const _secKey = new Buffer(secKey, "binary")
        const cipher = crypto.createCipheriv('AES-128-CBC', _secKey, lv)
        let encrypted = cipher.update(_text, 'utf8', 'base64')
        encrypted += cipher.final('base64')
        return encrypted
    }
  ```
  
  - php
  
  ```php
          /**
           * AES 加密
           *
           * @param $text
           * @param $secKey
           * @return string
           * @author: ManJi
           */
          public function aesEncrypt($text, $secKey)
          {
         
              $encrypted = openssl_encrypt($text, 'aes-128-cbc', $secKey, OPENSSL_RAW_DATA, self::IV);
              return base64_encode($encrypted);
          }
  ```

- RSA 加密 
    - node
    
    ```node
     function rsaEncrypt(text, pubKey, modulus) {
        var _text = text.split('').reverse().join('');
        var biText = bigInt(new Buffer(_text).toString('hex'), 16),
        biEx = bigInt(pubKey, 16),
        biMod = bigInt(modulus, 16),
        biRet = biText.modPow(biEx, biMod);
        return zfill(biRet.toString(16), 256);
     }
    ```
    
    - python 
     
    ```python
        def rsaEncrypt(text, pubKey, modulus):
            text = text[::-1]
            rs = int(text.encode('hex'), 16)**int(pubKey, 16)%int(modulus, 16)
            return format(rs, 'x').zfill(256)
    ```
    
    - gmp 扩展 (失败)
        
        - biginteger
        
        ```bash
          $ composer require phpmath/biginteger
        ```
        
        - 编译安装gmp （失败）
        
        ```bash
          # 下载
          $ wget https://ftp.gnu.org/gnu/gmp/gmp-6.1.2.tar.xz
          #解压
          $ zx -d gmp-6.1.2.tar.xz
          $ tar -xvf gmp-6.1.2.tar
          #安装
          $ ./configure
          $ make &&　make install
        ```
        
        - `apt-get` 安装 `php7.1-gmp`
        
        ```bash
          # 仅Ubuntu，debian(8.3)源只有 php5-gmp   
          $ apt-get install php7.1-gmp
        ```
        
        > 扩展安装成功，`biginteger`可以使用，但是还是扛不住运算
        
        ```php
                $biText =new BigInteger(base_convert(bin2hex($_text),16,10));
        
                $biEx = new BigInteger(base_convert($pubKey, 16, 10));
        
                $biMod = new BigInteger(base_convert($modulus,16,10));
                 
               // 求次方值，系统扛不住
                $biText->pow($biEx->getValue());
        ```
    

## 项目结构

## 项目
