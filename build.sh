#!/usr/bin/env bash
set -eu

NAME="MinPapers"
BUILD_DIR="build"

function need () {
	if [[ ! $(which $1) ]]; then
		printf "$1 is needed to build this project!\n"
		exit 1
	fi
}

need 7z
need wget
need zip
need unzip

if [[ ! -d $BUILD_DIR ]]; then
	mkdir -p ./$BUILD_DIR
fi

# UNIX
zip -9 -r ./$NAME.love ./README.md ./LICENSE ./*.lua ./res/ ./res/* ./lib ./lib/*
chmod +x ./$NAME.love
mv ./$NAME.love ./$BUILD_DIR

## Windows
if [[ ! -d love-11.4-win64 ]]; then
	wget https://github.com/love2d/love/releases/download/11.4/love-11.4-win64.zip
	unzip love-11.4-win64.zip
	rm love-11.4-win64.zip*
fi
cat ./love-11.4-win64/love.exe ./build/$NAME.love > ./$NAME.exe
cp  ./love-11.4-win64/*.dll ./build/
chmod +x ./$NAME.exe # idk why
mv ./$NAME.exe ./build

## Zip-it
cd ./build
7z a -tzip ../$NAME.zip .
cd ..

# Line below is needed for proper syntax highlighting
# vim:set ft=zsh:
