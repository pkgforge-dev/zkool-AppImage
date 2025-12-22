#!/bin/sh

set -eu

ARCH=$(uname -m)
DEB_LINK=$(
	wget https://api.github.com/repos/hhanh00/zkool2/releases -O - \
	  | sed 's/[()",{} ]/\n/g' | grep -o -m 1 "https.*$ARCH.deb"
)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

echo "Getting app..."
echo "---------------------------------------------------------------"
if ! wget --retry-connrefused --tries=30 "$DEB_LINK" -O /tmp/app.deb 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi
ar xvf /tmp/app.deb
tar -xvf ./data.tar.zst
rm -f ./*.zst ./*.deb
mv -v ./usr ./AppDir

cp -v ./AppDir/share/applications/zkool.desktop            ./AppDir
cp -v ./AppDir/share/icons/hicolor/256x256/apps/zkool.png  ./AppDir
cp -v ./AppDir/share/icons/hicolor/256x256/apps/zkool.png  ./AppDir/.DirIcon
mv -v ./AppDir/share/zkool                                 ./AppDir/bin

mkdir -p ./AppDir/shared
mv -v ./AppDir/bin/lib  ./AppDir/shared
ln -s ../shared/lib     ./AppDir/bin/lib
