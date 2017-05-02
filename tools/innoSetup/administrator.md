## INNO SETUP 学习心得

> ###1.脚本结构

---

1. [Setup] 段 
　　
　　这个段包括了安装和卸载程序所使用的全局设置，并且有些关键字在你建立的安装程序中是必须要用到的。
　　
2. [Dirs] 段
　　
　　这个段是可选的，而且通常对于大多数简单的应用程序来书不是必需的。这个段是用来创建除用户选择的应用程序目录以外的其它的附加的目录，它是被自动创建的。这个段所创建的子目录是可以脱离主应用程序而共同使用的目录。当然在 [Files] 段里面的文件被复制到某个目录之前你并不一定要创建它，然而在卸载程序的时候在 [Dirs] 和 [UninstallDelete] 段里面没有指定的目录就不会被删除。
　　
3. [Files] 段 
　　
　　这个段是可选的，但对于大多数安装程序来说是必不可少的。在这里定义了安装程序需要复制到用户的系统当中的全部文件。 
　　
　　在安装期间，卸载程序和数据被自动的复制到应用程序的目录当中去，因此你不必手工的将它们添加到 [Files] 段。
　　
4. [Icons] 段
　　
　　这个段是可选的，但对于大多数安装程序来说是必不可少的。它定义了所有的安装程序要在用户系统中创建的程序管理器/开始菜单的图标。它也能被用来在其它的位置创建应用程序图标（快捷方式），比如就像桌面。 
　　
　　卸载图标是由安装程序内部创建的，这样一来你就不需要在 [Icons] 段里面手工的添加它。默认情况下，安装程序运行在 Windows 95/NT 4+ 的时候是不创建卸载图标的 ――除了安装程序运行于 Windows NT 3.51 的时候。 要强制创建一个卸载图标，请使用 [Setup] 段里面的 AlwaysCreateUninstallIcon 关键字。
　　
5. [INI] 段 
　　
　　此段是可选的，它定义了一些 .INI 文件项，在文件被复制以后安装程序在用户的系统中的设定。 
　　
6. [InstallDelete] 段
　　
　　它使用的是和 [UninstallDelete] 段相同的格式，不同的是它是在安装程序的第一步被处理的。 
　　
7. [Messages] 段 
　　
　　[Messages] 段是用于定义安装程序和卸载程序所显示的消息。通常你不需要在你的脚本文件里面创建 [Messages] 段，默认情况下所有的显示消息都由 Inno Setup 包含的文件 Default.isl 定义。 （或由 [Setup] 段的关键字 MessagesFile 指定的任何文件）。
　　
8. [Registry] 段
　　
　　这个段是可选的，他定义了一些注册表项，用于在复制完文件之后创建在用户的系统中。 
　　
9. [Run] %26amp; [UninstallRun] 段 
　　
　　[Run] 段是可选的，指定任意数量的程序在成功安装程序以后及显示结束对话框之前被执行。同样 [UninstallRun] 段也是可选的，指定任意数量的程序在%26ldquo;卸载程序%26rdquo;的第一步时被执行。除非下面有其它说明，两个段共有相同的语法。 
　　每个程序按照你的脚本编排的顺序被执行，当出路 [Run]/[UninstallRun] 的项时，安装程序将会等到当前的程序终止之后才处理下一个，当然除非使用了 nowait 标记。
　　
10. [UninstallDelete] 段 
　　
　　该段是可选的。该段是用来定义一些附加的除了那些被安装的应用程序之外的要被卸载程序删除的文件或目录。使用该段来删除由你的应用程序创建的 .INI 文件是一个常用的办法。卸载程序在卸载过程的最后一步处理这些项。

　
> ###2.目录常量

---
　　
    {app}
　　应用程序目录，这是用户在安装向导的选择安装目录页里面所选择的。
　　例如：如果你使用了 {app}\MYPROG.EXE 作为一项并且用户选择了“C:\MYPROG”作为应用程序的目录，那么安装程序就会将它转换成“C:\MYPROG\MYPROG.EXE”。

　　{win}
　　系统的 Windows 目录。例如：如果你使用了 {win}\MYPROG.INI 作为一项并且系统的 Windows 目录是“C:\WINDOWS”，那么安装程序就会将它转换成“C:\WINDOWS\MYPROG.INI”。

