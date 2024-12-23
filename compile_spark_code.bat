@echo off
setlocal

set PROJECT_DIR=code
set JAR_FILE=%PROJECT_DIR%\SparkExample.jar
set TARGET_DIR=%PROJECT_DIR%\target\scala-2.12

where python > nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH.
    exit /B 1
)

where pip > nul 2>&1
if %errorlevel% neq 0 (
    echo Error: pip is not installed or not in PATH.
    exit /B 1
)

pip show pyspark > nul 2>&1
if %errorlevel% neq 0 (
    echo PySpark is not installed. Installing PySpark...
    pip install pyspark
    if %errorlevel% neq 0 (
        echo Error: Failed to install PySpark.
        exit /B 1
    )
    echo PySpark installed successfully.
) else (
    echo PySpark is already installed.
)

where sbt > nul 2>&1
if %errorlevel% neq 0 (
    echo Error: sbt is not installed or not in PATH.
    exit /B 1
)

cd /d %PROJECT_DIR%

if not exist "build.sbt" (
    echo Error: build.sbt file not found in the project directory.
    exit /B 1
)

echo Compiling Scala code...
sbt clean compile package

if exist "%TARGET_DIR%\sparkvspyspark_2.12-1.0.jar" (
    echo Scala code compiled successfully and JAR file created.
    echo Moving the JAR file to the correct directory...
    move /Y "%TARGET_DIR%\sparkvspyspark_2.12-1.0.jar" "%PROJECT_DIR%\SparkExample.jar"
    echo JAR file moved to %PROJECT_DIR%\SparkExample.jar.
) else (
    echo Error: Failed to compile Scala code or create JAR file.
    exit /B 1
)
exit /B
