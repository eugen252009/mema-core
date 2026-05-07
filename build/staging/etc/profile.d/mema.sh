# /etc/profile.d/mema.sh
# Mema environment loader

if [[ ":$PATH:" != *":/usr/bin:"* ]]; then
    export PATH="$PATH:/usr/bin"
fi
export MEMA_RECIPES_PATH="/etc/mema/recipes"