　　{sys}
　　系统的 Windows 系统(System)目录(在 Windows NT/2000 下是 System32)。例如：如果你使用了 {sys}\ CTL3D32.DLL 作为一项并且系统的 Windows 系统目录是“C:\WINDOWS\SYSTEM”，那么安装程序就会将它转换成“C:\ WINDOWS\SYSTEM\CTL3D32.DLL”。

　　{src}
　　这个文件夹指向安装程序所在的位置。
　　例如：如果你使用了 {src}\MYPROG.EXE 作为一项并且用户是从“S:\ ”安装的，那么安装程序就会将它转换成“S:\MYPROG.EXE”。

　　{sd}
　　系统驱动器，它是指 Windows 被安装到的那个驱动器，典型的是“C:”，对于 Windows NT/2000，这个常量同系统的环境变量“SystemDrive”是等效的。

　　{pf}
　　程序文件夹(Program Files)，这个路径是系统的 Program Files 目录，典型的是“C:\Program Files”。

　　{cf}
　　公共文件夹(Common Files)，这个路径是系统的 Common Files 文件夹，典型的是“C:\Program Files\Common Files”。

　　{tmp}
　　临时目录，这个目录并不是用户的 TEMP 环境变量指向的目录，而是安装程序在启动时在用户的临时目录下建立的一个子目录，在安装程序退出时所有的文件和子目录将会被删除。对于在 [Run] 段里面要被执行且在安装以后又不需要的程序文件来说这个功能是非常有用的。

　　{fonts}
　　字体目录，在 Windows 95/NT 4+ 下有一个专门为字体设立的目录(通常这个目录在 Windows 目录下且被命名为“FONTS”)，这个常量就指向这个目录。对于 Windows NT 3.51，这个常量是和 {sys} 等效的，因为当时还没有字体目录。

{dao}
DAO 目录，当安装程序运行在 Windows 95/NT 4+ 上时，它被等效为 {cf}\Microsoft Shared\DAO，当运行于 Windows NT 3.51 时，它被等效为 {win}\MSAPPS\DAO。

> ###3.常见问题

---

多语言安装包
----------
```pascal
[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl" ; LicenSeFile :"E:\upupw\doc\readme_en.txt"
Name: "chs"; MessagesFile: "compiler:Languages\china.isl"; LicenSeFile :"E:\upupw\doc\readme_chs.txt"

[Messages]
en.BeveledLabel=English
chs.BeveledLabel=Chineses


[CustomMessages]
en.MyAppName          = Intelligent paperless conference management server
en.Uninstall          = Uninstall


chs.MyAppName         = 智能无纸化会议管理服务器
chs.Uninstall         = 卸载

; 调用

[code]

ExpandConstant('{cm:MyAppName}')

```
    

修改ini文件
----------
```pascal
;用于在用户系统中创建，修改或删除ini文件健值
[INI]
Filename: "{app}\cfg.ini"; Section: "Startup Options"; Flags: uninsdeletesection
Filename: "{app}\cfg.ini"; Section: "Startup Options"; Key: "server ip"; String: "127.0.0.1"
Filename: "{app}\cfg.ini"; Section: "Startup Options"; Key: "server port"; String: "8080"

```

安装、卸载判断进程(窗口名称)
------------------------
```pascal
[Code]
// 判断进程

var
ErrorCode: Integer;
IsRunning: Integer;
// 安装时判断客户端是否正在运行  
function InitializeSetup(): Boolean;  
begin  
Result :=true; //安装程序继续  
IsRunning:=FindWindowByWindowName('东方宽频网络电视');  
while IsRunning<>0 do 
begin  
    if Msgbox('安装程序检测到客户端正在运行。' #13#13 '您必须先关闭它然后单击“是”继续安装，或按“否”退出！', mbConfirmation, MB_YESNO) = idNO then  
    begin  
      Result :=false; //安装程序退出  
      IsRunning :=0;  
    end else begin  
      Result :=true; //安装程序继续  
      IsRunning:=FindWindowByWindowName('东方宽频网络电视');  
    end;  
end;  
end;

  
// 卸载时判断客户端是否正在运行  
function InitializeUninstall(): Boolean;  
begin  
   Result :=true; //安装程序继续  
IsRunning:=FindWindowByWindowName('东方宽频网络电视');  
while IsRunning<>0 do 
begin  
 
    if Msgbox('安装程序检测到客户端正在运行。' #13#13 '您必须先关闭它然后单击“是”继续安装，或按“否”退出！', mbConfirmation, MB_YESNO) = idNO then  
    begin  
      Result :=false; //安装程序退出  
      IsRunning :=0;  
    end else begin  
      Result :=true; //安装程序继续  
      IsRunning:=FindWindowByWindowName('东方宽频网络电视');    
    end;  
end;  
end;
```

安装、卸载判断进程(进程名称)
----------------------------
```pascal
//引入库文件，不操作文件
[Files]
Source: "E:\upupw\psvince.dll"; Flags: dontcopy

//code 段引用文件
[code]
function IsModuleLoaded(modulename: AnsiString ):  Boolean;
external 'IsModuleLoaded@files:psvince.dll stdcall';

// PSVince控件在64位系统（Windows 7/Server 2008/Server 2012）下无法检测到进程，使用下面的函数可以解决。
function IsAppRunning(const FileName : string): Boolean;
var
    FSWbemLocator: Variant;
    FWMIService   : Variant;
    FWbemObjectSet: Variant;
begin
    Result := false;
    try
      FSWbemLocator := CreateOleObject('WBEMScripting.SWBEMLocator');
      FWMIService := FSWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
      FWbemObjectSet := FWMIService.ExecQuery(Format('SELECT Name FROM Win32_Process Where Name="%s"',[FileName]));
      Result := (FWbemObjectSet.Count > 0);
      FWbemObjectSet := Unassigned;
      FWMIService := Unassigned;
      FSWbemLocator := Unassigned;
    except
      if (IsModuleLoaded(FileName)) then
        begin
          Result := false;
        end
      else
        begin
          Result := true;
        end
      end;
end;

// example 判断进程是否正在运行

function InitializeSetup(): Boolean;
begin
  Result := true;
  if  IsAppRunning('httpd.exe') then
  begin
    if MsgBox('安装程序检测到 {#MyAppName} 正在运行！'#13''#13'单击“是”按钮关闭程序并继续安装；'#13''#13'单击“否”按钮退出安装！', mbConfirmation, MB_YESNO) = IDYES then
    begin
      Result:= true;
    end
    else
      Result:= false;
  end;
end
```

界面显示控制
---------------
```pascal
// 界面显示控制，true 为隐藏
//预定义向导页 CurPageID 值
//wpWelcome, wpLicense, wpPassword, wpInfoBefore, wpUserInfo, wpSelectDir, wpSelectComponents, wpSelectProgramGroup, wpSelectTasks, wpReady, wpPreparing, wpInstalling, wpInfoAfter, wpFinished

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  if (PageID = wpSelectDir) and (RadioButton1.Checked) then
    Result := True
  else if (PageID = wpSelectProgramGroup)  and (RadioButton1.Checked) then
    Result := True
end;
```

环境变量
------------
```pascal
//添加环境变量
procedure CurStepChanged(CurStep: TSetupStep);
begin
if CurStep = ssPostInstall then
begin
   SetEnv('path',ExpandConstant('{app}/Package/bpl;{app}/bin'),true,true); //在这儿调用,一定在这儿调用,安装完无须重启,立即生效
   //SetEnv('path','{app}/bin',true,true);
end;
end;

//删除环境变量
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
SetEnv('path',ExpandConstant('{app}/Package/bpl;{app}/bin'),false,true);
//SetEnv('path','{app}/bin',false,true);
end;

```

