@echo off
rem Adds Daily Breakdown to the Start menu and makes it open when you sign in.
rem Run again with  install-windows.bat remove  to undo.
setlocal
set "LAUNCHER=%~dp0Open Daily Breakdown.bat"
set "WORKDIR=%~dp0"

if /i "%~1"=="remove" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "foreach($d in @([Environment]::GetFolderPath('Startup'),[Environment]::GetFolderPath('Programs'))){ Remove-Item -ErrorAction SilentlyContinue (Join-Path $d 'Daily Breakdown.lnk') }"
  echo Removed the Start menu and sign-in shortcuts.
  pause
  exit /b
)

if not exist "%LAUNCHER%" (
  echo Can't find "Open Daily Breakdown.bat" next to this file.
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$s = New-Object -ComObject WScript.Shell; foreach($d in @([Environment]::GetFolderPath('Startup'),[Environment]::GetFolderPath('Programs'))){ $l = $s.CreateShortcut((Join-Path $d 'Daily Breakdown.lnk')); $l.TargetPath = $env:LAUNCHER; $l.WorkingDirectory = $env:WORKDIR; $l.WindowStyle = 7; $l.IconLocation = 'shell32.dll,165'; $l.Save() }"

echo.
echo Done. Daily Breakdown is in your Start menu and will open when you sign in.
echo.
pause
endlocal
