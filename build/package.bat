@echo off

echo ---------------        >  package.log
echo script:    package.bat >> package.log
echo arguments: %1 %2       >> package.log
echo directory: %cd%        >> package.log
echo ---------------        >> package.log

goto help_end
:help
echo.
echo.usage:
echo.  package.bat package compiler
echo.
echo.arguments:
echo.  package: sdk, bin
echo.  compiler: nm2005, nm2008, nm2010
exit /B 1
:help_end

set package=%1
set compiler=%2

if "%package%" == "" echo package parameter not specified
if "%package%" == "" echo [%date%-%time%] package parameter not specified >> package.log && goto help
if "%package%" == "sdk" goto package_end
if "%package%" == "bin" goto package_end
    echo package "%package%" not supported
    echo [%date%-%time%] package "%package%" not supported >> package.log && goto help
:package_end

if "%compiler%" == "" echo compiler parameter not specified
if "%compiler%" == "" echo [%date%-%time%] compiler parameter not specified >> package.log && goto help
if "%compiler%" == "nm2005" goto compiler_end
if "%compiler%" == "nm2008" goto compiler_end
if "%compiler%" == "nm2010" goto compiler_end
    echo compiler "%compiler%" not supported
    echo [%date%-%time%] compiler "%compiler%" not supported >> package.log && goto help
:compiler_end

if "%compiler%" == "nm2005" set environment=%VS80COMNTOOLS%..\..\VC\vcvarsall.bat
if "%compiler%" == "nm2008" set environment=%VS90COMNTOOLS%..\..\VC\vcvarsall.bat
if "%compiler%" == "nm2010" set environment=%VS100COMNTOOLS%..\..\VC\vcvarsall.bat

set bitness=x86
if defined ProgramW6432 set bitness=amd64
if defined ALVAR_BITNESS set bitness=%ALVAR_BITNESS%

set directory_debug=build_%package%_%compiler%_debug
set directory_release=build_%package%_%compiler%_release

if exist "%environment%" goto filename_end
    echo %environment% environment not found
    echo [%date%-%time%] %environment% environment not found >> package.log && exit /B 1
:filename_end
echo setting up environment
echo [%date%-%time%] setting up environment >> package.log
call "%environment%" %bitness% >> package.log 2>&1

if "%package%" == "bin" goto debug_end
if exist "%directory_debug%" goto debug_end
    echo %directory_debug% directory not found
    echo [%date%-%time%] %directory_debug% directory not found >> package.log && exit /B 1
:debug_end

if exist "%directory_release%" goto release_end
    echo %directory_release% directory not found
    echo [%date%-%time%] %directory_release% directory not found >> package.log && exit /B 1
:release_end

cd %directory_release%

echo packaging
echo [%date%-%time%] packaging >> ..\package.log
cpack >> ..\package.log 2>&1

echo moving package
echo [%date%-%time%] moving package >> ..\package.log
move *.exe .. >> ..\package.log 2>&1

cd..
