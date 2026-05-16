# 🦞 PicoClaw Mobile 🦞

PicoClaw is an ultra-lightweight, open-source AI agent framework designed to run on resource-constrained hardware, such as $10 RISC-V boards or old Android phones. It is a Go-native, "bare-metal" alternative to heavyweight frameworks.

This repository is optimized for **One-Click Mobile Deployment** with pre-integrated **DeepSeek** support.

---

## ⚡ Quick Start (Android / Termux)

Run the following command inside Termux to automatically set up the Ubuntu environment, install PicoClaw, and configure DeepSeek:

```bash
curl -sL https://raw.githubusercontent.com/khanblair/PicoClaw/feature/one-click-setup-deepseek/setup.sh | bash
```

### What happens during setup?
1.  **Environment Check**: Installs `proot-distro` and `ubuntu` if not already present.
2.  **Toolchain Setup**: Configures the Ubuntu environment with necessary tools (`wget`, `curl`, etc.).
3.  **PicoClaw Installation**: Fetches the latest ARM64 binary and installs it to `/usr/local/bin`.
4.  **Auto-Configuration**: Generates your `config.json` with **DeepSeek** as the default provider.

---

## 🛠 Manual Configuration

If you prefer to configure PicoClaw manually or use a different model provider, you can edit the configuration file:

```bash
nano ~/.picoclaw/config.json
```

### DeepSeek Configuration (Default)
The automated setup uses the following configuration for DeepSeek:

```json
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
      "api_key": "sk-f338...aec0a"
    },
    {
      "model_name": "deepseek-v4-flash",
      "model": "deepseek-v4-flash", 
      "api_base": "https://api.deepseek.com/v1",
      "api_key": "sk-f338...aec0a"
    }
  ],
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "8752393344:AAGwiROtQpPbSHiYvMcvZAWfZbcnRM9VKQM",
      "allow_from": [5367731807]
    }
  }
}
```

---

## 🚀 Running PicoClaw

Once setup is complete, simply start the gateway to bring your agent online:

```bash
picoclaw gateway
```

For debugging or verbose logs, use:
```bash
picoclaw gateway -d
```

---

## 📂 Project Structure
- `setup.sh`: Automated installation script.
- `index.html`: Interactive web-based deployment guide.
- `config.json`: (Generated) Core configuration for agents and channels.

---

Built with ❤️ for the mobile AI community.
