#!/bin/bash
set -e

mkdir -p build
ERROR_COUNT=0

for dir in recipes/*/; do
    [ -d "$dir" ] || continue
    tool=$(basename "$dir")
    [ "$tool" = "debian" ] && continue
    
    echo "--- Processing: $tool ---"
    
    # 1. Rezept-Logik laden
    RECIPE_FILE="${dir}recipe.sh"
    if [ ! -f "$RECIPE_FILE" ]; then
        echo "SKIP: No recipe.sh found in $dir"
        continue
    fi
    . "$RECIPE_FILE"

    RECIPE_TEMPLATE="${dir}template_base.sh"
    if [ ! -f "$RECIPE_TEMPLATE" ]; then
        echo "  [SKIP] No template_base.sh found in $dir"
        continue
    fi

	while read -r VERSION ARCH HASH URL; do
        [ -z "$VERSION" ] && continue
        
        if [[ "$VERSION" =~ ^[a-zA-Z] ]]; then
            SAFE_VERSION="$(date +%Y%m%d)-${VERSION}"
        else
            SAFE_VERSION="$VERSION"
        fi
        
        if [[ "$VERSION" =~ ^[a-zA-Z] ]]; then
            SAFE_VERSION="$(date +%Y%m%d)-${VERSION}"
        else
            SAFE_VERSION="$VERSION"
        fi
        
        case "$ARCH" in
            x86_64)  DEB_ARCH="amd64" ;;
            aarch64) DEB_ARCH="arm64" ;;
			riscv64) DEB_ARCH="riscv64" ;; 
            *) continue ;;
        esac

		DEB_NAME="build/mema-${tool}_${SAFE_VERSION}_${DEB_ARCH}.deb"
        
        if [ -f "$DEB_NAME" ]; then
            echo "  [SKIP] $DEB_NAME already exists."
            continue
        fi

        STAGING="build/staging_${tool}_${VERSION}_${DEB_ARCH}"
        rm -rf "$STAGING"
        mkdir -p "$STAGING/DEBIAN"
        mkdir -p "$STAGING/etc/mema/recipes/$tool"

        sed -e "s|{{NAME}}|$tool|g" \
            -e "s|{{VERSION}}|$VERSION|g" \
            -e "s|{{HASH}}|$HASH|g" \
            -e "s|{{URL}}|$URL|g" \
            "$RECIPE_TEMPLATE" > "$STAGING/etc/mema/recipes/$tool/$tool-$VERSION.sh"

        cat <<EOF > "$STAGING/DEBIAN/control"
Package: mema-$tool
Version: $SAFE_VERSION
Section: utils
Priority: optional
Architecture: $DEB_ARCH
Maintainer: Eugen Lupricht <mema@lupricht.net>
Depends: lupricht-mema, curl, tar, ca-certificates
Homepage: https://github.com/eugen252009/mema-recipes
Description: Auto-generated Mema recipe for $tool.
 This package automates the installation of $tool ($VERSION) 
 into the Mema ecosystem (/opt/mema).
EOF

        DEB_NAME="build/mema-${tool}_${SAFE_VERSION}_${DEB_ARCH}.deb"
        if dpkg-deb --build "$STAGING" "$DEB_NAME" > /dev/null; then
            echo "  [SUCCESS] $DEB_NAME"
        else
            echo "  [ERROR] Failed to build $DEB_NAME"
            ERROR_COUNT=$((ERROR_COUNT + 1))
        fi
        
        rm -rf "$STAGING"

    done < <(mema_get_build_matrix)
done

echo "---------------------------------------"
if [ $ERROR_COUNT -eq 0 ]; then
    echo "Done. All packages built successfully."
    exit 0
else
    echo "Build finished with $ERROR_COUNT errors."
    exit 1
fi
