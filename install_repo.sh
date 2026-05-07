#!/bin/bash
set -e

KEYRING="/etc/apt/keyrings/mema.gpg"
LIST="/etc/apt/sources.list.d/mema.list"

if [ "$EUID" -ne 0 ]; then
  echo "Error: Run as root."
  exit 1
fi

mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL "https://raw.githubusercontent.com/eugen252009/mema-core/refs/heads/main/mema.gpg" | gpg --dearmor --yes -o "$KEYRING"
chmod 644 "$KEYRING"

# Add repo
echo "deb [signed-by=$KEYRING]  https://eugen252009.github.io/mema-core/ ./" > "$LIST"
sudo apt update
