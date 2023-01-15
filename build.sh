#!/usr/bin/env bash
set -xe

NAME="MinPapers"
BUILD_DIR="build"

mkdir -p ./$BUILD_DIR

# UNIX
zip -9 -r ./$NAME.love ./README.md ./LICENSE ./*.lua ./*.otf
chmod +x ./$NAME.love
mv ./$NAME.love ./$BUILD_DIR

# Windows
cat ~/thirdparty/love-11.4-win64/love.exe ./$BUILD_DIR/$NAME.love > ./$NAME.exe
cp  ~/thirdparty/love-11.4-win64/*.dll ./$BUILD_DIR/
chmod +x ./$NAME.exe
mv ./$NAME.exe ./$BUILD_DIR

# Zip-it
cd ./$BUILD_DIR
7z a -tzip ../$NAME.zip .
cd ..
