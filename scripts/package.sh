#!/bin/bash
set -e

PKG_NAME="mema" 
STAGING="build/staging"
DIST_DIR="dist"

rm -rf "build" "$DIST_DIR"
mkdir -p "$STAGING/DEBIAN"
mkdir -p "$STAGING/usr/local/bin"
mkdir -p "$STAGING/etc/mema/recipes"
mkdir -p "$STAGING/etc/profile.d" 

cp templates/debian/control "$STAGING/DEBIAN/"
cp core/mema "$STAGING/usr/local/bin/"
cp recipes/*.sh "$STAGING/etc/mema/recipes/"
cp configs/mema-loader.sh "$STAGING/etc/profile.d/mema.sh"

if [ -f templates/debian/postinst ]; then
    cp templates/debian/postinst "$STAGING/DEBIAN/"
    chmod 755 "$STAGING/DEBIAN/postinst"
fi

chmod 755 "$STAGING/usr/local/bin/mema"
chmod 755 "$STAGING/etc/mema/recipes/"*.sh
chmod 644 "$STAGING/DEBIAN/control"
chmod 644 "$STAGING/etc/profile.d/mema.sh"

mkdir -p "$DIST_DIR"
dpkg-deb --build "$STAGING" "$DIST_DIR/${PKG_NAME}.deb"

echo "Done: $DIST_DIR/${PKG_NAME}.deb created."