自定义单选界面（含单击事件）
-----------------------
```
// 自定义界面
 var
  Page: TWizardPage; 
  RadioButton1, RadioButton2: TRadioButton;
  Lbl1, Lbl2: TNewStaticText;
  TaskCode: Boolean;  


{radio1的事件响应过程}
procedure ClickRadio1(Sender: TObject);
begin
       TaskCode := true;
end;

{radio2的事件响应过程}
procedure ClickRadio2(Sender: TObject);
begin
       TaskCode := false;
end;
 
procedure CreateAddonPage;
begin
  Page := CreateCustomPage(wpInfoBefore, '选择安装类型', '请根据您的需要选择安装的类型'); 
      
  RadioButton1 := TRadioButton.Create(Page);
  RadioButton1.Left := ScaleX(45);
  RadioButton1.Top := ScaleY(40);
  RadioButton1.Width := Page.SurfaceWidth;
  RadioButton1.Height := ScaleY(17);
  RadioButton1.Caption := '标准安装';
  RadioButton1.Checked := True;
  RadioButton1.Parent := Page.Surface;
  RadioButton1.OnClick:=@ClickRadio1;
 
  Lbl1 := TNewStaticText.Create(Page);
  Lbl1.Left := ScaleX(55);
  Lbl1.Top := ScaleY(60);
  Lbl1.Width := ScaleX(250);
  Lbl1.Height := ScaleY(50);
  Lbl1.Caption := '按照标准模式安装软件到您的电脑，数据库将更新覆盖。';
  Lbl1.Parent := Page.Surface;
 
  RadioButton2 := TRadioButton.Create(Page);
  RadioButton2.Left := ScaleX(45);
  RadioButton2.Top := RadioButton1.Top + ScaleY(60);
  RadioButton2.Width := Page.SurfaceWidth;
  RadioButton2.Height := ScaleY(17);
  RadioButton2.Caption := '更新';
  RadioButton2.Checked := false;
  RadioButton2.Parent := Page.Surface;
  RadioButton2.OnClick:=@ClickRadio2;
 
  Lbl2 := TNewStaticText.Create(Page);
  Lbl2.Left := ScaleX(55);
  Lbl2.Top := Lbl1.Top + ScaleY(60);
  Lbl2.Width := ScaleX(250);
  Lbl2.Height := ScaleY(50);
  Lbl2.Caption := '数据库不覆盖。';
  Lbl2.Parent := Page.Surface;
end;

// 事件函数 初始化 
procedure InitializeWizard();
begin
  CreateAddonPage;
end;

```

插件函数 (替换卸载图标)
----------
```pascal
//插件函数用法  
//参数: 句柄(插件错误对话框的父句柄), exe文件完整路径名称, (exe文件中要替换的)图标资源名称, 图标文件的完整路径名称, (exe中要替换的图标资源所在)语系  
//返回值: 成功 = True, 失败 = False  
//安装初始化  
function UpdateIcon(const hWnd: Integer; const exeFileName, exeIcon, IcoFileName: String; wlangID: DWORD): Boolean;  
external 'UpdateIcon@files:UpdateIcon.dll stdcall';  
//替换卸载程序的图标  
function UpdateUninstIcon(const IcoFileName: String): Boolean;  
begin   
  //要替换图标的exe文件路径名称留空，则插件会自动替换掉Inno卸载程序的图标！其它参数类似！  
  Result:= UpdateIcon(MainForm.Handle, '', '', IcoFileName, 0); //替换卸载图标  
end;  
procedure CurStepChanged(CurStep: TSetupStep);  
var uninspath, uninsname, NewUninsName, MyAppName,sIcon: String;  
  
begin  
  //注意: 替换卸载程序的图标，必须是在卸载程序生成之前！  
  //建议安装图标与卸载图标的格式与大小一致，否则可能会导致卸载程序出错！  
  if CurStep=ssInstall then  
    begin  
    sIcon:= ExpandConstant('{tmp}\uninstall.ico'); //定义卸载图标  
    //ExtractTemporaryFile('UpdateIcon.dll');//该动态链接库可网上查找  
    ExtractTemporaryFile(ExtractFileName(sIcon)); //释放卸载图标  
    //要替换图标的exe文件路径名称留空，则插件会自动替换掉Inno卸载程序的图标！  
    UpdateUninstIcon(sIcon) //替换卸载图标  
    end;  
  if CurStep=ssDone then  
    begin  
    // 指定新的卸载文件名（不包含扩展名），请相应修改！    
    NewUninsName := 'YoyaUninstall';    
    // 应用程序名称，与 [SEUTP] 段的 AppName 必须一致，请相应修改！    
    MyAppName := '优芽互动电影播放器';    
    // 以下重命名卸载文件    
    uninspath:= ExtractFilePath(ExpandConstant('{uninstallexe}'));    
    uninsname:= Copy(ExtractFileName(ExpandConstant('{uninstallexe}')),1,8);    
    RenameFile(uninspath + uninsname + '.exe', uninspath + NewUninsName + '.exe');    
    RenameFile(uninspath + uninsname + '.dat', uninspath + NewUninsName + '.dat');   
    end;   
    // 以下修改相应的注册表内容  
    if RegKeyExists(HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{#APPID}_is1') then  
    begin  
    RegWriteStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{#APPID}_is1', 'UninstallString', '"' + uninspath + NewUninsName + '.exe"');  
    RegWriteStringValue(HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{#APPID}_is1', 'QuietUninstallString', '"' + uninspath + NewUninsName + '.exe" /SILENT');  
    end;     
end;

```

