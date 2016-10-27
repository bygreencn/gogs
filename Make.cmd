@echo off

@SET GOPATH=C:\Projects\Go
@SET GOROOT=C:\Go

@SET SYS_PATH=%PATH%
@SET GOGS_SOURCE_PATH=%CD% 
@SET MINGW64_I386_PATH=C:\mingw-w64\mingw32\bin
@SET MINGW64_X86X64_PATH=C:\mingw-w64\mingw64\bin
@SET GOGS_EXE=gogs.exe

for /F "delims=\" %%i in ("%~dp0%") do (
  SET GOGS_EXE=%%~nxi
)
@SET GOGS_EXE=%GOGS_EXE%.exe

@echo ##### 1.Update Gogs...
git fetch --all 
git reset --hard origin/master

@echo ##### 2.Update 3rdparty...
REM gopm get -u -g -v
go get -u -tags "sqlite cert" github.com/gogits/gogs

cd %GOGS_SOURCE_PATH%
go clean 
go clean -tags "sqlite cert"

@SET CGO_ENABLED=1

@echo.
@echo **************************************************
@echo 1.Setting up environment for MinGW-w64 GCC for 32-bit...
SET PATH=%MINGW64_I386_PATH%;%GOPATH%\bin;%SYS_PATH%
@echo 2.Setting up environment for golang for 32-bit...
cd %GOROOT%/src
SET GOOS=windows
SET GOARCH=386
@echo 3.Building Compiler...
call make.bat --no-clean || exit
@echo 4.Building Gogs...
cd %GOGS_SOURCE_PATH%
go build -tags "sqlite cert" -v
@echo 5.Cleaning Env...
copy %GOGS_EXE% gogs-i386.exe
go clean -tags "sqlite cert" -v
@echo **************************************************

@echo.
@echo **************************************************
@echo 1.Setting up environment for MinGW-w64 GCC for 64-bit...
@SET PATH=%MINGW64_X86X64_PATH%;%GOPATH%\bin;%SYS_PATH%
@echo 2.Setting up environment for golang for 64-bit...
cd %GOROOT%/src
SET GOOS=windows
SET GOARCH=amd64
@echo 3.Building Compiler...
call make.bat --no-clean
@echo 4.Building Gogs...
cd %GOGS_SOURCE_PATH%
go build -tags "sqlite cert" -v
@echo 5.Cleaning Env...
copy %GOGS_EXE%  gogs-x86_x64.exe
go clean -tags "sqlite cert" -v
@echo **************************************************

SET PATH=%SYS_PATH%
echo on


