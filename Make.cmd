@echo off

@set SYS_PATH=%PATH%
@set GOGS_SOURCE_PATH=%CD% 
@set MINGW64_I386_PATH=C:\mingw-w64\mingw32\bin
@set MINGW64_X86X64_PATH=C:\mingw-w64\mingw64\bin


cd %GOGS_SOURCE_PATH%
go clean 
go clean -tags "tidb sqlite cert"

@set CGO_ENABLED=1

echo *************************************************************
echo 1. Setting up environment for MinGW-w64 GCC for 32-bit...
set PATH=%MINGW64_I386_PATH%;%GOPATH%\bin;%SYS_PATH%
echo 2. Setting up environment for golang for 32-bit...
cd %GOROOT%/src
set GOOS=windows
set GOARCH=386
call make.bat --no-clean
cd %GOGS_SOURCE_PATH%
go build -tags "tidb sqlite cert"
copy gogs.exe gogs-i386.exe
go clean -tags "tidb sqlite cert"

@echo *************************************************************
@echo 1. Setting up environment for MinGW-w64 GCC for 64-bit...
@set PATH=%MINGW64_X86X64_PATH%;%GOPATH%\bin;%SYS_PATH%
@echo 2. Setting up environment for golang for 64-bit...
cd %GOROOT%/src
set GOOS=windows
set GOARCH=amd64
call make.bat --no-clean
cd %GOGS_SOURCE_PATH%
go build -tags "tidb sqlite cert"
copy gogs.exe gogs-x86_x64.exe
go clean -tags "tidb sqlite cert"

set PATH=%SYS_PATH%
echo on


