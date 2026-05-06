#!/bin/bash
set -e

PKG_NAME="lupricht-mema"
STAGING="build/$PKG_NAME"

rm -rf "$STAGING"
mkdir -p "$STAGING/DEBIAN"
mkdir -p "$STAGING/usr/bin"
mkdir -p "$STAGING/etc/mema/recipes"
mkdir -p "$STAGING/etc/profile.d" 

cp templates/debian/control "$STAGING/DEBIAN/"
cp core/mema "$STAGING/usr/bin/"
cp recipes/*.sh "$STAGING/etc/mema/recipes/"
cp configs/mema-loader.sh "$STAGING/etc/profile.d/mema.sh"
cp templates/debian/postinst "$STAGING/DEBIAN/"

chmod 755 "$STAGING/DEBIAN/postinst"
chmod 755 "$STAGING/usr/bin/mema"
chmod 755 "$STAGING/etc/mema/recipes/"*.sh
chmod 644 "$STAGING/DEBIAN/control"
chmod 644 "$STAGING/etc/profile.d/mema.sh"

dpkg-deb --build "$STAGING" "${PKG_NAME}.deb"

echo "Done: ${PKG_NAME}.deb created with global profile loader."
