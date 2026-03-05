fx_version 'cerulean'
game 'gta5'

author 'konpep'
description 'Aether Anticheat v4.5 - Advanced Protection System with Anti-VPN, Auto-Update, Anti-Tamper, and Player Info'
version '4.5.0'

lua54 'yes'

dependencies {
    'oxmysql',
    'ox_lib'
}

-- Optional dependencies (comment out if not using):
-- 'screenshot-basic' - For taking screenshots of players
-- 'ox_inventory' - For viewing player inventories




shared_scripts {
    'config.lua',
    'framework.lua'
}

client_scripts {
    'client.lua',
    'anticheat/client.lua'
}

server_scripts {
    'anti_tamper.lua',  -- MUST BE FIRST - Protection system
    'server.lua',
    'anticheat/server.lua',
    'anticheat/events.lua',
    'anticheat/spam_detection.lua',
    'anticheat/spam_server.lua',
    'auto_integration.lua',  -- Auto-integrate with other scripts
    'auto_update.lua'  -- Auto-update system
}

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/**/*'
}

-- Exports for other scripts to use
server_exports {
    'SetPlayerSafeMode',
    'IsPlayerInSafeMode'
}
