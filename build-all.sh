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

echo "✅ Fertig! dist/ enthält jetzt:"
ls -F dist/
