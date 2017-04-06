# electron

### 1. 安装node 

### 2. 调试工具  
 
 该工具基于 Electron 
 将 Node.js 和 Chromium 的功能融合在了一起。
 它的目的在于为调试、分析和开发 Node.js 应用程序提供一个简单的界面。
 
 你可以使用 npm 来安装它:
    ```cmd
     npm install -g devtool
    ```
 
### 3. 实例
 
 - git检出项目
 
 ```cmd
    git clone https://github.com/bojzi/sound-machine-electron-guide.git
 ```
 - npm 安装
 
 ```cmd
    npm install
 ``` 
 - 安装electron (当前安装)
 
 ```cmd
    npm install --save-dev electron-prebuilt
 ```
 - 运行
 
 ```cmd
    npm start
 ```
### 4. 单独安装electron
 安装Electron开发环境
 进行Electron开发之前，先要部署开发环境，在有node.js开发环境的基础上，可以通过npm进行开发环境的安装。
 
 安装有两种方式
 
 - 全局安装
 
 ```cmd
 # Install the `electron` command globally
  npm install electron-prebuilt -g
 ```
 - 当前目录下安装
 
 ```cmd
 # Install as a development dependency
 npm install electron-prebuilt --save-dev
 ```
 二者选一个即可。
 
 安装完成后建立app目录，
 然后将官网的quick-start中的内容分别拷贝到
 package.json，main.js，index.html下。
 
 运行命令
 
 ```cmd
  cd app
  electron .
 ```
 即可看到程序运行。
  
