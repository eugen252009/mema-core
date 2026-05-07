#!/bin/bash
set -e

rm -rf dist build/staging/dist
mkdir -p dist

./scripts/package.sh 

echo "--- Building Recipes ---"

cd recipes
./build_pkgs.sh

cp build/*.deb ../dist/
cd ..

echo "--- Generating APT Index ---"
cd dist
dpkg-scanpackages . /dev/null > Packages
gzip -k -f Packages

apt-ftparchive release . > Release
cd ..

gpg --batch --yes --clearsign --digest-algo SHA256 -o InRelease Release
gpg --batch --yes --armor --detach-sign --digest-algo SHA256 -o Release.gpg Release

echo "✅ Done!:"
ls -F dist/
