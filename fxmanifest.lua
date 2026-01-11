fx_version 'cerulean'
game 'gta5'

author 'Wasteland'
description 'Admin Panel with SQL Database'
version '2.0.0'

lua54 'yes'

dependencies {
    'oxmysql',
    'ox_lib'
}

-- Optional dependencies (comment out if not using):
-- 'screenshot-basic' - For taking screenshots of players
-- 'ox_inventory' - For viewing player inventories




shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua',
    'anticheat/client.lua',
    'nametag.lua'
}

server_scripts {
    'server.lua',
    'anticheat/server.lua',
    'nametag_server.lua'
}

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/**/*'
}

