#!/bin/bash

# 1. Handle Piped Execution (curl | bash)
# If the script is being piped, save it to a temporary file first
if [[ "$0" == "bash" || "$0" == "sh" || "$0" == "/bin/bash" || "$0" == "/bin/sh" || "$0" == "-bash" ]]; then
    TMP_SCRIPT="$HOME/picoclaw_setup.sh"
    cat > "$TMP_SCRIPT"
    exec bash "$TMP_SCRIPT" "$@"
fi

# 2. Environment Detection (Termux vs Ubuntu)
# Check if we are in Termux (not inside a proot container)
if [ -d "/data/data/com.termux/files/usr" ] && [ -z "$PROOT_DISTRO_NAME" ]; then
    echo "--- Phase 1: Termux Environment Setup ---"
    pkg update && pkg upgrade -y
    pkg install proot-distro git curl -y
    
    # Check if ubuntu is installed via path (more reliable)
    if proot-distro path ubuntu >/dev/null 2>&1; then
        echo "[*] Ubuntu is already installed. Skipping installation."
    else
        echo "[*] Installing Ubuntu via proot-distro..."
        proot-distro install ubuntu
    fi
    
    echo "--- Transitioning to Ubuntu Phase ---"
    # Transition to Ubuntu container
    proot-distro login ubuntu -- bash -c "$(cat "$0")"
    exit 0
fi

# 3. Ubuntu Side Setup
echo "--- Phase 2: Ubuntu Environment Setup ---"
apt update && apt upgrade -y
apt install wget tar nano ca-certificates curl -y

# 4. PicoClaw Installation
echo "Downloading PicoClaw v0.2.2 (ARM64)..."
wget -O picoclaw.tar.gz https://github.com/sipeed/picoclaw/releases/download/v0.2.2/picoclaw_Linux_arm64.tar.gz
tar -xzvf picoclaw.tar.gz
chmod +x picoclaw
mv picoclaw /usr/local/bin/

# 5. Configuration Generation
echo "--- Phase 3: Configuration ---"
mkdir -p ~/.picoclaw

# DeepSeek Integration
API_KEY="sk-f338c08b675a4bb691d4103d931aec0a"
TELEGRAM_TOKEN="8752393344:AAGwiROtQpPbSHiYvMcvZAWfZbcnRM9VKQM"
TELEGRAM_ID="5367731807"

cat <<EOF > ~/.picoclaw/config.json
{
  "agents": {
    "defaults": {
      "workspace": "/root/.picoclaw/workspace",
      "model": "deepseek-v4-pro"
    }
  },
  "model_list": [
    {
      "model_name": "deepseek-v4-pro",
      "model": "deepseek-v4-pro", 
      "api_base": "https://api.deepseek.com/v1",
      "api_key": "$API_KEY"
    },
    {
      "model_name": "deepseek-v4-flash",
      "model": "deepseek-v4-flash", 
      "api_base": "https://api.deepseek.com/v1",
      "api_key": "$API_KEY"
    }
  ],
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "$TELEGRAM_TOKEN",
      "allow_from": [$TELEGRAM_ID]
    }
  }
}
EOF

echo "--- Setup Complete! ---"
echo "PicoClaw is now configured with DeepSeek."
echo "To start your bot, run: picoclaw gateway"
