#!/bin/bash

echo ---------------          >  generate.log
echo "script:    generate.sh" >> generate.log
echo "arguments: $1 $2"       >> generate.log
echo "directory: `pwd`"       >> generate.log
echo ---------------          >> generate.log

function help {
    echo
    echo "usage:"
    echo "  generate.sh compiler build"
    echo
    echo "arguments:"
    echo "  compiler: gcc43 gcc44 gcc45"
    echo "  build:    debug, release (default)"
    exit 1
}

compiler=$1
build=$2
if [ "$build" == "" ]; then
    build=release
fi

if [ "$compiler" == "" ]; then
    echo compiler parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] compiler parameter not specified >> generate.log
    help
fi
if [ "$compiler" != "gcc43" -a "$compiler" != "gcc44" -a "$compiler" != "gcc45" ]; then
    echo compiler "$compiler" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] compiler "$compiler" not supported >> generate.log
    help
fi

if [ "$build" == "" ]; then
    echo build parameter not specified
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] build parameter not specified >> generate.log
    help
fi
if [ "$build" != "debug" -a "$build" != "release" ]; then
    echo build "$build" not supported
    echo [`date "+%Y/%m/%d-%H:%M:%S"`] build "$build" not supported >> generate.log
    help
fi

if [ "$compiler" == "gcc43" ]; then
    environment="/usr/bin/gcc-4.3"
elif [ "$compiler" == "gcc44" ]; then
    environment="/usr/bin/gcc-4.4"
elif [ "$compiler" == "gcc45" ]; then
    environment="/usr/bin/gcc-4.5"
fi

generator="Unix Makefiles"
directory="build_"$compiler"_"$build
build=`echo -n "${build:0:1}" | tr "[:lower:]" "[:upper:]"`${build:1}

echo creating build directory
echo [`date "+%Y/%m/%d-%H:%M:%S"`] creating build directory >> generate.log
mkdir $directory >> generate.log 2>&1
cd $directory

echo generating build environment
echo [`date "+%Y/%m/%d-%H:%M:%S"`] generating build environment >> ../generate.log
cmake -G"$generator" -DCMAKE_BUILD_TYPE=`echo -n "${build:0:1}" | tr "[:lower:]" "[:upper:]"`${build:1} \
      -DCMAKE_C_COMPILER="$environment" -DCMAKE_CXX_COMPILER="`echo $environment | sed -e 's/c/\+/g'`" \
      -DCMAKE_INSTALL_PREFIX=dist \
      ../../ >> ../generate.log 2>&1
if [ $? -ne 0 ]; then
    cmake-gui . >> ../generate.log 2>&1
fi

cd ..
