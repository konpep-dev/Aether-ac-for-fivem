-- ============================================
-- SPAM DETECTION - SERVER INTEGRATION
-- Uses central ban system with screenshots
-- ============================================

-- Helper: Get admin group
local function GetAdminGroup(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if Config and Config.Admins and Config.Admins[id] then
            return Config.Admins[id]
        end
    end
    return nil
end

-- Use a helper for creator detection (fallback for older artifacts)
local function GetCreator(entity)
    if not DoesEntityExist(entity) then return 0 end
    
    -- Check population type first (0: Unknown, 6: Script, 7: Mission)
    local popType = GetEntityPopulationType(entity)
    
    -- Try GetEntityCreator (newer artifacts, most accurate)
    local success, creator = pcall(function() return GetEntityCreator(entity) end)
    
    if success and creator and creator ~= 0 then
        return creator
    end
    
    -- Fallback: ONLY use owner if it's a script/mission spawn (PopType 6/7) or Unknown (0)
    -- This prevents ambient NPC traffic (PopType 1-5) from ever being blamed on a player
    if popType == 0 or popType >= 6 then
        return NetworkGetEntityOwner(entity) or 0
    end
    
    return 0
end

-- New IsWhitelisted that respects debug mode
local function IsWhitelisted(src)
    -- This now calls the global function in server.lua that checks debugModePlayers
    if type(IsPlayerWhitelisted) == 'function' then
        return IsPlayerWhitelisted(src)
    end
    
    -- Fallback if server.lua hasn't loaded yet
    local group = GetAdminGroup(src)
    return group and (group == 'superadmin' or group == 'admin')
end

-- Cache for prop whitelist hashes
local propWhitelistHashes = {}
CreateThread(function()
    Wait(1000)
    if Config and Config.WhitelistedProps then
        for _, model in ipairs(Config.WhitelistedProps) do
            propWhitelistHashes[GetHashKey(model)] = true
        end
        print('^5[ANTICHEAT]^7 Loaded ^3' .. #Config.WhitelistedProps .. '^7 whitelisted props.')
    end
end)

local function IsPropWhitelisted(modelHash)
    return propWhitelistHashes[modelHash] == true
end

-- Get config values
local function GetSpamConfig(entityType, key, default)
    if Config and Config.Anticheat and Config.Anticheat.spamDetection then
        local entityConfig = Config.Anticheat.spamDetection[entityType]
        if entityConfig then
            return entityConfig[key] or default
        end
    end
    return default
end

-- Get global spam action
local function GetSpamAction()
    if Config and Config.Anticheat and Config.Anticheat.spamDetection then
        return Config.Anticheat.spamDetection.action or 'ban'
    end
    return 'ban'
end

-- Send webhook
local function SendSpamWebhook(name, src, entityType, severity, reason, stats)
    if not Config or not Config.Webhooks or not Config.Webhooks.anticheat then return end
    
    local color = 16776960 -- Yellow for warning
    if severity >= 8 then
        color = 16711680 -- Red for action
    elseif severity >= 5 then
        color = 16744192 -- Orange for high severity
    end
    
    local statsText = string.format(
        "**Short (5s):** %d\n**Medium (15s):** %d\n**Long (30s):** %d\n**Same Model:** %d%s\n**Clustered:** %s",
        stats.short or 0,
        stats.medium or 0,
        stats.long or 0,
        stats.sameModel or 0,
        stats.model and (" (" .. stats.model .. ")") or "",
        stats.clustered and "Yes" or "No"
    )
    
    PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
        username = '🛡️ Anticheat System',
        embeds = {{
            title = '🚨 ' .. entityType:upper() .. ' SPAM DETECTED',
            description = '**' .. name .. '** is spamming ' .. entityType .. 's!',
            color = color,
            fields = {
                { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                { name = '🆔 Server ID', value = '`' .. src .. '`', inline = true },
                { name = '⚠️ Severity', value = '`' .. severity .. '/10`', inline = true },
                { name = '📊 Statistics', value = statsText, inline = false },
                { name = '📝 Reason', value = '`' .. reason .. '`', inline = false },
            },
            footer = { text = '🛡️ Spam Detection • ' .. os.date('%Y-%m-%d %H:%M:%S') }
        }}
    }), { ['Content-Type'] = 'application/json' })
