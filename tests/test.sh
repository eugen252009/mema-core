#!/bin/bash
set -e

REPO_ROOT=$(pwd)
WEB_REPO="/var/www/html/mema"

echo "--- 🛠️  Step 1: Building Mema Packages ---"
./build.sh

echo "--- 📂 Step 2: Updating Local APT Repository ---"

sudo cp build/*.deb "$WEB_REPO/"
cd "$WEB_REPO"

sudo dpkg-scanpackages --multiversion . /dev/null | gzip -9c > Packages.gz
cd "$REPO_ROOT"

echo "--- 🐳 Step 3: Running Integration Test in Docker ---"

docker run --rm mema-debug bash -c "
    sudo apt update -qq
    echo '--- Installing Go via Mema-APT ---'
    sudo apt install -y mema-go-latest
    
    echo '--- Verification ---'
    if command -v go >/dev/null 2>&1; then
        echo '✅ SUCCESS: Go is installed!'
        go version
    else
        echo '❌ ERROR: Go binary not found in PATH'
        # Debug-Info: Wo ist es gelandet?
        find /opt/mema -name go || echo 'Nothing found in /opt/mema'
        exit 1
    fi
"
