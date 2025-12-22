#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DEPLOY_FLUTTER=0 # disable since it was done manually already

# Deploy dependencies
quick-sharun ./AppDir/bin/zkool

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
