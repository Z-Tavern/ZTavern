@echo off
call getCmdPID
set "current_pid=%errorlevel%"

:loop
for /f "skip=3 tokens=2 delims= " %%a in ('tasklist /fi "imagename eq cmd.exe"') do (
    if "%%a" neq "%current_pid%" (
        TASKKILL /PID %%a /f >nul 2>nul
    )
)
taskkill /f /im node.exe
taskkill /f /im plutonium-bootstrapper-win32.exe

start !start_zm_serverdierise.bat
start !start_zm_servernuketown.bat
start !start_zm_serverburied.bat
start !start_zm_serverprivate.bat
start !start_zm_servermotd.bat
timeout  5 >nul
start !start_zm_servertitb.bat
start !start_zm_serverpanzer.bat
start !start_zm_serverbrutus.bat
start !start_zm_serverorigin.bat
start !start_zm_serverorigin2.bat
timeout  5 >nul
start !start_zm_serverraid.bat
start !start_zm_servertown.bat
start !start_zm_servertown2.bat
start !start_zm_servertown3.bat
start !start_zm_servertranzit.bat
timeout  50 >nul

:: Replace path depending on where you put NSM folder
:: StartNSM.bat must be started while being on the same directory, hence why I use "cd" to move around
cd C:\bo2\node-server-manager
start "" cmd /c C:\bo2\node-server-manager\StartNSM.bat
cd C:\bo2


timeout 21540 >nul
goto loop