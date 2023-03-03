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

function NOTE() {
	printf "[NOTE] $1\n"
}

if [[ ! -z "${1+x}" && "$1" == "clean" ]]; then
	NOTE "Cleaning..."
	rm -rf ./$BUILD_DIR love-* *.zip
	exit 1
fi

need wget
need zip
need unzip

if [[ ! -d ./$BUILD_DIR ]]; then
	mkdir -p ./$BUILD_DIR
fi

# UNIX
NOTE "Building for UNIX-like systems..."
zip -9 -r ./$NAME.love ./README.md ./LICENSE ./*.lua ./*.otf ./*.png ./*.ogg
chmod +x ./$NAME.love
mv ./$NAME.love ./$BUILD_DIR
NOTE "Done!"

# Windows
printf "[NOTE] Building for Windows...\n"
if [[ ! -d ./love-11.4-win64 ]]; then
	printf "\t"
	NOTE "Downloading and unpacking love2d-11.4-win64"
	wget https://github.com/love2d/love/releases/download/11.4/love-11.4-win64.zip
	unzip ./love-11.4-win64.zip
	rm love-11.4-win64.zip*
	printf "\t"
	NOTE "Done!"
fi
cat ./love-11.4-win64/love.exe ./$BUILD_DIR/$NAME.love > ./$NAME.exe
cp  ./love-11.4-win64/*.dll ./$BUILD_DIR/
chmod +x ./$NAME.exe # idk why
mv ./$NAME.exe ./$BUILD_DIR
NOTE "Done!"

# Zip-it
NOTE "Making archive..."
cd ./build
zip -9 -r ../$NAME.zip .
cd ..
NOTE "Done!"

printf "Build successful!\n"

# vim:set noet sw=4 ts=4 ft=zsh:
