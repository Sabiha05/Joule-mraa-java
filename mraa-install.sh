#!/bin/bash
#Installing Mraa

clear
echo "Beginning install!"
sleep 1
mkdir buildMraa
cd buildMraa
checkCmake="1"
#Check if Cmake exists
command -v cmake >/dev/null 2>&1 || { echo >&2 "MRAA requires Cmake, Installing Cmake!"; checkCmake="0"; }
if [ "$checkCmake" = "0" ]; then #Have to install Cmake
        sleep 1
        git clone https://github.com/Kitware/CMake.git
        cd CMake
        ./bootstrap
        make
        make install
        cd ..
        clear
        echo "CMake installed! Preparing to build Mraa."
        sleep 1
fi
echo "CMake already installed, preparing to build Mraa."
sleep 1
git clone https://github.com/intel-iot-devkit/mraa.git
cd mraa
mkdir build
cd build
export JAVA_HOME=/usr/lib/jvm/open-jdk/8/
cmake -DBUILDSWIGJAVA=ON ..
make
make install #Should install Mraa in /usr/lib64/
set( JAVA_AWT_INCLUDE_PATH $ENV{JAVA_HOME}/include CACHE PATH "" FORCE)
set( JAVA_AWT_LIBRARY $ENV{JAVA_HOME}/jre/lib/amd64/libjawt.so CACHE FILEPATH "" FORCE)
set( JAVA_INCLUDE_PATH $ENV{JAVA_HOME}/include CACHE PATH "" FORCE)
set( JAVA_INCLUDE_PATH2 $ENV{JAVA_HOME}/include/linux CACHE PATH "" FORCE)
set( JAVA_JVM_LIBRARY $ENV{JAVA_HOME}/jre/lib/amd64/libjvm.so CACHE FILEPATH "" FORCE)
rm /usr/lib/libmraa.so* #Remove previous version of Mraa
mv  /usr/lib64/libmraa.so* /usr/lib #Move NEW Mraa files to lib
mv /usr/lib64/pkgconfig/* /usr/lib/pkgconfig #Move package configuration info
rm -r /usr/lib64/

#Cleanup
cd ../../../
rm -r buildMraa
clear
echo $'Install complete!\n'
mraa-gpio version
