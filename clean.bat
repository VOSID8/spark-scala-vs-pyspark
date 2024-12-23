@echo off
setlocal

set PROJECT_DIR=project
set TARGET_DIR=target

echo Cleaning project directory: %PROJECT_DIR%
rmdir /S /Q "%PROJECT_DIR%" 

echo Cleaning target directory: %TARGET_DIR%
rmdir /S /Q "%TARGET_DIR%"

echo Project and target directories cleaned successfully.

exit /B
