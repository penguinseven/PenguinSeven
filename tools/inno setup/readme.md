### inno setup 常见问题

#### 1. 系统管理员运行

> Inno Setup打包的程序安装完成后运行失败，
    这个是因为权限不够，我们可以通过下面的办法解决：
  找到Inno Setup安装目录下的SetupLdr.e32文件，
  然后用Resource Hacker软件打开，将Manifest改成

```
<requestedExecutionLevel level="requireAdministrator"            uiAccess="false"/>
```

然后保存，就行啦。

#### 2. 添加程序到右键

```bash
[Registry]
Root: HKCR; Subkey: "*\shell\Open with Notepad\command"; ValueType: string; ValueName: ""; ValueData: "{app}\notepad\notepad++.exe %1";   Flags: deletekey uninsdeletekey;
```

#### 3.开机启动

```bash
[Registry]
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "paperless"; ValueData: "{app}\{#MyAppExeName}"; Flags: deletekey uninsdeletekey;

```