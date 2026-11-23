@echo off
rem Opens Daily Breakdown in a small app-style Chrome window (falls back to Edge).
rem Keep this file in the same folder as daily-breakdown.html.
setlocal
set "P=%~dp0daily-breakdown.html"
set "P=%P:\=/%"
set "URL=file:///%P%"

set "BROWSER="
for %%B in (
  "%ProgramFiles%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
  "%LocalAppData%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
  "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
) do if not defined BROWSER if exist %%B set "BROWSER=%%~B"

if defined BROWSER (
  start "" "%BROWSER%" --app="%URL%" --window-size=460,820 --window-position=40,40
) else (
  rem No Chromium browser found: open in the default browser instead.
  start "" "%~dp0daily-breakdown.html"
)
endlocal
