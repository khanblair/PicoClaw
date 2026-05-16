#!/bin/bash

# PicoClaw One-Click Setup Script
# Optimized for Android (Termux)
# Pre-integrated with DeepSeek

# 1. Termux Side Setup
if [ ! -f "/etc/debian_version" ]; then
    echo "--- Phase 1: Termux Environment Setup ---"
    pkg update && pkg upgrade -y
    pkg install proot-distro git curl -y
    
    if ! proot-distro list | grep -q "ubuntu.*installed"; then
        echo "Installing Ubuntu via proot-distro..."
        proot-distro install ubuntu
    fi
    
    echo "--- Transitioning to Ubuntu Phase ---"
    # Execute this script inside Ubuntu
    proot-distro login ubuntu -- bash -c "$(cat $0)"
    exit 0
fi

# 2. Ubuntu Side Setup
echo "--- Phase 2: Ubuntu Environment Setup ---"
apt update && apt upgrade -y
apt install wget tar nano ca-certificates curl -y

# 3. PicoClaw Installation
echo "Downloading PicoClaw v0.2.2 (ARM64)..."
wget -O picoclaw.tar.gz https://github.com/sipeed/picoclaw/releases/download/v0.2.2/picoclaw_Linux_arm64.tar.gz
tar -xzvf picoclaw.tar.gz
chmod +x picoclaw
mv picoclaw /usr/local/bin/

# 4. Configuration Generation
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
      "model": "deepseek-pro"
    }
  },
  "model_list": [
    {
      "model_name": "deepseek-pro",
      "model": "deepseek/deepseek-chat", 
      "api_base": "https://api.deepseek.com/v1",
      "api_key": "$API_KEY"
    },
    {
      "model_name": "deepseek-flash",
      "model": "deepseek/deepseek-chat", 
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