end

-- Event-based tracking (more accurate)
AddEventHandler('entityCreated', function(entity)
    -- Global switch checks
    if not Config or not Config.Anticheat or not Config.Anticheat.enabled then return end
    if not Config.Anticheat.spamDetection or not Config.Anticheat.spamDetection.enabled then return end
    
    -- Wait a bit for the entity to be fully registered and creator assigned
    -- This helps avoid race conditions where creator is not yet linked
    Wait(200)
    
    if not DoesEntityExist(entity) then return end
    
    local entityType = GetEntityType(entity)
    if entityType == 0 then return end -- Not a valid type
    
    -- CRITICAL: Check population type to ignore ambient traffic/peds
    -- 0: Unknown, 1-5: Ambient/Scenario (NPCs), 6: Script, 7: Mission
    -- Cheats almost always show up as 6 (Script)
    local popType = GetEntityPopulationType(entity)
    if popType > 0 and popType < 6 then 
        return 
    end
    
    -- Get creator - MUCH more accurate than owner
    -- GetCreator is our helper that falls back to NetworkGetEntityOwner if native is missing
    local creator = GetCreator(entity)
    
    -- If creator is 0, it was spawned by a server script. Ignore it.
    if creator == 0 then return end
    
    -- Check if creator is still connected
    if not GetPlayerName(creator) then return end
    
    -- Skip whitelisted players and players in safe mode
    -- IsPlayerWhitelisted respects Debug Mode (allows catching admins)
    -- IsPlayerInSafeMode (global) checks if player is in character selection/loading
    if IsWhitelisted(creator) or IsPlayerInSafeMode(creator) then 
        return 
    end
    
    local model = GetEntityModel(entity)
    local modelName = tostring(model)
    local entityTypeName = nil
    
    if entityType == 2 then -- Vehicle
        if not GetSpamConfig('vehicles', 'enabled', true) then return end
        
        entityTypeName = 'vehicle'
        TrackEntitySpawn(creator, 'vehicle', entity, modelName)
        
        local severity, reason, stats = CheckEntitySpam(creator, 'vehicle')
        if severity >= 5 then
            local name = GetPlayerName(creator) or 'Unknown'
            local actionSeverity = GetSpamConfig('vehicles', 'actionSeverity', 8)
            local warnSeverity = GetSpamConfig('vehicles', 'warnSeverity', 6)
            
            SendSpamWebhook(name, creator, 'vehicle', severity, reason, stats)
            
            if severity >= actionSeverity then
                local action = GetSpamAction()
                local actionReason = 'Vehicle spam: ' .. reason
                
                if action == 'ban' then
                    print('^1[ANTICHEAT] BANNING ' .. name .. ' (' .. creator .. ') - ' .. actionReason .. '^0')
                    -- Delete the spammed vehicles before banning
                    CleanupSpammedEntities(creator, 'vehicle')
                    BanPlayer(creator, actionReason, nil, 'vehicle_spam')
                else
                    print('^1[ANTICHEAT] KICKING ' .. name .. ' (' .. creator .. ') - ' .. actionReason .. '^0')
                    CleanupSpammedEntities(creator, 'vehicle')
                    DropPlayer(creator, '🚨 KICKED: ' .. actionReason)
                end
            elseif severity >= warnSeverity then
                TriggerClientEvent('chat:addMessage', creator, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[ANTICHEAT]", "⚠️ WARNING: Stop spawning vehicles!"}
                })
            end
        end
        
    elseif entityType == 3 then -- Object/Prop
        if not GetSpamConfig('props', 'enabled', true) then return end
        
        -- AGGRESSIVE PROP PROTECTION: Check if prop is whitelisted
        if not IsPropWhitelisted(model) then
            local name = GetPlayerName(creator) or 'Unknown'
            print('^1[ANTICHEAT] ILLEGAL PROP DETECTED: ' .. modelName .. ' spawned by ' .. name .. '^0')
            
            -- Delete it immediately
            if DoesEntityExist(entity) then
                DeleteEntity(entity)
            end
            
            -- Log and Punish
            local reason = 'Illegal Prop Spawn: ' .. modelName
            BanPlayer(creator, reason, nil, 'illegal_prop')
            return
        end
        
        entityTypeName = 'prop'
        TrackEntitySpawn(creator, 'prop', entity, modelName)
        
        local severity, reason, stats = CheckEntitySpam(creator, 'prop')
        if severity >= 5 then
            local name = GetPlayerName(creator) or 'Unknown'
            local actionSeverity = GetSpamConfig('props', 'actionSeverity', 8)
            local warnSeverity = GetSpamConfig('props', 'warnSeverity', 6)
            
            SendSpamWebhook(name, creator, 'prop', severity, reason, stats)
            
            if severity >= actionSeverity then
                local action = GetSpamAction()
                local actionReason = 'Prop spam: ' .. reason
                
                if action == 'ban' then
                    print('^1[ANTICHEAT] BANNING ' .. name .. ' (' .. creator .. ') - ' .. actionReason .. '^0')
                    CleanupSpammedEntities(creator, 'prop')
                    BanPlayer(creator, actionReason, nil, 'prop_spam')
                else
                    print('^1[ANTICHEAT] KICKING ' .. name .. ' (' .. creator .. ') - ' .. actionReason .. '^0')
                    CleanupSpammedEntities(creator, 'prop')
                    DropPlayer(creator, '🚨 KICKED: ' .. actionReason)
                end
            elseif severity >= warnSeverity then
                TriggerClientEvent('chat:addMessage', creator, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[ANTICHEAT]", "⚠️ WARNING: Stop spawning props!"}
                })
            end
        end
        
    elseif entityType == 1 then -- Ped
        if not GetSpamConfig('peds', 'enabled', true) then return end
        
        entityTypeName = 'ped'
        TrackEntitySpawn(creator, 'ped', entity, modelName)
        
        local severity, reason, stats = CheckEntitySpam(creator, 'ped')
        if severity >= 5 then
            local name = GetPlayerName(creator) or 'Unknown'
            local actionSeverity = GetSpamConfig('peds', 'actionSeverity', 8)
            local warnSeverity = GetSpamConfig('peds', 'warnSeverity', 6)
            
            SendSpamWebhook(name, creator, 'ped', severity, reason, stats)
            
            if severity >= actionSeverity then
                local action = GetSpamAction()
                local actionReason = 'Ped spam: ' .. reason
                
                if action == 'ban' then
                    print('^1[ANTICHEAT] BANNING ' .. name .. ' (' .. creator .. ') - ' .. actionReason .. '^0')
                    CleanupSpammedEntities(creator, 'ped')
                    BanPlayer(creator, actionReason, nil, 'ped_spam')
                else
                    print('^1[ANTICHEAT] KICKING ' .. name .. ' (' .. creator .. ') - ' .. actionReason .. '^0')
                    CleanupSpammedEntities(creator, 'ped')
                    DropPlayer(creator, '🚨 KICKED: ' .. actionReason)
                end
            elseif severity >= warnSeverity then
                TriggerClientEvent('chat:addMessage', creator, {
                    color = {255, 0, 0},
                    multiline = true,
                    args = {"[ANTICHEAT]", "⚠️ WARNING: Stop spawning peds!"}
                })
            end
        end
    end
end)

-- Startup message
CreateThread(function()
    Wait(10000)
    if Config and Config.Anticheat and Config.Anticheat.spamDetection and Config.Anticheat.spamDetection.enabled then
        local action = GetSpamAction()
        print('^5[ANTICHEAT]^7 Spam Detection System ^2Active^7 (Action: ^3' .. action:upper() .. '^7)')
    end
end)
