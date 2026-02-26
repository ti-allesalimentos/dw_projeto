@echo off
setlocal

set PROJECT_DIR=C:\DW\dw_projeto
set LOG_DIR=C:\DW\dw_projeto\logs

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
cd /d "%PROJECT_DIR%"

REM Log fixo de debug (sempre escreve)
echo [%date% %time%] START >> "%LOG_DIR%\_scheduler_debug.log"
whoami >> "%LOG_DIR%\_scheduler_debug.log"

"%PROJECT_DIR%\.venv\Scripts\python.exe" -m scripts.run_pipeline

echo [%date% %time%] END (code=%ERRORLEVEL%) >> "%LOG_DIR%\_scheduler_debug.log"
exit /b %ERRORLEVEL%