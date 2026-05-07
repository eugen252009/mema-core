#!/bin/bash
set -e

KEYRING="/etc/apt/keyrings/mema.gpg"
LIST="/etc/apt/sources.list.d/mema.list"

if [ "$EUID" -ne 0 ]; then
  echo "Error: Run as root."
  exit 1
fi

mkdir -p -m 755 /etc/apt/keyrings

# Install key
if [ -f "./mema.gpg" ]; then
    echo "Using local mema.gpg found in directory..."
    cat "./mema.gpg" | gpg --dearmor --yes -o "$KEYRING"
else
    echo "Local key not found, trying to download..."
    curl -fsSL "https://raw.githubusercontent.com/eugen252009/mema-core/main/mema.gpg" | gpg --dearmor --yes -o "$KEYRING"
fi
chmod 644 "$KEYRING"

# Add repo
# echo "deb [signed-by=$KEYRING] https://eugen252009.github.io/mema-core/repo ./" > "$LIST"
echo "deb [signed-by=$KEYRING] http://192.168.188.49/mema ./" > "$LIST"
echo "Mema repository configured. Run 'apt update' to sync."
sudo apt update
