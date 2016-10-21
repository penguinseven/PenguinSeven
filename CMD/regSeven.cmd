@echo off

set flag=%1%
if "%1%"=="" set flag=0
if %flag%==0 goto end

if "%flag%" == "cpu" (
goto cpu
)

if "%flag%" == "uuid" (
goto uuid
)

goto end

:cpu
:: cpu 序列号
for /f "delims=" %%a in ('wmic CPU get ProcessorID /value ^| find "ProcessorId"') do set %%a
    echo %ProcessorId%
    goto end


:uuid
:: 硬盘uuid
 for /f "delims=" %%a in ('wmic csproduct list full ^| find "UUID"') do set %%a
    echo %UUID%
    goto end

:end

exit