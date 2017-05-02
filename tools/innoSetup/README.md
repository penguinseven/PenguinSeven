### inno setup 常见问题

#### 1. 系统管理员运行

> `Inno Setup`打包的程序安装完成后运行失败，
    这个是因为权限不够，我们可以通过下面的办法解决：
  找到`Inno Setup`安装目录下的`SetupLdr.e32`文件，
  然后用`Resource Hacker`软件打开，将`Manifest`改成

```
<requestedExecutionLevel level="requireAdministrator"  uiAccess="false"/>
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
### 4.判断进程是否正在运行
 ```
[Code]

function IsModuleLoaded(modulename: AnsiString ):  Boolean;
external 'IsModuleLoaded@files:psvince.dll stdcall';

var
Page: TWizardPage;
RadioButton1, RadioButton2: TRadioButton;
Lbl1, Lbl2: TNewStaticText;
TaskCode: Boolean;

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
```
### 5. 判断安装 “.net 4.0”

```
#define IncludeFramework true  

  
[Files]
#if IncludeFramework
Source: "E:\无纸化会议客户端\ext\dotNetFx40_Full_x86_x64.exe"; DestDir: "{tmp}"; Flags: ignoreversion {#IsExternal}; Check: NeedsFramework
#endif  
  
[Run]
#if IncludeFramework
Filename: {tmp}\dotNetFx40_Full_x86_x64.exe; Parameters: "/q:a /c:""install /l /q"""; WorkingDir: {tmp}; Flags: skipifdoesntexist; StatusMsg: "Installing .NET Framework if needed"
#endif

  
[code]

// Indicates whether .NET Framework 2.0 is installed.
function IsDotNET40Detected(): boolean;
var
    success: boolean;
    install: cardinal;
begin
    success := RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'Install', install);
     //success := RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v2.0.50727', 'Install', install);
    Result :=  success and (install = 1);
end;

//RETURNS OPPOSITE OF IsDotNet20Detected FUNCTION
//Remember this method from the Files section above
function NeedsFramework(): Boolean;
begin
  Result := (IsDotNET40Detected = false);
end;

function GetCustomSetupExitCode(): Integer;
begin
  if (IsDotNET40Detected = false) then
    begin
      MsgBox('.NET Framework 未能正确安装!',mbError, MB_OK);
      result := -1
    end
end;
```

