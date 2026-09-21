@echo off
rem One double-click: install the files the dashboard session sent (from Downloads), then scan and deploy.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install-DashboardUpdate.ps1"
echo.
pause
