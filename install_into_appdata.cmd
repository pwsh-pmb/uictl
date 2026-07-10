@echo off
:: -*- coding: latin-1, tab-width: 2 -*-
cd /d "%~dp0"
cd ..
set real_cmdfile="%~dp0uictl.cmd"
set apps_cmdfile=%LocalAppData%\Microsoft\WindowsApps\uictl.cmd
echo @echo off> %apps_cmdfile%
echo %real_cmdfile% %%*>> %apps_cmdfile%
