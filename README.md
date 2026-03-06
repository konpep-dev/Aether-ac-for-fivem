<div align="center">

# 🛡️ AETHER ANTICHEAT

<img src="images/logo.png" alt="Aether Logo" width="150"/>

### Advanced Protection System for FiveM

[![Version](https://img.shields.io/badge/Version-4.5.0-7289DA?style=for-the-badge)](https://github.com/konpep-dev/Aether-ac-for-fivem)
[![FiveM](https://img.shields.io/badge/FiveM-Ready-F97316?style=for-the-badge)](https://fivem.net)
[![Discord](https://img.shields.io/badge/Discord-Join-5865F2?style=for-the-badge)](https://discord.gg/your-server)
[![Protected](https://img.shields.io/badge/Protected-Anti--Tamper-FF0000?style=for-the-badge)](https://github.com/konpep-dev/Aether-ac-for-fivem)

<br/>

<img src="images/banner.png" alt="Banner" width="800"/>

<br/>

**🔒 Protect your server from cheaters with advanced detection systems**

**Coded by konpep**

<br/>

[📖 Documentation](#-documentation) • [⚡ Quick Start](#-quick-start) • [🆕 What's New](#-whats-new-v45) • [📸 Screenshots](#-screenshots) • [🔌 Developer API](#-developer-api)

---

</div>

<br/>

## 🆕 What's New (v4.5)

### 🔐 Anti-Tamper Protection
- **Obfuscated protection system** - Cannot be bypassed or removed
- **Author verification** - Ensures credits remain intact
- **File integrity checks** - Detects tampering attempts
- **Automatic blocking** - Blocks all connections if tampered

### 🌍 Anti-VPN System
- **VPN/Proxy detection** - Blocks VPN and proxy connections
- **Country blacklist** - Block specific countries/regions
- **IP caching** - Saves API requests (7-day cache)
- **Beautiful cards** - Professional connection denial screens
- **Webhook notifications** - Get notified of blocked connections

### 🔄 Auto-Update System
- **GitHub integration** - Checks for updates automatically
- **Version comparison** - Smart version checking
- **Admin notifications** - In-game update alerts
- **Config backup** - Preserves your settings during updates
- **Commands**: `/checkupdate`, `/update`

### 📊 Player Info System
- **Detailed player info** - View all player data with `/info [id]`
- **Screenshot viewer** - Browse player screenshots with arrow keys
- **Connection history** - Track player connections and bans
- **Beautiful UI** - Native Lua UI with modern design
- **Admin only** - Secure access control

### 🎨 AC Info Command
- **`/ac info`** - Beautiful info card showing AC details
- **Version display** - Shows current version (4.5)
- **Feature list** - All protection features listed
- **Minimal design** - Clean and professional UI
- **Press C** - View screenshots in player info

### 🛡️ Enhanced Anticheat
- **Global Ban System** - External protected banlist integration
- **Anti-Bypass System** - Advanced identifier tracking (Tokens, Discord, HWID)
- **Fix debug logs** - Hidden anticheat debug logs from F8 console
- **Blacklisted plates** - Detects cheat signature plates
- **Illegal vehicle mods** - Blocks modifications outside mechanic shops
- **Debug mode** - Toggle debug messages with `Config.Debug`
- **Better detection** - Improved godmode, noclip, teleport detection

<br/>

## 📸 Screenshots

<div align="center">

### 🚫 Ban Card

<img src="images/ban_card.png" alt="Ban Card" width="500"/>

<sub>Beautiful ban screen with screenshot evidence, ban details, and Discord appeal</sub>

<br/><br/>

### 👨‍💼 Admin Panel

<img src="images/admin_panel.png" alt="Admin Panel" width="600"/>

<sub>Full-featured admin panel with player management, vehicles, and more</sub>

<br/><br/>

### 📢 Discord Logs

<img src="images/discord.png" alt="Discord Log" width="400"/>

<sub>All bans logged to Discord with screenshot attachment</sub>

</div>

<br/>

---

<br/>

## 🌟 Why Aether?

<table>
<tr>
<td width="50%">

### 🎯 Accurate Detection
Advanced algorithms that detect cheaters while minimizing false positives. Ragdoll protection, spawn protection, and safezone support built-in.

</td>
<td width="50%">

### ⚡ Instant Response
Real-time detection with configurable instant bans. Screenshot evidence captured automatically before ban.

</td>
</tr>
<tr>
<td width="50%">

### 📸 Evidence System
Every ban includes a screenshot. Evidence is stored in database and sent to Discord automatically.

</td>
<td width="50%">

### 🎨 Beautiful Ban Card
Players see a professional ban screen with their screenshot, reason, and appeal information.

</td>
</tr>
</table>

<br/>

---

<br/>

## 🎮 Features

### 🛡️ Anticheat Detections

| Detection | Description | Configurable |
|-----------|-------------|:------------:|
| 🚀 **Anti-Noclip v3.0** | Wall passing, floating, flying detection | ✅ |
| 🛡️ **Anti-Godmode** | Invincibility, super health/armor | ✅ |
| ⚡ **Anti-Teleport** | Instant position changes | ✅ |
| 🎯 **Anti-Aimbot** | Silent aim, bone lock, aim snap | ✅ |
| 📹 **Anti-Freecam** | Camera manipulation | ✅ |
| 🚗 **Vehicle Blacklist** | Tanks, jets, oppressors | ✅ |
| 🔫 **Weapon Blacklist** | Railgun, alien weapons | ✅ |
| 💓 **Heartbeat System** | Disabled anticheat detection | ✅ |
| 📦 **Anti-Resource Stop** | Prevents stopping server resources | ✅ |
| 🚨 **Anti-Spam System** | Vehicle/Prop/Ped spam detection | ✅ |
| 🧱 **Anti-Prop** | Whitelist-based prop protection | ✅ |

<br/>

### 🚨 Advanced Spam Detection System

Aether includes an intelligent spam detection system that monitors entity spawning patterns:

| Entity Type | Detection Features | Action |
|-------------|-------------------|--------|
| 🚗 **Vehicles** | Short/medium/long window tracking, same model detection, cluster analysis | Ban/Kick |
| 🧱 **Props** | Whitelist enforcement, spam pattern detection, cluster analysis | Ban/Kick |
| 👤 **Peds** | Spawn rate monitoring, model tracking, cluster detection | Ban/Kick |

**How it works:**
- Tracks entity spawns in multiple time windows (5s, 15s, 30s)
- Detects same model spam (e.g., 10x same vehicle)
- Analyzes spatial clustering (entities spawned close together)
- Ignores ambient traffic and server-spawned entities
- Respects safe mode and admin permissions

**Prop Protection:**
- Only whitelisted props can be spawned
- Illegal props are instantly deleted
- Player is banned immediately for spawning illegal props
- Configure whitelist in `Config.WhitelistedProps`

<br/>

### 👨‍💼 Admin Panel Features

| Feature | Description |
|---------|-------------|
| 🎮 **Player Management** | Kick, Ban, Freeze, Teleport, Bring, Spectate |
| 🚗 **Vehicle System** | Spawn, Delete, Repair with categories |
| 🔫 **Weapons** | Give weapons to players |
| 📦 **Inventory** | View player inventory (ESX/OX) |
| 🌤️ **World Control** | Weather, Time, Announcements |
| 📸 **Screenshots** | Take player screenshots |

<br/>

---

<br/>

## 🔌 Developer API

<div align="center">

### ⚠️ IMPORTANT FOR SCRIPT DEVELOPERS

**Aether Anticheat v4.0 includes AUTO-INTEGRATION and EXPORTS to prevent false bans!**

</div>

<br/>

### 🎯 Auto-Integration (NEW!)

**No manual setup needed!** Aether automatically integrates with popular scripts:

| Script | Auto-Detected | Safe Mode Duration |
|--------|:-------------:|:------------------:|
| qb-multicharacter | ✅ | 5 seconds |
| qbx_multicharacter | ✅ | 5 seconds |
| esx_multicharacter | ✅ | 5 seconds |
| qb-spawn | ✅ | 3 seconds |
| qbx_spawn | ✅ | 3 seconds |
| qb-ambulancejob | ✅ | 3 seconds |
| esx_ambulancejob | ✅ | 3 seconds |

**How it works:**
- Aether listens to common events (character selection, spawn, revive)
- Automatically enables "Safe Mode" for players
- Disables anticheat checks temporarily
- Re-enables after the action completes

**No configuration needed - it just works!** 🎉

<br/>

### 🔧 Manual Integration (For Custom Scripts)

If you have a custom script, use these exports:

#### Server-Side Exports

```lua
-- Enable Safe Mode for a player
exports['aether-anticheat']:SetPlayerSafeMode(source, true)

-- Your code here (spawn, teleport, etc)
-- Player won't get banned during this time

-- Disable Safe Mode after 5 seconds
SetTimeout(5000, function()
    exports['aether-anticheat']:SetPlayerSafeMode(source, false)
end)
```

#### Check if Player is in Safe Mode

```lua
local isSafe = exports['aether-anticheat']:IsPlayerInSafeMode(source)
if isSafe then
    print('Player is protected from anticheat')
end
```

#### Add Custom Auto-Integration

```lua
-- Add your own script to auto-integration
exports['aether-anticheat']:AddAutoIntegration(
    'my-custom-script',           -- Resource name
    'my-script:spawnPlayer',      -- Event name
    5000                          -- Duration in ms
)
```

<br/>

### 📋 Quick Reference (Legacy Events)

| Action | Event | Duration |
|--------|-------|----------|
| Heal Player | `anticheat:adminActionProtection` | 5000ms |
| Revive Player | `anticheat:adminActionProtection` | 10000ms |
| Teleport Player | `anticheat:adminActionProtection` | 5000ms |
| Give Godmode | `anticheat:adminActionProtection` | 30000ms |
| Player Spawn | `anticheat:setSpawnProtection` | 15000ms |
| Enter Safezone | `SetSafezoneProtection` export | Until exit |

<br/>

### 🏥 Example: Custom Spawn Script

```lua
-- SERVER SIDE
RegisterNetEvent('myspawn:selectSpawn', function(spawnId)
    local src = source
    
    -- Method 1: Use Safe Mode (RECOMMENDED)
    exports['aether-anticheat']:SetPlayerSafeMode(src, true)
    
    -- Spawn player
    local coords = GetSpawnCoords(spawnId)
    SetEntityCoords(GetPlayerPed(src), coords.x, coords.y, coords.z)
    SetEntityHealth(GetPlayerPed(src), 200)
    
    -- Disable Safe Mode after 5 seconds
    SetTimeout(5000, function()
        exports['aether-anticheat']:SetPlayerSafeMode(src, false)
    end)
end)
```

<br/>

### ⚡ Example: Custom Teleport Script

```lua
-- SERVER SIDE
RegisterCommand('tpto', function(source, args)
    local src = source
    local targetId = tonumber(args[1])
    
    if not targetId then return end
    
    -- Enable Safe Mode
    exports['aether-anticheat']:SetPlayerSafeMode(src, true)
    
    -- Teleport
    local targetPed = GetPlayerPed(targetId)
    local targetCoords = GetEntityCoords(targetPed)
    SetEntityCoords(GetPlayerPed(src), targetCoords.x, targetCoords.y, targetCoords.z)
    
    -- Disable after 3 seconds
    SetTimeout(3000, function()
        exports['aether-anticheat']:SetPlayerSafeMode(src, false)
    end)
end)
```

<br/>

### 🏰 Example: Safezone Script

```lua
-- CLIENT SIDE
-- Entering safezone
AddEventHandler('safezone:enter', function(zoneName)
    exports['aether-anticheat']:SetSafezoneProtection(true, zoneName)
    SetPlayerInvincible(PlayerId(), true)
end)

-- Leaving safezone
AddEventHandler('safezone:exit', function()
    exports['aether-anticheat']:SetSafezoneProtection(false)
    SetPlayerInvincible(PlayerId(), false)
end)
```

<br/>

### 📝 All Available Exports

| Export | Parameters | Side | Description |
|--------|------------|------|-------------|
| `SetPlayerSafeMode` | `source, enabled` | Server | Enable/disable anticheat for player |
| `IsPlayerInSafeMode` | `source` | Server | Check if player is protected |
| `AddAutoIntegration` | `resource, event, duration` | Server | Add custom auto-integration |
| `SetSafezoneProtection` | `enabled, zoneName` | Client | Safezone protection |

<br/>

<details>
<summary><b>💡 More Examples (Click to expand)</b></summary>

### Hospital Script
```lua
RegisterNetEvent('hospital:heal', function(targetId)
    exports['aether-anticheat']:SetPlayerSafeMode(targetId, true)
    Wait(100)
    SetEntityHealth(GetPlayerPed(targetId), 200)
    SetTimeout(5000, function()
        exports['aether-anticheat']:SetPlayerSafeMode(targetId, false)
    end)
end)
```

### Admin Godmode
```lua
RegisterNetEvent('admin:godmode', function(targetId)
    exports['aether-anticheat']:SetPlayerSafeMode(targetId, true)
    Wait(100)
    SetPlayerInvincible(targetId, true)
    -- Keep safe mode enabled while godmode is active
end)
```

### Character Creation
```lua
RegisterNetEvent('character:create', function()
    local src = source
    exports['aether-anticheat']:SetPlayerSafeMode(src, true)
    
    -- Character creation code...
    
    -- Disable after character is created and spawned
    SetTimeout(10000, function()
        exports['aether-anticheat']:SetPlayerSafeMode(src, false)
    end)
end)
```

</details>

<br/>

### 📖 Full Integration Guide

For detailed integration examples, see **[INTEGRATION.md](INTEGRATION.md)**

<br/>

---

<br/>

## ⚡ Quick Start

### 1️⃣ Requirements

```
✅ FiveM Server (latest)
✅ oxmysql
✅ screenshot-basic (optional)
✅ Python 3.8+ (optional - for Discord screenshots)
✅ QBCore / QBX / ESX (optional - auto-detected)
```

### 2️⃣ Installation

```bash
# Import database
mysql -u root -p your_database < data/schema.sql

# Add to server.cfg
ensure oxmysql
ensure screenshot-basic  # optional
ensure aether-anticheat
```

### 3️⃣ Configuration

```lua
-- config.lua

-- Framework (auto-detects QBCore, QBX, ESX, or runs standalone)
Config.Framework = 'auto'  -- Options: 'auto', 'qb', 'qbx', 'esx', 'standalone'

-- Discord Webhooks
Config.Webhooks = {
    anticheat = 'https://discord.com/api/webhooks/...',
}

-- Admins
Config.Admins = {
    ['license:xxxxxxxx'] = 'superadmin',
}

Config.DiscordInvite = 'https://discord.gg/your-server'
```

### 🔧 Framework Support (NEW!)

**Aether v4.0 includes `framework.lua` for automatic framework detection!**

The system automatically detects and supports:
- **QBCore** (`qb-core`) - Full integration
- **QBX** (`qbx_core`) - Full integration  
- **ESX** (`es_extended`) - Full integration
- **Standalone** - Works without any framework

**Framework Features:**
- ✅ Auto-detection on startup (no manual configuration needed)
- ✅ Player management (get player, identifier, job, money)
- ✅ Inventory system (add/remove items, ox_inventory support)
- ✅ Notifications (framework-specific or fallback to chat)
- ✅ Revive system (uses framework ambulance scripts)
- ✅ Safe mode tracking (prevents false bans during character selection)

**Supported Frameworks:**
```lua
Config.Framework = 'auto'  -- Options: 'auto', 'qb', 'qbx', 'esx', 'standalone'
```

The framework is automatically detected when set to `'auto'`. All admin panel features adapt to your framework automatically!

<br/>

---

<br/>

## 📖 Documentation

<details>
<summary><b>🔧 Anticheat Configuration</b></summary>

```lua
Config.Anticheat = {
    enabled = true,
    
    violations = {
        noclip = 1,      -- 1 = instant ban
        godmode = 1,
        teleport = 2,    -- 2 violations needed
    },
    
    detections = {
        noclip = true,
        godmode = true,
        teleport = true,
    },
}
```

</details>

<details>
<summary><b>🚗 Vehicle Blacklist</b></summary>

```lua
Config.BlacklistedVehicles = {
    'rhino', 'khanjali', 'apc',
    'lazer', 'hydra', 'hunter',
    'oppressor', 'oppressor2', 'deluxo',
}
```

</details>

<details>
<summary><b>🔫 Weapon Blacklist</b></summary>

```lua
Config.BlacklistedWeapons = {
    'WEAPON_RAILGUN',
    'WEAPON_RAYPISTOL',
    'WEAPON_RAYCARBINE',
}
```

</details>

<br/>

---

<br/>

## 📁 Project Structure

```
wasteland_admin/
├── 📄 fxmanifest.lua
├── 📄 config.lua
├── 📄 client.lua
├── �  server.lua
├── 📄 nametag.lua
├── 📄 nametag_server.lua
├── 📁 anticheat/
│   ├── 📄 client.lua
│   └── 📄 server.lua
├── � api/s
│   ├── 📄 discord_screenshots.py
│   ├── � requirerments.txt
│   └── � start__api.bat
├── 📁 data/
│   └── 📄 schema.sql
├── 📁 images/
│   ├── 🖼️ ban_card.png
│   ├── 🖼️ admin_panel.png
│   └── 🖼️ discord.png
└── 📁 web/
    ├── 📄 index.html
    ├── 📄 package.json
    ├── 📄 vite.config.ts
    ├── 📁 ban/
    │   └── 📄 index.html
    └── 📁 src/
        ├── 📄 App.tsx
        ├── 📄 main.tsx
        ├── 📄 styles.css
        └── 📄 types.ts
```

<br/>

---

<br/>

<div align="center">

## 🆘 Support

**Discord:** 𝓴𝓸𝓷𝓹𝓮𝓹ᵗᵐ
**ID:** `926572380409712660`

<br/>

---

<br/>

## 💖 Credits

**Developed by [konpep](https://github.com/konpep-dev)**

<sub>Aether Anticheat v4.0 • Made with ❤️ for FiveM</sub>

</div>


---

## ⚙️ Configuration

### 🔐 Anti-VPN Setup

```lua
Config.AntiVPN = {
    enabled = true,
    apiKey = 'YOUR_PROXYCHECK_IO_API_KEY',  -- Get free key from proxycheck.io
    cacheDuration = 7 * 24 * 60 * 60,  -- Cache IPs for 7 days
    countryBlacklistEnabled = true,
    blacklistedCountries = {
        ['CN'] = true,  -- China
        ['RU'] = true,  -- Russia
        -- Add more country codes as needed
    }
}
```

### 🐛 Debug Mode

```lua
Config.Debug = true  -- Enable debug messages
Config.Debug = false -- Disable debug messages (production)
```

### 🚗 Vehicle Protection

```lua
-- Blacklisted plates (cheat signatures)
Config.BlacklistedPlates = {
    'EULEN',
    'MODDER',
    'CHEATER',
    -- Add more plates
}

-- Mechanic shop locations (where mods are allowed)
Config.MechanicShops = {
    {x = -337.0, y = -136.0, z = 39.0, radius = 30.0},
    -- Add your mechanic shops
}
```

---

## 📝 Commands

### Admin Commands
- `/ac info` - Show anticheat information
- `/info [playerid]` - View detailed player information
- `/checkupdate` - Check for script updates
- `/update` - Show update installation instructions
- `/checkip [ip]` - Check if IP is VPN/Proxy (admins)
- `/clearvpncache` - Clear VPN cache (superadmins)

### Player Info UI
- **Press C** - Toggle screenshot viewer
- **← →** - Navigate between screenshots
- **Enter/ESC** - Close UI

---

## 🔒 Anti-Tamper Protection

This script is protected by an advanced anti-tamper system:

- ✅ **Obfuscated protection** - Cannot be easily bypassed
- ✅ **Author verification** - Ensures credits remain intact
- ✅ **File integrity checks** - Detects tampering attempts
- ✅ **Automatic blocking** - Blocks all connections if tampered

### ⚠️ Important
- **DO NOT** remove author credits
- **DO NOT** delete `anti_tamper.lua`
- **DO NOT** modify the fxmanifest author field
- Doing so will block all server connections

---

## 🔄 Auto-Update

The script automatically checks for updates every 30 minutes:

1. Checks GitHub for new releases
2. Notifies admins in-game
3. Sends Discord webhook notification
4. Use `/update` for installation instructions

### Update Process
1. Your `config.lua` is backed up to `config.lua.bk`
2. Download latest release from GitHub
3. Extract and replace files (keep `config.lua.bk`)
4. Restore your settings from backup
5. Restart the resource

---

## 🛡️ Protection Features

### Detections
- ✅ Godmode (multiple methods)
- ✅ Noclip
- ✅ Teleport
- ✅ Speed hacks
- ✅ Weapon spawning
- ✅ Vehicle spawning
- ✅ Blacklisted plates
- ✅ Illegal vehicle modifications
- ✅ Resource manipulation
- ✅ Executor detection
- ✅ VPN/Proxy connections
- ✅ Blacklisted countries
- ✅ Global Ban list check
- ✅ Advanced identifier tracking

### Protection Systems
- ✅ Spawn protection
- ✅ Ragdoll protection
- ✅ Safezone protection
- ✅ Admin action protection
- ✅ Debug mode for testing
- ✅ Screenshot evidence
- ✅ Discord logging
- ✅ IP caching
- ✅ Anti-tamper
- ✅ Global Ban System
- ✅ Hidden Debug Console

---

## 📞 Support

- **GitHub**: [Issues](https://github.com/konpep-dev/Aether-ac-for-fivem/issues)
- **Discord**: Join our Discord server
- **Documentation**: Check the wiki

---

## 📜 License

This script is protected and copyrighted by **konpep**.

- ✅ Free to use on your FiveM server
- ❌ Do not remove author credits
- ❌ Do not resell or redistribute
- ❌ Do not claim as your own

**Removing credits will activate anti-tamper protection and block all connections.**

---

<div align="center">

### 💖 Made with love by konpep

**If you like this script, give it a ⭐ on GitHub!**

[![GitHub](https://img.shields.io/badge/GitHub-konpep--dev-181717?style=for-the-badge&logo=github)](https://github.com/konpep-dev)

</div>
