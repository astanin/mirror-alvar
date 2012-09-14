@echo off

echo ---------------       >  master.log
echo script:    master.bat >> master.log
echo arguments: %1 %2      >> master.log
echo directory: %cd%       >> master.log
echo ---------------       >> master.log

goto help_end
:help
echo.
echo.usage:
echo.  master.bat clean dashboard
echo.
echo.arguments:
echo.  clean:     clean, no-clean (default)
echo.  dashboard: nightly, experimental (default)
exit /B 1
:help_end

set clean=%1
if "%clean%" == "" set clean=no-clean
set dashboard=%2
if "%dashboard%" == "" set dashboard=experimental

if "%clean%" == "" echo clean parameter not specified
if "%clean%" == "" echo [%date%-%time%] clean parameter not specified >> master.log && goto help
if "%clean%" == "clean" goto clean_end
if "%clean%" == "no-clean" goto clean_end
    echo clean "%clean%" not supported
    echo [%date%-%time%] clean "%clean%" not supported >> master.log && goto help
:clean_end

if "%dashboard%" == "" echo dashboard parameter not specified
if "%dashboard%" == "" echo [%date%-%time%] dashboard parameter not specified >> master.log && goto help
if "%dashboard%" == "nightly" goto dashboard_end
if "%dashboard%" == "experimental" goto dashboard_end
    echo dashboard "%dashboard%" not supported
    echo [%date%-%time%] dashboard "%dashboard%" not supported >> master.log && goto help
:dashboard_end

echo alvar master build script
echo [%date%-%time%] alvar master build script >> master.log

set startTime=%time%

if not "%1" == "clean" goto clean_end
echo cleaning
echo [%date%-%time%] cleaning >> master.log
for %%C in (nm2005 nm2008 nm2010) do (
    rmdir /S /Q build_%%C_debug   >> master.log 2>&1
    rmdir /S /Q build_%%C_release >> master.log 2>&1
)
rmdir /S /Q log >> master.log 2>&1
:clean_end

if not exist log mkdir log >> nul 2>&1

for %%C in (nm2005 nm2008 nm2010) do (
    echo building sdk-%%C-debug
    echo [%date%-%time%] building sdk-%%C-debug >> master.log
    %comspec% /C build.bat sdk %%C debug no-doc %dashboard%
    move build.log log\build_sdk_%%C_debug.log >> master.log 2>&1

    echo building sdk-%%C-release
    echo [%date%-%time%] building sdk-%%C-release >> master.log
    %comspec% /C build.bat sdk %%C release doc %dashboard%
    move build.log log\build_sdk_%%C_release.log >> master.log 2>&1

    echo packaging sdk-%%C
    echo [%date%-%time%] packaging sdk-%%C >> master.log
    %comspec% /C package.bat sdk %%C
    move package.log log\package_sdk_%%C.log >> master.log 2>&1
)

echo building bin-nm2010-release
echo [%date%-%time%] building bin-nm2010-release >> master.log
%comspec% /C build.bat bin nm2010 release doc %dashboard%
move build.log log\build_bin_nm2010_release.log >> master.log 2>&1

echo packaging bin-nm2010
echo [%date%-%time%] packaging bin-nm2010 >> master.log
%comspec% /C package.bat bin nm2010
move package.log log\package_bin_nm2010.log >> master.log 2>&1

set endTime=%time%

:: extract hours, minutes and seconds
set startHour=%startTime:~0,2%
set startMinute=%startTime:~3,2%
set startSecond=%startTime:~6,2%
set endHour=%endTime:~0,2%
set endMinute=%endTime:~3,2%
set endSecond=%endTime:~6,2%
:: remove leading whitespace from hours
set tmpHour=
for %%A in (%startHour%) do set tmpHour=%tmpHour%%%A
set startHour=%tmpHour%
set tmpHour=
for %%A in (%endHour%) do set tmpHour=%tmpHour%%%A
set endHour=%tmpHour%
:: remove leading 0 from minutes and seconds
set /A startMinute = 100%startMinute% %% 100
set /A startSecond = 100%startSecond% %% 100
set /A endMinute = 100%endMinute% %% 100
set /A endSecond = 100%endSecond% %% 100
:: convert to timestamp
set /A startTimestamp = (%startHour% * 3600) + (%startMinute% * 60) + (%startSecond%)
set /A endTimestamp = (%endHour% * 3600) + (%endMinute% * 60) + (%endSecond%)
:: compute difference
set /A diffTimestamp = %endTimestamp% - %startTimestamp%
:: convert back to time notation
set /A diffHour = (%diffTimestamp% / 3600)
set /A diffMinute = (%diffTimestamp% - (%diffHour% * 3600)) / 60
set /A diffSecond = (%diffTimestamp% - (%diffHour% * 3600) - (%diffMinute% * 60))
:: add leading 0 if necessary
set diffHour=0%diffHour%
set diffMinute=0%diffMinute%
set diffSecond=0%diffSecond%
set diffHour=%diffHour:~-2%
set diffMinute=%diffMinute:~-2%
set diffSecond=%diffSecond:~-2%

echo done, %diffHour%:%diffMinute%:%diffSecond%
echo [%date%-%time%] done, %diffHour%:%diffMinute%:%diffSecond% >> master.log
