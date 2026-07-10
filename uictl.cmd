@echo off
:: -*- coding: latin-1, tab-width: 2 -*-
powershell.exe -NoLogo -ExecutionPolicy RemoteSigned -File "%~dp0lib\__cli__.ps1" %*
