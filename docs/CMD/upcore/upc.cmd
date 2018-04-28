rem -- http://www.upupw.net
rem -- webmaster@upupw.net
set apache_vc=UPUPW_Apache
set database_vc=UPUPW_Database_A
set updaemon_vc=UPUPW_updaemon_A
set redis_vc=UPUPW_Redis_A
set fzftp_vc=FileZilla Server
set apache_port=80
set ftp_port=21
set database_port=1177
set redis_port=1116
for /d %%d in (*) do (
 if exist %%d\upcore.exe set upcore_dir=%%d
 if exist %%d\bin\httpd.exe set apache_dir=%%d&& set apache_exe=httpd.exe
 if exist %%d\php.exe set php_dir=%%d
 if exist %%d\bin\mysqld.exe set database_dir=%%d&& set database_exe=mysqld.exe
 if exist %%d\redis-server.exe set redis_dir=%%d
 if exist %%d\guard.exe set guard_dir=%%d
 if exist %%d\FileZilla_server.exe set fz_dir=%%d&& set fz_exe=FileZilla_server.exe
)
if "%upcore_dir%"=="" echo # upcore Not Found. & pause & exit /b
if "%apache_dir%"=="" echo # Apache Not Found. & pause & exit /b
if "%php_dir%"=="" echo # PHP Not Found. & pause & exit /b
if "%database_dir%"=="" echo # Database Not Found. & pause & exit /b
if "%redis_dir%"=="" echo # Redis Not Found. & pause & exit /b
if "%guard_dir%"=="" echo # Guard Not Found. & pause & exit /b
set php=%upcore_dir%\upcore.exe -d extension_dir=%upcore_dir% -d date.timezone=UTC -n %upcore_dir%\up.dll
set pause=%php% echo `- 请按任意键继续...`; ^&^& pause^>nul 2>nul
set vhosts_conf=%apache_dir%\conf\httpd-vhosts.conf
set redis_conf=%redis_dir%\redis-service.conf
set upcore=%upcore_dir%
set upd_config=%upcore_dir%\upd_config.cmd
set cfg_bak_zip=Backup\cfg_bak.zip
set cfg_sckf_zip=Backup\cfg_sckf.zip
set cfg_xnsp_zip=Backup\cfg_xnsp.zip
set Sys32=%SystemRoot%\system32
set Path=%Sys32%;%Sys32%\wbem;%SystemRoot%
set net=%Sys32%\net.exe
if not exist %net% set net=%Sys32%\net1.exe
if not exist %net% echo  # 缺少 %Sys32%\net.exe, 不可继续. &%pause%&set php=&exit /b
%php% "chk_path(getcwd());" || %pause% && set php=
