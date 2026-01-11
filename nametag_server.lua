-- ============================================
-- DEVELOPER NAMETAG SERVER
-- ============================================
local devDiscordIds = {
    ['discord:926572380409712660'] = 'konpep',
    -- Add more dev Discord IDs here if needed
}

local activeDevPlayers = {} -- Track active dev players: activeDevPlayers[serverId] = "name"

-- Get player Discord ID
local function GetPlayerDiscord(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 8) == "discord:" then 
            return id 
        end
    end
    return nil
end

-- Check if player is dev and register them
local function CheckAndRegisterDev(src)
    local discord = GetPlayerDiscord(src)
    
    if discord and devDiscordIds[discord] then
        local devName = devDiscordIds[discord]
        activeDevPlayers[src] = devName
        print('[NameTag] Registered dev player: ' .. devName .. ' (ID: ' .. src .. ')')
        
        -- Broadcast to ALL players that this dev is online
        TriggerClientEvent('wasteland_admin:addDevPlayer', -1, src, devName)
        return true
    end
    return false
end

-- Client requests the current dev players list
RegisterNetEvent('wasteland_admin:requestDevPlayers', function()
    local src = source
    print('[NameTag] Player ' .. src .. ' requested dev players list')
    TriggerClientEvent('wasteland_admin:syncDevPlayers', src, activeDevPlayers)
end)

-- Legacy event (keep for compatibility)
RegisterNetEvent('wasteland_admin:checkDevPlayer', function()
    local src = source
    CheckAndRegisterDev(src)
end)

-- When player fully joins, check if they're a dev
AddEventHandler('playerJoining', function()
    local src = source
    
    -- Wait a bit for identifiers to load
    SetTimeout(3000, function()
        if GetPlayerName(src) then
            CheckAndRegisterDev(src)
        end
    end)
end)

-- When player disconnects, remove from dev list
AddEventHandler('playerDropped', function()
    local src = source
    if activeDevPlayers[src] then
        print('[NameTag] Dev player disconnected: ' .. activeDevPlayers[src])
        activeDevPlayers[src] = nil
        -- Tell all clients to remove this dev player
        TriggerClientEvent('wasteland_admin:removeDevPlayer', -1, src)
    end
end)

-- On resource start, check all online players
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    print('[NameTag] Resource started, checking existing players...')
    
    SetTimeout(5000, function()
        for _, playerId in ipairs(GetPlayers()) do
            local src = tonumber(playerId)
            if src and GetPlayerName(src) then
                CheckAndRegisterDev(src)
            end
        end
        
        -- Sync to all players
        TriggerClientEvent('wasteland_admin:syncDevPlayers', -1, activeDevPlayers)
    end)
end)