判断程序是否安装(1)
---------------
```pascal
//  判断程序是否存在，卸载程序，多安装程序窗口判断
var
is_Sys , is_value: integer;
S_syschar, S_currentchar, S_current,S_sys, S,ResultStr : string;
I ,CloseNum: Integer;
ErrorCode: Integer;
Guid_names,window_name : TArrayOfString;
bool  : Boolean;
const AppName='{D0D0B722-C6F9-4A89-AB56-1417B9BD1400}_is1';
{程序安装前判断主程序是否在运行}
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
begin
  if RegGetSubkeyNames(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',Guid_names) then
  begin
    for I:=0 to GetArrayLength(Guid_names)-1 do
    begin
      S := Guid_names[i];
      //注册表中找到了此键
      if AppName = Guid_names[i] then
      begin
        bool := RegQueryStringValue(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\'+S,'UninstallString',ResultStr);
        //ResultStr := RemoveQuotes(ResultStr);
        if bool then
        begin
           if MsgBox('安装程序检测到当前计算机已经安装了AIS_Server。' #13#13 '您是否要卸载AIS_Server？',  mbConfirmation, MB_YESNO) = IDYES then
            //   ShellExec('', ExpandConstant('{app}\unins000.exe'), '','', SW_SHOW, ewNoWait, ResultCode);
            begin
              Exec(RemoveQuotes(ResultStr), '', '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
              Result := false;
            end
        end
        break;
      end
      else
      //zdx 5.8 判断是否已经打开了一个安装程序
      begin
        if FindWindowbyWindowName('安装 - AIS_Server')<>0 then
        begin
          MsgBox('安装程序检测到有另外一个安装程序已经在运行了', mbConfirmation, MB_OK);
          Result := false;
          break;
        end
      end
    end;
    if I = GetArrayLength(Guid_names) then
      Result := true;
  end
  else
    Result := true;
end; 

```

判断程序是否已安装（2）
--------------------
```pascal
 // 修改注册表
[Registry]
Root: HKLM; Subkey: Software\The Application; ValueType: string; ValueName: Installed version; ValueData: '2.0'; Flags: uninsdeletekey

[Code]
function GetInstalledVersion(): String;
var
InstalledVersion: String;
begin
InstalledVersion :='';
RegQueryStringValue(HKLM, 'Software\The Application', 'Installed version', InstalledVersion);
Result := InstalledVersion;
end;

function InitializeSetup(): Boolean;
var
PrevVer: String;
begin
PrevVer := GetInstalledVersion();
result := true;
if length(PrevVer) > 0 then begin
//如果发现程序已经安装过了
MsgBox ('本程序的 ' + PrevVer + ' 版本已经安装，请卸载后再安装本程序. 安装程序将关闭.', mbError, MB_OK);
result := false;
end;
end;
```

下载、复制、删除文件
--------------------
```pascal
itd_addfile('http://test.com/Test.exe',ExpandConstant('{src}\Test.exe'));

// Copy the file when it's finished the download
FileCopy(ExpandConstant('{tmp}\Test.exe'), ExpandConstant('{app}\Test.exe'), False);

// Delete the old file
DeleteFile(ExpandConstant('{src}\Test.exe'));
```


自定义函数控制文件安装
------------
```pascal
// 验证文件是否执行
 [Files]
Source: "MYPROG.EXE"; DestDir: "{app}"; Check: MyProgCheck
Source: "A\MYFILE.TXT"; DestDir: "{app}"; Check: MyDirCheck(ExpandConstant('{app}\A'))
Source: "B\MYFILE.TXT"; DestDir: "{app}"; Check: DirExists(ExpandConstant('{app}\B'))

[Code]
var
  MyProgChecked: Boolean;
  MyProgCheckResult: Boolean;

// 根据用户自定义返回
function MyProgCheck(): Boolean;
begin
  if not MyProgChecked then begin
    MyProgCheckResult := MsgBox('Do you want to install MyProg.exe to ' + ExtractFilePath(CurrentFileName) + '?', mbConfirmation, MB_YESNO) = idYes;
    MyProgChecked := True;
  end;
  Result := MyProgCheckResult;
end;


// 判断文件夹是否存在
function MyDirCheck(DirName: String): Boolean;
begin
  Result := DirExists(DirName);
end;
```

