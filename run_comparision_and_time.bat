@echo off
setlocal enabledelayedexpansion

set SPARK_SCALA_FILE=code\SparkExample.scala
set PYSPARK_FILE=pyspark_example.py
set JAR_FILE=target\scala-2.12\sparkvspyspark_2.12-1.0.jar

if not exist "%JAR_FILE%" (
    echo Error: Scala JAR file not found. Please compile it first using compile_spark_code.bat.
    exit /B 1
)

if not exist "%PYSPARK_FILE%" (
    echo Error: PySpark script not found. Please check the file path.
    exit /B 1
)

echo Running Spark job...
start /B spark-submit --class SparkExample --master local[4] "%JAR_FILE%"
echo Spark job is running...

echo Running PySpark job...
start /B python "%PYSPARK_FILE%"
echo PySpark job is running...

exit /B

