@echo off

echo ---------------            >  build.log
echo script:    build.bat       >> build.log
echo arguments: %1 %2 %3 %4 %5  >> build.log
echo directory: %cd%            >> build.log
echo ---------------            >> build.log

goto help_end
:help
echo.
echo.usage:
echo.  build.bat package compiler build documentation dashboard
echo.
echo.arguments:
echo.  package:       sdk, bin
echo.  compiler:      nm2005, nm2008, nm2010
echo.  build:         debug, release (default)
echo.  documentation: doc, no-doc (default)
echo.  dashboard:     nightly, experimental (default)
exit /B 1
:help_end

set package=%1
set compiler=%2
set build=%3
if "%build%" == "" set build=release
set documentation=%4
if "%documentation%" == "" set documentation=no-doc
set dashboard=%5
if "%dashboard%" == "" set dashboard=experimental

if "%package%" == "" echo package parameter not specified
if "%package%" == "" echo [%date%-%time%] package parameter not specified >> build.log && goto help
if "%package%" == "sdk" goto package_end
if "%package%" == "bin" goto package_end
    echo package "%package%" not supported
    echo [%date%-%time%] package "%package%" not supported >> build.log && goto help
:package_end

if "%compiler%" == "" echo compiler parameter not specified
if "%compiler%" == "" echo [%date%-%time%] compiler parameter not specified >> build.log && goto help
if "%compiler%" == "nm2005" goto compiler_end
if "%compiler%" == "nm2008" goto compiler_end
if "%compiler%" == "nm2010" goto compiler_end
    echo compiler "%compiler%" not supported
    echo [%date%-%time%] compiler "%compiler%" not supported >> build.log && goto help
:compiler_end

if "%build%" == "" echo build parameter not specified
if "%build%" == "" echo [%date%-%time%] build parameter not specified >> build.log && goto help
if "%build%" == "debug" goto build_end
if "%build%" == "release" goto build_end
    echo build "%build%" not supported
    echo [%date%-%time%] build "%build%" not supported >> build.log && goto help
:build_end

if "%documentation%" == "" echo documentation parameter not specified
if "%documentation%" == "" echo [%date%-%time%] documentation parameter not specified >> build.log && goto help
if "%documentation%" == "doc" goto documentation_end
if "%documentation%" == "no-doc" goto documentation_end
    echo documentation "%documentation%" not supported
    echo [%date%-%time%] documentation "%documentation%" not supported >> build.log && goto help
:documentation_end

if "%dashboard%" == "" echo dashboard parameter not specified
if "%dashboard%" == "" echo [%date%-%time%] dashboard parameter not specified >> build.log && goto help
if "%dashboard%" == "nightly" goto dashboard_end
if "%dashboard%" == "experimental" goto dashboard_end
    echo dashboard "%dashboard%" not supported
    echo [%date%-%time%] dashboard "%dashboard%" not supported >> build.log && goto help
:dashboard_end

if "%compiler%" == "nm2005" set environment=%VS80COMNTOOLS%..\..\VC\vcvarsall.bat
if "%compiler%" == "nm2008" set environment=%VS90COMNTOOLS%..\..\VC\vcvarsall.bat
if "%compiler%" == "nm2010" set environment=%VS100COMNTOOLS%..\..\VC\vcvarsall.bat

set bitness=x86
if defined ProgramW6432 set bitness=amd64
if defined ALVAR_BITNESS set bitness=%ALVAR_BITNESS%

set directory=build_%package%_%compiler%_%build%

if exist "%environment%" goto filename_end
    echo %environment% environment not found
    echo [%date%-%time%] %environment% environment not found >> build.log && exit /B 1
:filename_end
echo setting up environment
echo [%date%-%time%] setting up environment >> build.log
call "%environment%" %bitness% >> build.log 2>&1

echo creating build directory
echo [%date%-%time%] creating build directory >> build.log
mkdir %directory% >> build.log 2>&1
cd %directory%

echo generating build environment
echo [%date%-%time%] generating build environment >> ..\build.log
cmake -G"NMake Makefiles" -DCMAKE_BUILD_TYPE=%build% -DCMAKE_INSTALL_PREFIX=dist -DALVAR_PACKAGE=%package% -DBUILDNAME=win32-%compiler%-%build% ..\..\ >> ..\build.log 2>&1

echo compiling
echo [%date%-%time%] compiling >> ..\build.log
nmake INSTALL >> ..\build.log 2>&1

if "%documentation%" == "no-doc" goto skip_documentation
    echo generating documentation
    echo [%date%-%time%] generating documentation >> ..\build.log
    nmake Documentation >> ..\build.log 2>&1
    nmake INSTALL >> ..\build.log 2>&1
:skip_documentation

echo running tests and uploading to dashboard
echo [%date%-%time%] running tests and uploading to dashboard >> ..\build.log
if "%dashboard%" == "nightly" set target=Nightly
if "%dashboard%" == "experimental" set target=Experimental
call path.bat
nmake %target% >> ..\build.log 2>&1

cd..