其他自定义函数
--------------
```pascal

// 执行程序
function TaskUninstallShell(): Boolean;
  var
  ResultCode: Integer;
begin
    Exec(ExpandConstant('{app}\uninstall.exe'), '', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
end;

  // 关闭进程
function TaskKillProcessByName(const FileName : string): Boolean;
  var
  ResultCode: Integer;
begin
    Exec(ExpandConstant('taskkill.exe'), '/f /im ' + '"' + FileName + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
end;

  // 卸载serverDaemon服务
function TaskShutDownDaemon(): Boolean;
  var
  ResultCode: Integer;
begin
     Exec(ExpandConstant('{app}\paperless\ServerDaemon\ServerDaemon.exe'), ' -d ', '', SW_SHOW,
     ewWaitUntilTerminated, ResultCode)
end;

 // 停止服务
function TaskStopService(const FileName : string): Boolean;
  var
  ResultCode: Integer;
begin
    Exec(ExpandConstant('net.exe'), ' stop ' + '"' + FileName + '"', '', SW_HIDE,
     ewWaitUntilTerminated, ResultCode);
end;

```
完全删除
------
```pascal

[UninstallRun]
Filename: "{cmd}"; Parameters: "/c rd /s /q ""{app}"""; Flags: hidewizard runhidden


[UninstallDelete]
Name: {app}; Type: filesandordirs

```


设置环境变量
-----
零、使用cmd添加 (必须重启才能生效)
```cmd
set "str=HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
for /f "skip=2 tokens=2*" %%a in ('REG QUERY "%str%" /v Path') do set "regstr=%%b"
set src=%ROOT_PATH%ffmpeg\bin\
if "%src%"=="" goto :eof
echo %regstr%|find ";%src%">nul&&echo 已经存在%src%||(
  setlocal enabledelayedexpansion
  set "regstr=!regstr!;%src%"
  reg add "!str!" /v Path /t REG_EXPAND_SZ /f /d "!regstr!
  endlocal
)
```


一、在[setup]段添加

```pascal
ChangesEnvironment=true
```

 

说明：让安装包在结束后，通知系统环境变量已经改变。

 

 

二、在[code]段添加
    
> 对于Windows NT系统，环境变量的设置，当前用户变量对应到注册表项HKEY_CURRENT_USER\Environment，系统环境变量对应到注册表项HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment，所以对于环境变量可以在安装或卸载时通过注册表的修改进行设置。

 ```pascal

// 设置环境变量函数
procedure SetEnv(aEnvName, aEnvValue: string; aIsInstall, aIsInsForAllUser: Boolean);
var
sOrgValue: string;
S1, sFileName: string;
bRetValue, bInsForAllUser: Boolean;
SL: TStringList;
x: integer;
begin
bInsForAllUser := aIsInsForAllUser;
if UsingWinNT then
begin
    if bInsForAllUser then
      bRetValue := RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', aEnvName, sOrgValue)
    else
      bRetValue := RegQueryStringValue(HKEY_CURRENT_USER, 'Environment', aEnvName, sOrgValue)
    sOrgValue := Trim(sOrgValue);
    begin
      S1 := aEnvValue;
      if pos(Uppercase(s1), Uppercase(sOrgValue)) = 0 then //还没有加入
      begin
        if aIsInstall then
        begin
          x := Length(sOrgValue);
          if (x > 0) and (StringOfChar(sOrgValue[x], 1) <> ';') then
            sOrgValue := sOrgValue + ';';
          sOrgValue := sOrgValue + S1;
        end;
      end else
      begin
        if not aIsInstall then
        begin
          StringChangeEx(sOrgValue, S1 + ';', '', True);
          StringChangeEx(sOrgValue, S1, '', True);
        end;
      end;

      if bInsForAllUser then
        RegWriteStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', aEnvName, sOrgValue)
      else
      begin
        if (not aIsInstall) and (Trim(sOrgValue) = '') then
          RegDeleteValue(HKEY_CURRENT_USER, 'Environment', aEnvName)
        else
          RegWriteStringValue(HKEY_CURRENT_USER, 'Environment', aEnvName, sOrgValue);
      end;
    end;
end else //非NT 系统,如Win98
begin
    SL := TStringList.Create;
    try
      sFileName := ExpandConstant('{sd}\autoexec.bat');
      LoadStringFromFile(sFileName, S1);
      SL.Text := s1;
      s1 :=   '"' + aEnvValue + '"';
      s1 := 'set '+aEnvName +'=%path%;' + s1 ;

      bRetValue := False;
      x := SL.IndexOf(s1);
      if x = -1 then
      begin
        if aIsInstall then
        begin
          SL.Add(s1);
          bRetValue := True;
        end;
      end else //还没添加
        if not aIsInstall then
        begin
          SL.Delete(x);
          bRetValue := True;
        end;

      if bRetValue then
        SL.SaveToFile(sFileName);
    finally
      SL.free;
    end;

end;
end;

// 安装前添加环境变量
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
  begin
  // 将{app}路径添加到path环境变量中
     SetEnv('path',ExpandConstant('{app}'),true,true); //在这儿调用,一定在这儿调用,安装完无须重启,立即生效
  end;
end;

// 卸载前删除环境变量
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  // 将{app}路径从path环境变量中删除
  SetEnv('path',ExpandConstant('{app}'),false,true);
end;
```

 自定义界面保存xml文件
