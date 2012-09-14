@echo off

echo ---------------         >  generate.log
echo script:    generate.bat >> generate.log
echo arguments: %1 %2        >> generate.log
echo directory: %cd%         >> generate.log
echo ---------------         >> generate.log

goto help_end
:help
echo.
echo.usage:
echo.  generate.bat compiler build
echo.
echo.arguments:
echo.  compiler: vs2005, vs2008, vs2010, nm2005, nm2008, nm2010
echo.  build:    debug, release (default)
exit /B 1
:help_end

set compiler=%1
set build=%2
if "%build%" == "" set build=release

if "%compiler%" == "" echo compiler parameter not specified
if "%compiler%" == "" echo [%date%-%time%] compiler parameter not specified >> generate.log && goto help
if "%compiler%" == "vs2005" goto compiler_end
if "%compiler%" == "vs2008" goto compiler_end
if "%compiler%" == "vs2010" goto compiler_end
if "%compiler%" == "nm2005" goto compiler_end
if "%compiler%" == "nm2008" goto compiler_end
if "%compiler%" == "nm2010" goto compiler_end
    echo compiler "%compiler%" not supported
    echo [%date%-%time%] compiler "%compiler%" not supported >> generate.log && goto help
:compiler_end

if "%build%" == "" echo build parameter not specified
if "%build%" == "" echo [%date%-%time%] build parameter not specified >> generate.log && goto help
if "%build%" == "debug" goto build_end
if "%build%" == "release" goto build_end
    echo build "%build%" not supported
    echo [%date%-%time%] build "%build%" not supported >> generate.log && goto help
:build_end

if "%compiler%" == "vs2005" set environment=%VS80COMNTOOLS%vsvars32.bat
if "%compiler%" == "vs2008" set environment=%VS90COMNTOOLS%vsvars32.bat
if "%compiler%" == "vs2010" set environment=%VS100COMNTOOLS%vsvars32.bat
if "%compiler%" == "nm2005" set environment=%VS80COMNTOOLS%vsvars32.bat
if "%compiler%" == "nm2008" set environment=%VS90COMNTOOLS%vsvars32.bat
if "%compiler%" == "nm2010" set environment=%VS100COMNTOOLS%vsvars32.bat

if "%compiler%" == "vs2005" set generator=Visual Studio 8 2005
if "%compiler%" == "vs2008" set generator=Visual Studio 9 2008
if "%compiler%" == "vs2010" set generator=Visual Studio 10
if "%compiler%" == "nm2005" set generator=NMake Makefiles
if "%compiler%" == "nm2008" set generator=NMake Makefiles
if "%compiler%" == "nm2010" set generator=NMake Makefiles

set directory=build_%compiler%_%build%

if "%compiler:~0,2%" == "vs" goto environment_end
    if exist "%environment%" goto filename_end
        echo %environment% environment not found
        echo [%date%-%time%] %environment% environment not found >> generate.log && exit /B 1
    :filename_end
    echo setting up environment
    echo [%date%-%time%] setting up environment >> generate.log
    call "%environment%" >> generate.log 2>&1
:environment_end

echo creating build directory
echo [%date%-%time%] creating build directory >> generate.log
mkdir %directory% >> generate.log 2>&1
cd %directory%

echo generating build environment
echo [%date%-%time%] generating build environment >> ..\generate.log
if "%compiler:~0,2%" == "vs" cmake -G"%generator%" -DCMAKE_INSTALL_PREFIX=dist ..\..\ >> ..\generate.log 2>&1
if "%compiler:~0,2%" == "nm" cmake -G"%generator%" -DCMAKE_BUILD_TYPE=%build% -DCMAKE_INSTALL_PREFIX=dist ..\..\ >> ..\generate.log 2>&1
if errorlevel 1 cmake-gui . >> ..\generate.log 2>&1

goto skip
%"path_before% @echo off
%"path_vs2005% set filename=%VS80COMNTOOLS%vsvars32.bat
%"path_vs2008% set filename=%VS90COMNTOOLS%vsvars32.bat
%"path_vs2010% set filename=%VS100COMNTOOLS%vsvars32.bat
%"path_after%  if not exist "%filename%" goto eof
%"path_after%  call "%filename%"
%"path_after%  call path.bat
%"path_after%  devenv ALVAR.sln
:skip

if "%compiler:~0,2%" == "nm" goto path_end
    echo setting up batch file
    echo [%date%-%time%] setting up batch file >> ..\generate.log
    type "%~f0" | find "%%""path_before%%" > ALVAR.sln.bat
    type "%~f0" | find "%%""path_%compiler%%%" >> ALVAR.sln.bat
    type "%~f0" | find "%%""path_after%%" >> ALVAR.sln.bat
:path_end

cd..
