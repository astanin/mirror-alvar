#!/bin/bash

echo ---------------         >  package.log
echo "script:    package.sh" >> package.log
echo "arguments: $1 $2"      >> package.log
echo "directory: `pwd`"      >> package.log
echo ---------------         >> package.log

function help {
    echo
    echo "usage:"
    echo "  package.sh package compiler"
    echo
    echo "arguments:"
    echo "  package: sdk, bin"
    echo "  compiler: gcc43, gcc44, gcc45"
    exit 1
}

package=$1
compiler=$2

if [ "$package" == "" ]; then
    echo package parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] package parameter not specified >> package.log
    help
fi
if [ "$package" != "sdk" -a "$package" != "bin" ]; then
    echo package "$package" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] package "$package" not supported >> package.log
    help
fi

if [ "$compiler" == "" ]; then
    echo compiler parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] compiler parameter not specified >> package.log
    help
fi
if [ "$compiler" != "gcc43" -a "$compiler" != "gcc44" -a "$compiler" != "gcc45" ]; then
    echo compiler "$compiler" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] compiler "$compiler" not supported >> package.log
    help
fi

directory_debug="build_"$package"_"$compiler"_debug"
directory_release="build_"$package"_"$compiler"_release"

if [ "$package" == "sdk" ]; then
    if [ ! -d "$directory_debug" ]; then
        echo $directory_debug directory not found
        echo [`date "+%Y/%m/%d-%H:%M:%S"`] $directory_debug directory not found >> package.log
        exit 1
    fi
fi

if [ ! -d "$directory_release" ]; then
    echo $directory_release directory not found
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] $directory_release directory not found >> package.log
    exit 1
fi

cd $directory_release

echo packaging
echo [`date "+%Y/%m/%d-%H:%M:%S"`] packaging >> ../package.log
cpack >> ../package.log 2>&1

echo moving package
echo [`date "+%Y/%m/%d-%H:%M:%S"`] moving package >> ../package.log
mv *.gz .. >> ../package.log 2>&1

cd ..
