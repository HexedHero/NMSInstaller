@echo off

:: Set all Minecraft NMS versions
set java8=1.8 1.8.3 1.8.8 1.9.2 1.9.4 1.10.2 1.11.2 1.12.2 1.13 1.13.2 1.14.4 1.15.2 1.16.1 1.16.3 1.16.5
set java16=1.17.1
set java17=1.18.1 1.18.2 1.19.2 1.19.3 1.19.4 1.20.1

:: Set JDK versions (https://adoptium.net/temurin/releases/)
set java8version=jdk8u382-b05
set java16version=jdk-16.0.2+7
set java17version=jdk-17.0.8.1+1

:: Delete old work folder
if exist NMSInstaller (
    title Removing old NMSInstaller folder...
    echo Removing old NMSInstaller folder...
    rmdir /s /q NMSInstaller
)

:: Make work folder
title Creating NMSInstaller folder...
echo Creating NMSInstaller folder...
mkdir NMSInstaller
cd NMSInstaller

:: Download JDKs
title Downloading JDKs...
echo Downloading JDKs...
curl -k https://api.adoptium.net/v3/binary/version/%java8version%/windows/x64/jdk/hotspot/normal/eclipse?project=jdk -o %java8version%.zip -L
curl -k https://api.adoptium.net/v3/binary/version/%java16version%/windows/x64/jdk/hotspot/normal/eclipse?project=jdk -o %java16version%.zip -L
curl -k https://api.adoptium.net/v3/binary/version/%java17version%/windows/x64/jdk/hotspot/normal/eclipse?project=jdk -o %java17version%.zip -L

:: Unzip JDKs
title Unzipping JDKs...
echo Unzipping JDKs...
powershell -Command "Expand-Archive %java8version%.zip"
powershell -Command "Expand-Archive %java16version%.zip"
powershell -Command "Expand-Archive %java17version%.zip"

:: Download BuildTools
title Downloading BuildTools...
echo Downloading BuildTools...
curl https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -o BuildTools.jar

:: Loop all NMS versions and build them
(for %%a in (%java8%) do (
   title Installing %%a...
   echo Installing %%a...
   "%java8version%/%java8version%/bin/java" -jar BuildTools.jar --rev %%a
))

(for %%a in (%java16%) do (
   title Installing %%a...
   echo Installing %%a...
   "%java16version%/%java16version%/bin/java" -jar BuildTools.jar --rev %%a
))

(for %%a in (%java17%) do (
   title Installing %%a...
   echo Installing %%a...
   "%java17version%/%java17version%/bin/java" -jar BuildTools.jar --rev %%a
))

:: Finished!
title Finished installing!
echo Finished installing!

pause