----
> 1. 读取xml 文件

```pascal

var
  CustomEdit: TEdit;
  CustomPageID: Integer;

function LoadValueFromXML(const AFileName, APath: string): string;
var
  XMLNode: Variant;
  XMLDocument: Variant;  
begin
  Result := '';
  XMLDocument := CreateOleObject('Msxml2.DOMDocument.6.0');
  try
    XMLDocument.async := False;
    XMLDocument.load(AFileName);
    if (XMLDocument.parseError.errorCode <> 0) then
      MsgBox('The XML file could not be parsed. ' + 
        XMLDocument.parseError.reason, mbError, MB_OK)
    else
    begin
      XMLDocument.setProperty('SelectionLanguage', 'XPath');
      XMLNode := XMLDocument.selectSingleNode(APath);
      Result := XMLNode.text;
    end;
  except
    MsgBox('An error occured!' + #13#10 + GetExceptionMessage, mbError, MB_OK);
  end;
end;

```

> 2.修改xml文件

```pascal

procedure SaveValueToXML(const AFileName, APath, AValue: string);
var
  XMLNode: Variant;
  XMLDocument: Variant;  
begin
  XMLDocument := CreateOleObject('Msxml2.DOMDocument.6.0');
  try
    XMLDocument.async := False;
    XMLDocument.load(AFileName);
    if (XMLDocument.parseError.errorCode <> 0) then
      MsgBox('The XML file could not be parsed. ' + 
        XMLDocument.parseError.reason, mbError, MB_OK)
    else
    begin
      XMLDocument.setProperty('SelectionLanguage', 'XPath');
      XMLNode := XMLDocument.selectSingleNode(APath);
      XMLNode.text := AValue;
      XMLDocument.save(AFileName);
    end;
  except
    MsgBox('An error occured!' + #13#10 + GetExceptionMessage, mbError, MB_OK);
  end;
end;

```

> 3.自定义修改xml界面

```pascal
procedure CreatOnEditIpPage;
var  
  CustomPage: TWizardPage;
begin
  CustomPage := CreateCustomPage(wpWelcome, 'Custom Page', 
    'Enter the new value that will be saved into the XML file');
  CustomPageID := CustomPage.ID;
  CustomEdit := TEdit.Create(WizardForm);
  CustomEdit.Parent := CustomPage.Surface;
end;

```
> 4. 使用

```pascal

// 系统过程，判断pageID，读取xml文件
procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = CustomPageID then
    CustomEdit.Text := LoadValueFromXML( 'C:\Program Files\Inno Setup 5\test\config.xml', '//ServerConf/CMSIP');
end;

// 系统函数，根据pageID，判断点击下一步图标，保存xml文件
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = CustomPageID then
    SaveValueToXML( 'C:\Program Files\Inno Setup 5\test\config.xml', '//ServerConf/CMSIP', CustomEdit.Text);
end;

```


ini文件修改字段 (获取安装包语言)
---
```pascal

[Code]

function MyLangName(Param:String): String;      
begin               
  Result := ActiveLanguage();
end;

[INI]  

// 使用pascal 获取语言类型修改ini文件
Filename: "lan.ini"; Section: "settings"; Key: "language"; String: "{code:MyLangName}";
 
```

