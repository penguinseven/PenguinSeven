```cmd
@echo off

:: 设置字体颜色
color 0A
:: 引入文件
call %CD%\upcore\upc.cmd

:: 设置JAVA_HOME系统变量
setx -m JAVA_HOME %CD%\jdk >nul 2>nul

echo.
echo   正在一键启动全部服务...
call :start_Apache
call :start_MySQL
call :start_redis
call :install_socket
call :start_socket
call :install_daemon
call :start_daemon
Call :install_red5
call :start_red5
echo.
echo   启动全部服务完成...
echo.
goto end

:: --------------------------------------------------------------------------------------------------------------------------------------- ::	
:: -------------------------------------------------------  安装 ------------------------------------------------------------------------- ::	
:: --------------------------------------------------------------------------------------------------------------------------------------- ::

:: 标签段  -------------------------
:install_daemon
	call %CD%\paperless\ServerDaemon\ServerDaemon.exe -i >nul 2>nul
	goto :eof


:: 标签段  -------------------------
:install_red5
	call %CD%\red5-server\install-service.bat >nul 2>nul
	goto :eof
	
:: 标签段  -------------------------
:install_socket
	sc create "Socket Server" binPath= "cmd.exe /c start %CD%\paperlessCms.exe" start= auto >nul 2>nul
	goto :eof
	
:: --------------------------------------------------------------------------------------------------------------------------------------- ::	
:: -------------------------------------------------------  开始 ------------------------------------------------------------------------- ::	
:: --------------------------------------------------------------------------------------------------------------------------------------- ::	
	

:: 标签段, 启动apache服务器
:start_Apache
	echo.
	echo   Apache服务正在启动...
	tasklist|findstr /i httpd.exe >nul 2>nul && call :stop_Apache
	:: 判断是否存在pid文件，为true（apache已启动） 跳转到start_A 标签段，为false打印错误
	if not exist %CD%\%apache_dir%\logs\*.pid goto start_A
	echo   Apache服务已经运行无需重复操作，可返回主界面kk后再次开启。
	echo.
	goto :eof

:: 标签段  ------------------------- 启动apache具体操作
:start_A
	:: 执行外部程序，调用upcfg(),为 false 跳转至菜单栏
	%php% upcfg(); || %pause% && goto menu
	:: 安装apache应用，将结果重定向到nul
	%CD%\%apache_dir%\bin\%apache_exe% -k install -n %apache_vc% >nul 2>nul
	:: 启动apache应用，
	%CD%\%apache_dir%\bin\%apache_exe% -k start -n %apache_vc% >nul 2>nul
	:: 判断pid文件是否存在
	if exist %CD%\%apache_dir%\logs\*.pid goto start_A_OK
	echo.
	echo   启动Apache失败！可能的原因如下：
	echo   1、%apache_port%端口被占用   2、httpd-vhosts.conf配置文件错误
	echo   3、VC运行库未装   4、程序路径含有中文或空格
	echo   具体错误请查看Apache2\logs\apache.log文件[error]条目
	echo.
	goto end

:: 标签段  -------------------------  数据库服务启动
:start_MySQL
	echo   数据库服务正在启动...
	tasklist|findstr /i httpd.exe >nul 2>nul && call :stop_MySQL
	%CD%\%database_dir%\bin\%database_exe% --install %database_vc% --defaults-file="%CD%\%database_dir%\my.ini" >nul 2>nul
	%net% start %database_vc% >nul 2>nul
	tasklist|findstr /i mysqld.exe >nul 2>nul && goto start_M_OK || goto start_M_ERROR


:: 标签段  -------------------------
:start_redis
	echo   Redis服务正在启动...
	tasklist|findstr /i redis-server.exe >nul 2>nul && call :stop_redis
	%CD%\%redis_dir%\redis-server.exe --service-install %CD%\%redis_conf% --service-name %redis_vc% >nul 2>nul
	%CD%\%redis_dir%\redis-server.exe --service-start --service-name %redis_vc% >nul 2>nul
	tasklist|findstr /i redis-server.exe >nul 2>nul && goto start_C_OK || goto start_C_ERROR


:: 标签段  -------------------------
:start_socket
	echo.
	tasklist|find /i "mysqld.exe" >nul
	if %errorlevel% == 0 (
		echo   Socket Server 服务器正在启动...
		:: 判断是否已启动
		tasklist|findstr /i php.exe >nul 2>nul && call :stop_socket
		:: start %CD%\paperlessCms.exe
		%net% start "Socket Server" >nul 2>nul
		:: 延时3秒
		ping -n 3 127.0.0.1 >nul
		tasklist|findstr /i php.exe >nul 2>nul &&  goto start_S_OK || goto start_S_ERROR
	) else (
		echo   数据库未启动...
	)
	goto :eof

:: 标签段  -------------------------
:start_daemon
	echo.
	:: 判断是否已启动
	echo   ServerDaemon服务器正在启动...
	tasklist|findstr /i ServerDaemon.exe >nul 2>nul && call :stop_daemon
	echo.
	%net% start "ServerDaemon"
	tasklist|findstr /i ServerDaemon.exe >nul 2>nul && goto start_P_OK || goto start_P_ERROR


:: 标签段  -------------------------
:start_red5
	echo.
	:: 判断是否已启动
	echo   Red5 Media Server服务器正在启动...
	tasklist|findstr /i prunsrv.exe >nul 2>nul && call :stop_red5
	%net%  start "Red5 Media Server"
	tasklist|findstr /i prunsrv.exe >nul 2>nul && goto start_R_OK || goto start_R_ERROR
	
	
:: ---------------------------------------------------------------------------------------------------------------------------------------- ::	
:: --------------------------------------------------------  停止 ------------------------------------------------------------------------- ::	
:: ---------------------------------------------------------------------------------------------------------------------------------------- ::	
	

:: 标签段  -------------------------	
:stop_red5
	echo.
	%net% stop "Red5 Media Server"
	goto :eof

:: 标签段  -------------------------
:stop_socket
	echo.
	echo   Socket Server 服务器正在停止...
	tasklist|find /i "php.exe" >nul 2>nul
	if %errorlevel% == 0 (

		for /f "tokens=2 " %%a in ('tasklist  /fi "IMAGENAME eq paperlessCms.exe" /nh') do TASKKILL /F /FI "PID eq %%a" >nul 2>nul
		for /f "tokens=2 " %%a in ('tasklist  /fi "IMAGENAME eq php.exe" /nh') do TASKKILL /F /FI "PID eq %%a" >nul 2>nul
	)
	echo   Socket Server 服务已经停止!
	goto :eof	

:: 标签段  -------------------------	
:stop_daemon
	echo.
	%net% stop "ServerDaemon" >nul 2>nul
	goto :eof	
	
:: 标签段  ------------------------- 停止apache
:stop_Apache
	echo.
	echo   Apache服务正在停止...
	:: 停止apache
	%CD%\%apache_dir%\bin\%apache_exe% -k stop -n %apache_vc% >nul 2>nul
	:: 卸载apache服务
	%CD%\%apache_dir%\bin\%apache_exe% -k uninstall -n %apache_vc% >nul 2>nul
	:: 删除pid文件
	del /f/s/q %CD%\%apache_dir%\logs\*.pid /q >nul 2>nul
	echo   Apache服务已经停止!
	goto :eof
	
:: 标签段  ------------------------- 停止 MySQL
:stop_MySQL
	echo.
	echo   数据库服务正在停止...
	%net% stop %database_vc% >nul 2>nul
	%CD%\%database_dir%\bin\%database_exe% --remove %database_vc% >nul 2>nul
	echo   数据库服务已经停止!
	goto :eof	
	
:: 标签段  ------------------------- 停止 Redis
:stop_redis
	echo.
	echo   Redis服务正在停止...
	%CD%\%redis_dir%\redis-server.exe --service-stop --service-name %redis_vc% >nul 2>nul
	%CD%\%redis_dir%\redis-server.exe --service-uninstall --service-name %redis_vc% >nul 2>nul
	echo   Redis服务已经停止!
	goto :eof	

:: --------------------------------------------------------------------------------------------------------------------------------------- ::	
:: -------------------------------------------------------  提示 ------------------------------------------------------------------------- ::	
:: --------------------------------------------------------------------------------------------------------------------------------------- ::

:: 标签段  -------------------------  apache启动成功提示
:start_A_OK
	echo.
	echo   Apache服务启动成功!
	echo.
	goto :eof

:: 标签段  -------------------------
:start_P_OK
	echo.
	echo   ServerDaemon 服务启动成功!
	goto :eof	

:start_S_OK
	echo.
	echo   启动 socket 服务器成功
	goto :eof

:start_S_ERROR
	echo.
	echo   Socket服务未能启动！
	echo   请检查端口(88,1238)占用或被防护软件禁止。
	goto :eof

:: 标签段  -------------------------
:start_P_ERROR
	echo.
	echo   ServerDaemon服务未能启动！
	echo   请检查端口占用或被防护软件禁止。
	goto :eof

:: 标签段  -------------------------
:start_R_OK
	echo.
	echo   Red5 Media Server 服务启动成功!
	goto :eof

:: 标签段  -------------------------
:start_R_ERROR
	echo   Red5 Media Server 服务未能启动！
	echo   请检查端口(5080)占用或被防护软件禁止。
	goto :eof	

:: 标签段  -------------------------
:start_M_OK
	echo.
	echo   数据库服务启动成功!
	echo.
	goto :eof
	

:: 标签段  -------------------------
:start_C_ERROR
	echo.
	echo   Redis服务未能启动！
	echo   请检查%redis_port%端口占用或被防护软件禁止。
	goto :eof

:: 标签段  -------------------------
:start_C_OK
	echo.
	echo   Redis服务启动成功!
	goto :eof

:: 标签段  -------------------------
:start_M_ERROR
	echo.
	echo   启动数据库失败！可能的原因如下：
	echo   1、%database_port%端口被占用   2、剩余内存不足200MB
	echo   3、my.ini配置出错   4、数据表缺失或出错
	echo   具体错误请查看数据库data目录%COMPUTERNAME%.err文件[error]条目
	echo.
	goto end	
	
:end
pause
exit

```

