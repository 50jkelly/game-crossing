#!/usr/bin/sh

mkdir build
cp -r src/* build
cp -r toolchain/fasm/INCLUDE/* build
toolchain/fasm/FASM.EXE build/crossing.asm bin/crossing.exe
rm -rf build
