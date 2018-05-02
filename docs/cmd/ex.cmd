@echo off
:ex_menu
cls
echo.
echo   PaperlessServer 管理界面
echo.
echo    [ 1 ] 启动 Socket 服务器           　[ 4 ] 开启 ServerDaemon 服务
echo.
echo    [ 2 ] 关闭 Socket 服务器             [ 5 ] 关闭 ServerDaemon 服务
echo.
echo    [ 3 ] 重启 Socket 服务器             [ 6 ] 重启 ServerDaemon 服务
echo.
echo    [ 7 ] 更新 数据库                    [ 8 ] 打开 网站
echo.

set "ROOT_PATH=%cd%"
set input=
set /p input=-^> 请选择:
cls
echo.
if /i "%input%"=="1" goto ex_1
if /i "%input%"=="2" goto ex_2
if /i "%input%"=="3" goto ex_3
if /i "%input%"=="4" goto ex_4
if /i "%input%"=="5" goto ex_5
if /i "%input%"=="6" goto ex_6
if /i "%input%"=="7" goto ex_7
if /i "%input%"=="8" goto ex_8
if /i "%input%"=="ps" goto ex_ps
if /i "%input%"=="" goto ex_menu
if /i "%input%"=="q" goto ex_main
echo.
echo    未选择操作或输入有误 请返回！
echo.
%pause%
goto ex_menu

:ex_1

tasklist|find /i "mysqld.exe"
if %errorlevel% == 0 (

echo 正在启动 socket 服务器...
for /f "tokens=2 " %%a in ('tasklist  /fi "IMAGENAME eq paperlessCms.exe" /nh') do TASKKILL /F /FI "PID eq %%a"
for /f "tokens=2 " %%a in ('tasklist  /fi "IMAGENAME eq php.exe" /nh') do TASKKILL /F /FI "PID eq %%a"
cd %ROOT_PATH%
start paperlessCms.exe
echo.
echo 启动 socket 服务器成功
echo.
pause

) else (

echo 数据库未启动...
echo.
pause
)

goto ex_menu

:ex_2
echo 正在关闭 socket 服务器...
for /f "tokens=2 " %%a in ('tasklist  /fi "IMAGENAME eq paperlessCms.exe" /nh') do TASKKILL /F /FI "PID eq %%a"
for /f "tokens=2 " %%a in ('tasklist  /fi "IMAGENAME eq php.exe" /nh') do TASKKILL /F /FI "PID eq %%a"
echo 关闭 socket 服务器成功
echo.
pause
goto ex_menu

:ex_3

tasklist|find /i "mysqld.exe"
if %errorlevel% == 0 (

echo.
echo 正在关闭 socket 服务器...
for /f "tokens=2 " %%a in ('tasklist  /fi "IMAGENAME eq paperlessCms.exe" /nh') do TASKKILL /F /FI "PID eq %%a"
for /f "tokens=2 " %%a in ('tasklist  /fi "IMAGENAME eq php.exe" /nh') do TASKKILL /F /FI "PID eq %%a"
echo 关闭 socket 服务器成功
cd %ROOT_PATH%
start paperlessCms.exe
echo.
echo 启动 socket 服务器成功
echo.
pause

) else (

echo 数据库未启动...
echo.
pause
)

goto ex_menu

:ex_4
echo.
net start ServerDaemon
echo.
pause
goto ex_menu

:ex_5
net stop ServerDaemon
echo.
pause
goto ex_menu

:ex_6
net stop ServerDaemon
echo ServerDaemon 服务成功停止
net start ServerDaemon
echo.
pause
goto ex_menu

:ex_7

tasklist|find /i "mysqld.exe"
if %errorlevel% == 0 (

echo 正在更新数据库...
start updateSql.exe
echo 更新数据库结束...
echo.
pause

) else (

echo 数据库未启动...
echo.
pause
)
goto ex_menu

:ex_8
explorer "http://127.0.0.1"
goto ex_menu

:ex_ps
set "CU_PATH=%~dp0";
start %CU_PATH%ps.cmd
goto ex_menu

:ex_main
prompt
popd
cls
