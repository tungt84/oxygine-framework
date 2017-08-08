set PATH=D:\Tools\cmake-3.9.0-rc5-win64-x64\bin\;%PATH%
IF "%1"=="clean" (
cd .. 
IF NOT EXIST cmakebuid (
mkdir cmakebuid
)
cd cmakebuid

make clean

goto exit
)

IF "%1"=="all" (
cd ..
IF NOT EXIST cmakebuid (
mkdir cmakebuid
)
cd cmakebuid
cmake -G "Unix Makefiles"  -DCMAKE_TOOLCHAIN_FILE=d:/Data/Library/oxygine-framework/Tizen.cmake  ..
make
cd ..
cd Debug
copy ..\cmakebuid\helloworld .\ 
goto exit
)

:exit