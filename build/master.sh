#!/bin/bash

echo ---------------        >  master.log
echo "script:    master.sh" >> master.log
echo "arguments: $1 $2"     >> master.log
echo "directory: `pwd`"     >> master.log
echo ---------------        >> master.log

function help {
    echo
    echo "usage:"
    echo "  master.sh clean dashboard"
    echo
    echo "arguments:"
    echo "  clean:     clean, no-clean (default)"
    echo "  dashboard: nightly, experimental (default)"
    exit 1
}

clean=$1
if [ "$clean" == "" ]; then
    clean=no-clean
fi
dashboard=$2
if [ "$dashboard" == "" ]; then
    dashboard=experimental
fi

if [ "$clean" == "" ]; then
    echo clean parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] clean parameter not specified >> master.log
    help
fi
if [ "$clean" != "clean" -a "$clean" != "no-clean" ]; then
    echo clean "$clean" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] clean "$clean" not supported >> master.log
    help
fi

if [ "$dashboard" == "" ]; then
    echo dashboard parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] dashboard parameter not specified >> master.log
    help
fi
if [ "$dashboard" != "nightly" -a "$dashboard" != "experimental" ]; then
    echo dashboard "$dashboard" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] dashboard "$dashboard" not supported >> master.log
    help
fi

echo alvar master build script
echo [`date "+%Y/%m/%d-%H:%M:%S"`] alvar master build script >> master.log

startTime=`date "+%s"`

if [ "$clean" == "clean" ]; then
    echo cleaning
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] cleaning >> master.log
    for C in gcc43 gcc44 gcc45; do
        rm -rd "build_"$C"_debug"   >> master.log 2>&1
        rm -rd "build_"$C"_release" >> master.log 2>&1
    done
    rm -rd log >> master.log 2>&1
fi

mkdir log >> /dev/null 2>&1

for C in gcc43 gcc44; do
    echo building "sdk-"$C"-debug"
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] building "sdk-"$C"-debug" >> master.log
    bash build.sh sdk $C debug no-doc $dashboard
    mv build.log "log/build_sdk_"$C"_debug.log" >> master.log 2>&1

    echo building "sdk-"$C"-release"
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] building "sdk-"$C"-release" >> master.log
    bash build.sh sdk $C release doc $dashboard
    mv build.log "log/build_sdk_"$C"_release.log" >> master.log 2>&1

    echo packaging "sdk-"$C
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] pakcaging "sdk-"$C >> master.log
    bash package.sh sdk $C
    mv package.log "log/package_sdk_"$C".log" >> master.log 2>&1
done

echo building bin-gcc44-release
echo [`date "+%Y/%m/%d-%H:%M:%S"`] building bin-gcc44-release >> master.log
bash build.sh bin gcc44 release doc $dashboard
mv build.log "log/build_bin_gcc44_release.log" >> master.log 2>&1

echo packaging bin-gcc44
echo [`date "+%Y/%m/%d-%H:%M:%S"`] pakcaging bin-gcc44 >> master.log
bash package.sh bin gcc44
mv package.log log/package_bin_gcc44.log >> master.log 2>&1

endTime=`date "+%s"`
diffTimestamp=`expr $endTime - $startTime`
diffTime=`date -d "1970-01-01 $diffTimestamp sec" "+%H:%M:%S"`

echo done, $diffTime
echo [`date "+%Y/%m/%d-%H:%M:%S"`] done, $diffTime >> master.log
