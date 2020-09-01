#!/bin/bash

if test "$#" -lt 3 -o \
        \( "$1" != "i686" -a "$1" != "x86_64" \) -o \
        \( "$#" -gt 3 -a "$4" != "--hidden" \); then
    echo "Usage: $(basename $0) {i686|x86_64} go_script.go output.exe [--hidden]"
    exit 1
fi

set -e

arch=$1
filename=$(basename $2)
filename2=$(basename $3)
sans_extension="${filename2%.*}"

echo [*] Copy Files to tmp for building
mkdir -p /tmp/MemoryModule/build/

if test -f ./MemoryModule/build${arch}/CMakeCache.txt ; then
    make -s -C MemoryModule/build${arch} MemoryModule
fi

rsync -r ./MemoryModule/build${arch}/ /tmp/MemoryModule/build/

cp ./MemoryModule/MemoryModule.h /tmp/MemoryModule/

cp $2 /tmp/$sans_extension.go

cd /tmp/

echo [*] Building...

export CXX=${arch}-w64-mingw32-g++
export CC=${arch}-w64-mingw32-gcc
export CGO_ENABLED=1
export GOOS=windows
if test "${arch}" = "x86_64"; then
    export GOARCH=amd64
else
    export GOARCH=386
fi

GO_LDFLAGS="-s"
if [[ $4 == --hidden ]]; then
    go build -ldflags "-H=windowsgui ${GO_LDFLAGS}" $sans_extension.go 
else 
    go build -ldflags "${GO_LDFLAGS}" $sans_extension.go 
fi
echo [*] Building complete

rm -rf /tmp/MemoryModule

cd - 1> /dev/null

echo [*] Copy $3 to output

cp /tmp/$3 ./output/

echo [*] Cleaning up

rm /tmp/$3 
rm /tmp/$sans_extension.go

echo [*] Done
