#!/bin/bash

echo ---------------             >  build.log
echo "script:    build.sh"       >> build.log
echo "arguments: $1 $2 $3 $4 $5" >> build.log
echo "directory: `pwd`"          >> build.log
echo ---------------             >> build.log

function help {
    echo
    echo "usage:"
    echo "  build.sh package compiler build documentation dashboard"
    echo
    echo "arguments:"
    echo "  package:       sdk, bin"
    echo "  compiler:      gcc43, gcc44, gcc45"
    echo "  build:         debug, release (default)"
    echo "  documentation: doc, no-doc (default)"
    echo "  dashboard:     nightly, experimental (default)"
    exit 1
}

package=$1
compiler=$2
build=$3
if [ "$build" == "" ]; then
    build=release
fi
documentation=$4
if [ "$documentation" == "" ]; then
    documentation=no-doc
fi
dashboard=$5
if [ "$dashboard" == "" ]; then
    dashboard=experimental
fi

if [ "$package" == "" ]; then
    echo package parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] package parameter not specified >> build.log
    help
fi
if [ "$package" != "sdk" -a "$package" != "bin" ]; then
    echo package "$package" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] package "$package" not supported >> build.log
    help
fi

if [ "$compiler" == "" ]; then
    echo compiler parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] compiler parameter not specified >> build.log
    help
fi
if [ "$compiler" != "gcc43" -a "$compiler" != "gcc44" -a "$compiler" != "gcc45" ]; then
    echo compiler "$compiler" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] compiler "$compiler" not supported >> build.log
    help
fi

if [ "$build" == "" ]; then
    echo build parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] build parameter not specified >> build.log
    help
fi
if [ "$build" != "debug" -a "$build" != "release" ]; then
    echo build "$build" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] build "$build" not supported >> build.log
    help
fi

if [ "$documentation" == "" ]; then
    echo documentation parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] documentation parameter not specified >> build.log
    help
fi
if [ "$documentation" != "doc" -a "$documentation" != "no-doc" ]; then
    echo documentation "$documentation" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] documentation "$documentation" not supported >> build.log
    help
fi

if [ "$dashboard" == "" ]; then
    echo dashboard parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] dashboard parameter not specified >> build.log
    help
fi
if [ "$dashboard" != "nightly" -a "$dashboard" != "experimental" ]; then
    echo dashboard "$dashboard" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] dashboard "$dashboard" not supported >> build.log
    help
fi

if [ "$compiler" == "gcc43" ]; then
    environment="/usr/bin/gcc-4.3"
elif [ "$compiler" == "gcc44" ]; then
    environment="/usr/bin/gcc-4.4"
elif [ "$compiler" == "gcc45" ]; then
    environment="/usr/bin/gcc-4.5"
fi

bitness=32
machine=`uname -m`
if [ "$machine" == "x86_64" ]; then
    bitness=64
fi

directory="build_"$package"_"$compiler"_"$build

echo creating build directory
echo [`date "+%Y/%m/%d-%H:%M:%S"`] creating build directory >> build.log
mkdir $directory >> build.log 2>&1
cd $directory

echo generating build environment
echo [`date "+%Y/%m/%d-%H:%M:%S"`] generating build environment >> ../build.log
cmake -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=`echo -n "${build:0:1}" | tr "[:lower:]" "[:upper:]"`${build:1} \
      -DCMAKE_C_COMPILER="$environment" -DCMAKE_CXX_COMPILER="`echo $environment | sed -e 's/c/\+/g'`" \
      -DCMAKE_INSTALL_PREFIX=dist \
      -DALVAR_PACKAGE=$package -DBUILDNAME=linux$bitness-$compiler-$build \
      ../../ >> ../build.log 2>&1

echo compiling
echo [`date "+%Y/%m/%d-%H:%M:%S"`] compiling >> ../build.log
make install >> ../build.log 2>&1

if [ "$documentation" == "doc" ]; then
    echo generating documentation
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] generating documentation >> ../build.log
    make Documentation >> ../build.log 2>&1
    make install >> ../build.log 2>&1
fi

echo running tests and uploading to dashboard
echo [`date "+%Y/%m/%d-%H:%M:%S"`] running tests and uploading to dashboard >> ../build.log
make `echo -n "${dashboard:0:1}" | tr "[:lower:]" "[:upper:]"`${dashboard:1} >> ../build.log 2>&1

cd ..
