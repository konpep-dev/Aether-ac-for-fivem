-- ============================================
-- aether ANTICHEAT - SERVER SIDE
-- Anti-Noclip, Anti-Godmode, Anti-Teleport
-- ============================================

-- print('[ANTICHEAT] Loading anticheat/server.lua...')

local playerData = {}
local warnedPlayers = {} -- Track warned players
local debugModePlayers = {} -- Players with debug mode enabled (no whitelist)
local adminProtection = {} -- Track admin actions to prevent false positives

-- print('[ANTICHEAT] anticheat/server.lua loaded successfully!')

-- Load event whitelist
local whitelistedEvents = {}
local eventProtections = {}
local eventsLoaded, eventsModule = pcall(function() return require('anticheat.events') end)
if eventsLoaded and eventsModule then
    whitelistedEvents = eventsModule.events or {}
    eventProtections = eventsModule.protections or {}
    local eventCount = 0
    for _ in pairs(whitelistedEvents) do eventCount = eventCount + 1 end
    DebugLog('Loaded ' .. eventCount .. ' whitelisted events from events.lua')
    local protCount = 0
    for _ in pairs(eventProtections) do protCount = protCount + 1 end
    DebugLog('Loaded ' .. protCount .. ' event protections')
else
    print('[ANTICHEAT] WARNING: Could not load events.lua whitelist')
end

-- ============================================
-- AUTO EVENT PROTECTION SYSTEM
-- Automatically protects players when legitimate events run
-- ============================================

-- Hook into all registered events to auto-enable protection
local originalAddEventHandler = AddEventHandler
AddEventHandler = function(eventName, callback)
    return originalAddEventHandler(eventName, function(...)
        local src = source
        
        -- Check if this event should trigger protections
        local protection = eventProtections[eventName]
        if protection and src and tonumber(src) then
            -- Enable protections for this player
            for _, protType in ipairs(protection.protections) do
                if not adminProtection[src] then
                    adminProtection[src] = {}
                end
                adminProtection[src][protType] = GetGameTimer() + protection.duration
                
                DebugLog('Auto-protection enabled for player ' .. src .. ' (' .. protType .. ') from event: ' .. eventName)
            end
        end
        
        -- Call original callback
        return callback(...)
    end)
end

-- Also hook RegisterNetEvent for client->server events
local originalRegisterNetEvent = RegisterNetEvent
RegisterNetEvent = function(eventName, callback)
    if callback then
        return originalRegisterNetEvent(eventName, function(...)
            local src = source
            
            -- Check if this event should trigger protections
            local protection = eventProtections[eventName]
            if protection and src and tonumber(src) then
                -- Enable protections for this player
                for _, protType in ipairs(protection.protections) do
                    if not adminProtection[src] then
                        adminProtection[src] = {}
                    end
                    adminProtection[src][protType] = GetGameTimer() + protection.duration
                    
                    DebugLog('Auto-protection enabled for player ' .. src .. ' (' .. protType .. ') from event: ' .. eventName)
                end
            end
            
            -- Call original callback
            return callback(...)
        end)
    else
        return originalRegisterNetEvent(eventName)
    end
end

-- Admin Action Protection System
-- When admins use godmode, noclip, etc., we ignore anticheat for a period
RegisterNetEvent('anticheat:adminActionProtection')
AddEventHandler('anticheat:adminActionProtection', function(targetId, actionType, duration)
    local src = source
    
    -- Verify the source is an admin
    local group = GetAdminGroup(src)
    if not group then return end
    
    targetId = tonumber(targetId) or src
    duration = tonumber(duration) or 5000
    
    if not adminProtection[targetId] then
        adminProtection[targetId] = {}
    end
    
    adminProtection[targetId][actionType] = GetGameTimer() + duration
    
    DebugLog('Admin protection enabled for player ' .. targetId .. ' (' .. actionType .. ') for ' .. math.floor(duration/1000) .. 's')
end)

-- Check if player has admin protection for specific action
local function HasAdminProtection(src, actionType)
    if not adminProtection[src] then return false end
    if not adminProtection[src][actionType] then return false end
    
    if GetGameTimer() < adminProtection[src][actionType] then
        return true
    else
        adminProtection[src][actionType] = nil
        return false
    end
end

-- Debug logging (only shows important messages)
local DEBUG_MODE = false -- Set to true for verbose logging
local function DebugLog(message)
    if DEBUG_MODE then
        print('[ANTICHEAT] ' .. message)
    end
end

local function ImportantLog(message)
    print('[ANTICHEAT] ' .. message)
end

-- ============================================
-- CONFIG HELPER FUNCTIONS
-- Read from Config.Anticheat with fallbacks
-- ============================================
local function GetACViolations(detectionType)
    if Config and Config.Anticheat and Config.Anticheat.violations then
        return Config.Anticheat.violations[detectionType] or 1
    end
    return 1
end

local function GetACThreshold(key, default)
    if Config and Config.Anticheat and Config.Anticheat.thresholds then
        return Config.Anticheat.thresholds[key] or default
    end
    return default
end

local function GetACBanDuration(detectionType)
    if Config and Config.Anticheat and Config.Anticheat.banDurations then
        return Config.Anticheat.banDurations[detectionType] or Config.Anticheat.banDurations.default or 1440
    end
    return 1440 -- 24 hours default
end

local function IsDetectionEnabled(detectionType)
    if Config and Config.Anticheat then
        if Config.Anticheat.enabled == false then return false end
        if Config.Anticheat.detections and Config.Anticheat.detections[detectionType] == false then
            return false
        end
    end
    return true
end

-- Legacy config (fallback)
local AC_Config = {
    -- Anti-Teleport
    maxTeleportDistance = 150.0,
    teleportCheckInterval = 1000,
    teleportViolationsBeforeBan = 3,
    
    -- Anti-Godmode
    godmodeCheckInterval = 5000,
    godmodeTestDamage = 5,
    
    -- Anti-Noclip
    noclipCheckInterval = 2000,
    maxVerticalSpeed = 50.0,
    
    -- Punishments
    banDuration = 0, -- 0 = Permanent ban for anticheat violations
    
    -- Whitelist
    whitelistedGroups = {
        ['superadmin'] = true,
        ['admin'] = true,
        ['mod'] = true
    }
}

-- Get admin group (same as main script)
local function GetAdminGroup(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if Config and Config.Admins and Config.Admins[id] then
            return Config.Admins[id]
        end
    end
    return nil
end

-- Global function for other scripts to check whitelist (respects debug mode)
function IsPlayerWhitelisted(src)
    -- If debug mode is enabled for this player, they are NOT whitelisted
    if debugModePlayers[src] then
        return false
    end
    local group = GetAdminGroup(src)
    return group and AC_Config.whitelistedGroups[group]
end

-- Alias for backward compatibility
local function IsWhitelisted(src)
    return IsPlayerWhitelisted(src)
end

local function GetPlayerLicense(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 8) == "license:" then return id end
    end
    return nil
end

local function GetPlayerDiscord(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 8) == "discord:" then return id end
    end
    return nil
end

local function GetPlayerSteam(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 6) == "steam:" then return id end
    end
    return nil
end

-- ============================================
-- SCREENSHOT FUNCTION (using screencapture)
-- Takes screenshot, uploads to fivemanage, sends to Discord with image
-- ============================================

-- IMPORTANT: Set your Fivemanage API token here or in Config
local FIVEMANAGE_TOKEN = Config and Config.FivemanageToken or ''

-- Send screenshot to Python API (for Discord with image)
local function SendToScreenshotAPI(playerName, playerId, reason, eventType, screenshot, identifiers)
    local apiUrl = Config and Config.ScreenshotAPI
    if not apiUrl or apiUrl == '' then return false end
    
    local payload = json.encode({
        player_name = playerName,
        player_id = playerId,
        reason = reason,
        type = eventType, -- 'ban', 'warning', 'screenshot'
        screenshot = screenshot,
        identifiers = identifiers or {}
    })
    
    PerformHttpRequest(apiUrl .. '/screenshot', function(code, response)
        if code == 200 then
            DebugLog('Screenshot sent to API successfully')
        else
            ImportantLog('API error: ' .. tostring(code) .. ' - ' .. tostring(response))
        end
    end, 'POST', payload, { ['Content-Type'] = 'application/json' })
    
    return true
end

-- Try to take screenshot using screenshot-basic
local function TakeScreenshotAndSend(src, reason, detectionType, callback)
    local name = GetPlayerName(src) or 'Unknown'
    local callbackCalled = false
    
    DebugLog('📸 Attempting screenshot for ' .. name .. ' (' .. tostring(detectionType) .. ')')
    
    -- Check if player is still connected
    if not GetPlayerName(src) then
        DebugLog('❌ Player disconnected before screenshot')
        if callback then callback(nil) end
        return
    end
    
    -- Check if screenshot-basic is available
    local resourceState = GetResourceState('screenshot-basic')
    if resourceState ~= 'started' then
        DebugLog('❌ screenshot-basic not running! State: ' .. tostring(resourceState))
        if callback then callback(nil) end
        return
    end
    
    -- Safety: call callback after 5 seconds if screenshot doesn't respond
    SetTimeout(5000, function()
        if not callbackCalled then
            callbackCalled = true
            DebugLog('⏱️ Screenshot timeout after 5 seconds')
            if callback then callback(nil) end
        end
    end)
    
    -- Use screenshot-basic requestClientScreenshot
    local success, err = pcall(function()
        exports['screenshot-basic']:requestClientScreenshot(src, {
            encoding = 'jpg',
            quality = 0.80
        }, function(screenshotErr, data)
            if callbackCalled then 
                DebugLog('Screenshot callback called but already timed out')
                return 
            end
            callbackCalled = true
            
            if screenshotErr then
                DebugLog('❌ Screenshot error: ' .. tostring(screenshotErr))
                if callback then callback(nil) end
                return
            end
            
            if data and #data > 100 then
                DebugLog('✅ Screenshot captured! Size: ' .. #data .. ' bytes')
                if callback then callback(data) end
            else
                DebugLog('❌ Screenshot returned empty/invalid data')
                if callback then callback(nil) end
            end
        end)
    end)
    
    if not success then
        ImportantLog('❌ Screenshot pcall error: ' .. tostring(err))
        if not callbackCalled then
            callbackCalled = true
            if callback then callback(nil) end
        end
    end
end

-- ============================================
-- ADVANCED IDENTIFIER FUNCTIONS (Anti-Spoof)
-- ============================================
local function GetPlayerLicense2(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 9) == "license2:" then return id end
    end
    return nil
end

local function GetPlayerXbl(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 4) == "xbl:" then return id end
    end
    return nil
end

local function GetPlayerLive(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 5) == "live:" then return id end
    end
    return nil
end

local function GetPlayerFivem(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 6) == "fivem:" then return id end
    end
    return nil
end

local function GetPlayerIP(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 3) == "ip:" then return id end
    end
    return nil
end

local function GetPlayerTokens(src)
    local tokens = {}
    local numTokens = GetNumPlayerTokens(src)
    for i = 0, numTokens - 1 do
        local token = GetPlayerToken(src, i)
        if token then
            table.insert(tokens, token)
        end
    end
    return tokens
end

-- ============================================
-- BEAUTIFUL DISCORD WEBHOOK SYSTEM
-- Professional embeds for all anticheat logs
-- ============================================

local WebhookColors = {
    ban = 15158332,        -- Red
    warning = 16776960,    -- Yellow
    detection = 16744192,  -- Orange
    info = 3447003,        -- Blue
    success = 3066993,     -- Green
    critical = 10038562,   -- Dark Red
}

local DetectionIcons = {
    noclip = '🚀',
    godmode = '🛡️',
    teleport = '⚡',
    aimbot = '🎯',
    freecam = '📹',
    speedhack = '💨',
    vehicle = '🚗',
    weapon = '🔫',
    resource = '📦',
    heartbeat = '💓',
    health = '❤️',
    armor = '🛡️',
    default = '⚠️'
}

local function SendAnticheatWebhook(webhookType, title, playerName, playerId, details, extraFields, color)
    local webhook = Config and Config.Webhooks and Config.Webhooks.anticheat
    if not webhook or webhook == '' then return end
    
    local serverName = Config and Config.ServerName or 'Server'
    local timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
    
    -- Build fields
    local fields = {
        {
            name = '👤 Player',
            value = '```' .. (playerName or 'Unknown') .. '```',
            inline = true
        },
        {
            name = '🆔 Server ID',
            value = '```' .. tostring(playerId or 'N/A') .. '```',
            inline = true
        }
    }
    
    -- Add details field
    if details and details ~= '' then
        table.insert(fields, {
            name = '📝 Details',
            value = '```' .. details .. '```',
            inline = false
        })
    end
    
    -- Add extra fields
    if extraFields then
        for _, field in ipairs(extraFields) do
            table.insert(fields, field)
        end
    end
    
    local embed = {
        title = title,
        color = color or WebhookColors.detection,
        fields = fields,
        footer = {
            text = '🛡️ Aether Anticheat • ' .. serverName,
            icon_url = 'https://i.imgur.com/AfFp7pu.png'
        },
        timestamp = timestamp
    }
    
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({
        username = '🛡️ Aether Anticheat',
        avatar_url = 'https://i.imgur.com/AfFp7pu.png',
        embeds = { embed }
    }), { ['Content-Type'] = 'application/json' })
end

-- Specialized webhook for BANS (more detailed)
local function SendBanWebhook(playerName, playerId, reason, detectionType, license, duration)
    local webhook = Config and Config.Webhooks and Config.Webhooks.anticheat
    if not webhook or webhook == '' then return end
    
    local serverName = Config and Config.ServerName or 'Server'
    local timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
    local icon = DetectionIcons[detectionType] or DetectionIcons.default
    
    local durationText = 'PERMANENT'
    if duration and duration > 0 then
        if duration >= 1440 then
            durationText = math.floor(duration / 1440) .. ' days'
        elseif duration >= 60 then
            durationText = math.floor(duration / 60) .. ' hours'
        else
            durationText = duration .. ' minutes'
        end
    end
    
    local embed = {
        title = icon .. ' ANTICHEAT BAN',
        description = '**A player has been banned by the anticheat system**',
        color = WebhookColors.ban,
        thumbnail = {
            url = 'https://i.imgur.com/oBQXYQX.png'
        },
        fields = {
            {
                name = '👤 Player',
                value = '```' .. (playerName or 'Unknown') .. '```',
                inline = true
            },
            {
                name = '🆔 Server ID',
                value = '```' .. tostring(playerId or 'N/A') .. '```',
                inline = true
            },
            {
                name = '🔍 Detection',
                value = '```' .. (detectionType or 'Unknown') .. '```',
                inline = true
            },
            {
                name = '📝 Reason',
                value = '```' .. (reason or 'No reason') .. '```',
                inline = false
            },
            {
                name = '⏱️ Duration',
                value = '```' .. durationText .. '```',
                inline = true
            },
            {
                name = '🔑 License',
                value = '```' .. (license or 'N/A') .. '```',
                inline = true
            }
        },
        footer = {
            text = '🛡️ Aether Anticheat v4.0 • ' .. serverName,
            icon_url = 'https://i.imgur.com/AfFp7pu.png'
        },
        timestamp = timestamp
    }
    
    PerformHttpRequest(webhook, function() end, 'POST', json.encode({
        username = '🛡️ Aether Anticheat',
        avatar_url = 'https://i.imgur.com/AfFp7pu.png',
        embeds = { embed }
    }), { ['Content-Type'] = 'application/json' })
end

-- Warning webhook (yellow, not ban yet)
local function SendWarningWebhook(playerName, playerId, warningType, details)
    local webhook = Config and Config.Webhooks and Config.Webhooks.anticheat
    if not webhook or webhook == '' then return end
    
    local icon = DetectionIcons[warningType] or DetectionIcons.default
    
    SendAnticheatWebhook(
        'warning',
        icon .. ' SUSPICIOUS ACTIVITY',
        playerName,
        playerId,
        details,
        {
            {
                name = '⚠️ Type',
                value = '```' .. (warningType or 'Unknown') .. '```',
                inline = true
            }
        },
        WebhookColors.warning
    )
end

-- Detection webhook (orange, violation detected)
local function SendDetectionWebhook(playerName, playerId, detectionType, details, violations)
    local webhook = Config and Config.Webhooks and Config.Webhooks.anticheat
    if not webhook or webhook == '' then return end
    
    local icon = DetectionIcons[detectionType] or DetectionIcons.default
    
    SendAnticheatWebhook(
        'detection',
        icon .. ' ' .. string.upper(detectionType or 'DETECTION'),
        playerName,
        playerId,
        details,
        {
            {
                name = '🔢 Violations',
                value = '```' .. tostring(violations or 1) .. '```',
                inline = true
            }
        },
        WebhookColors.detection
    )
end

-- ============================================
-- BAN SYSTEM WITH SCREENSHOT
-- Takes screenshot FIRST, then saves ban and drops player
-- ============================================

-- Main ban function - ALWAYS takes screenshot BEFORE dropping
-- Main ban function - ALWAYS takes screenshot BEFORE dropping
function BanPlayer(src, reason, duration, logType)
    local name = GetPlayerName(src) or 'Unknown'
    local license, license2, discord, steam, xbl, live, fivem, ip = nil, nil, nil, nil, nil, nil, nil, nil
    local tokens = {}
    
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 8) == "license:" then 
            license = id 
        elseif string.sub(id, 1, 9) == "license2:" then 
            license2 = id 
        elseif string.sub(id, 1, 8) == "discord:" then 
            discord = id 
        elseif string.sub(id, 1, 6) == "steam:" then 
            steam = id 
        elseif string.sub(id, 1, 4) == "xbl:" then 
            xbl = id 
        elseif string.sub(id, 1, 5) == "live:" then 
            live = id 
        elseif string.sub(id, 1, 6) == "fivem:" then 
            fivem = id 
        elseif string.sub(id, 1, 3) == "ip:" then 
            ip = id 
        end
    end
    
    -- Get tokens
    for i = 0, GetNumPlayerTokens(src) - 1 do
        table.insert(tokens, GetPlayerToken(src, i))
    end
    local tokensStr = table.concat(tokens, ',')
    
    -- Debug: Print collected identifiers
    DebugLog('Ban identifiers: L=' .. tostring(license) .. ' D=' .. tostring(discord) .. ' S=' .. tostring(steam))
    
    if not license then
        ImportantLog('No license found for ban')
        DropPlayer(src, 'Banned: ' .. reason)
        return
    end
    
    local expiry = nil
    if duration and duration > 0 then
        expiry = os.time() + (duration * 60)
    end
    
    ImportantLog('🚨 BANNING ' .. name .. ' - ' .. reason)
    
    -- STEP 1: Take screenshot FIRST (before anything else)
    local screenshotData = nil
    local screenshotState = GetResourceState('screenshot-basic')
    
    DebugLog('Screenshot-basic state: ' .. tostring(screenshotState))
    
    if screenshotState == 'started' and GetPlayerName(src) then
        DebugLog('📸 Taking screenshot for ' .. name .. '...')
        
        local screenshotReceived = false
        
        local success, err = pcall(function()
            exports['screenshot-basic']:requestClientScreenshot(src, {
                encoding = 'jpg',
                quality = 0.85
            }, function(screenshotErr, data)
                screenshotReceived = true
                if screenshotErr then
                    DebugLog('Screenshot error: ' .. tostring(screenshotErr))
                elseif data and #data > 100 then
                    screenshotData = data
                    DebugLog('Screenshot captured! Size: ' .. #data .. ' bytes')
                else
                    DebugLog('Screenshot data invalid or empty')
                end
            end)
        end)
        
        if not success then
            DebugLog('Screenshot request failed: ' .. tostring(err))
            screenshotReceived = true -- Don't wait if request failed
        end
        
        -- Wait up to 5 seconds for screenshot (increased from 3)
        local waited = 0
        while not screenshotReceived and waited < 5000 do
            Wait(50) -- Check more frequently
            waited = waited + 50
            
            -- Check if player disconnected
            if not GetPlayerName(src) then
                DebugLog('Player disconnected during screenshot')
                break
            end
        end
        
        if not screenshotReceived then
            DebugLog('Screenshot timeout after 5 seconds')
        end
        
        if screenshotData then
            DebugLog('Screenshot ready for database (' .. #screenshotData .. ' bytes)')
        else
            DebugLog('No screenshot data available')
        end
    else
        DebugLog('screenshot-basic not available (state: ' .. tostring(screenshotState) .. ') or player disconnected')
    end
    
    -- STEP 2: Save ban to database WITH screenshot
    local banSuccess, banId = pcall(function()
        if screenshotData then
            return exports.oxmysql:insertSync(
                'INSERT INTO admin_bans (license, license2, discord, steam, xbl, live, fivem, ip, tokens, name, reason, admin, expiry, screenshot) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                {license, license2, discord, steam, xbl, live, fivem, ip, tokensStr, name, reason, 'ANTICHEAT', expiry, screenshotData}
            )
        else
            return exports.oxmysql:insertSync(
                'INSERT INTO admin_bans (license, license2, discord, steam, xbl, live, fivem, ip, tokens, name, reason, admin, expiry) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
                {license, license2, discord, steam, xbl, live, fivem, ip, tokensStr, name, reason, 'ANTICHEAT', expiry}
            )
        end
    end)
    
    if banSuccess and banId then
        if screenshotData then
            DebugLog('Ban saved WITH screenshot! ID: ' .. tostring(banId))
        else
            DebugLog('Ban saved WITHOUT screenshot! ID: ' .. tostring(banId))
        end
    else
        ImportantLog('❌ ERROR saving ban: ' .. tostring(banId))
    end
    
    -- STEP 3: Save log WITH screenshot
    local logSuccess, logErr = pcall(function()
        if screenshotData then
            exports.oxmysql:insertSync(
                'INSERT INTO admin_logs (log_type, player_name, player_license, details, screenshot) VALUES (?, ?, ?, ?, ?)',
                {logType or 'anticheat_ban', name, license, 'Banned: ' .. reason, screenshotData}
            )
            DebugLog('Log saved WITH screenshot!')
        else
            exports.oxmysql:insertSync(
                'INSERT INTO admin_logs (log_type, player_name, player_license, details) VALUES (?, ?, ?, ?)',
                {logType or 'anticheat_ban', name, license, 'Banned: ' .. reason}
            )
            DebugLog('Log saved WITHOUT screenshot')
        end
    end)
    
    if not logSuccess then
        ImportantLog('❌ Log error: ' .. tostring(logErr))
    end
    
    -- STEP 4: Send beautiful webhook
    SendBanWebhook(name, src, reason, logType or 'anticheat', license, duration)
    
    -- STEP 5: Drop player LAST
    DropPlayer(src, 'Banned: ' .. reason)
end

-- Alias for compatibility
-- Alias for compatibility
function BanPlayerWithScreenshot(src, reason, duration, logType, title, category)
    BanPlayer(src, reason, duration, logType or category or 'anticheat_ban')
end

local function LogSuspicious(src, logType, details, color, dbLogType)
    local name = GetPlayerName(src) or 'Unknown'
    local license = nil
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 8) == "license:" then license = id break end
    end
    
    -- Try to take screenshot for suspicious activity too
    if GetResourceState('screenshot-basic') == 'started' and GetPlayerName(src) then
        pcall(function()
            exports['screenshot-basic']:requestClientScreenshot(src, {
                encoding = 'jpg',
                quality = 0.80
            }, function(err, data)
                if data and #data > 100 then
                    -- Save with screenshot
                    exports.oxmysql:insert(
                        'INSERT INTO admin_logs (log_type, player_name, player_license, details, screenshot) VALUES (?, ?, ?, ?, ?)',
                        {dbLogType or logType, name, license, details, data}
                    )
                else
                    -- Save without screenshot
                    exports.oxmysql:insert(
                        'INSERT INTO admin_logs (log_type, player_name, player_license, details) VALUES (?, ?, ?, ?)',
                        {dbLogType or logType, name, license, details}
                    )
                end
            end)
        end)
    else
        -- No screenshot-basic, save without
        exports.oxmysql:insert(
            'INSERT INTO admin_logs (log_type, player_name, player_license, details) VALUES (?, ?, ?, ?)',
            {dbLogType or logType, name, license, details}
        )
    end
end

-- ============================================
-- ANTI-RESOURCE STOP - STRICT MODE
-- Protects ALL server resources from being stopped by cheaters
-- ============================================
local clientHeartbeats = {}
local heartbeatInterval = 30000 -- 30 seconds
local pendingResourceStops = {} -- Track pending stops per player

-- Get ALL running resources dynamically
local function GetAllRunningResources()
    local resources = {}
    local numResources = GetNumResources()
    
    for i = 0, numResources - 1 do
        local resourceName = GetResourceByFindIndex(i)
        if resourceName and GetResourceState(resourceName) == 'started' then
            resources[resourceName] = true
        end
    end
    
    return resources
end

-- Send all running resources to client on connect
AddEventHandler('playerConnecting', function()
    local src = source
    SetTimeout(5000, function()
        if GetPlayerName(src) then -- Player still connected
            local resources = GetAllRunningResources()
            TriggerClientEvent('anticheat:setProtectedResources', src, resources)
            -- DebugLog('Sent protected resources to player ' .. src)
        end
    end)
end)

-- Track when client starts
RegisterNetEvent('anticheat:clientStarted', function()
    local src = source
    clientHeartbeats[src] = { lastBeat = os.time(), started = true }
    pendingResourceStops[src] = {}
    -- Send ALL running resources as protected
    local resources = GetAllRunningResources()
    TriggerClientEvent('anticheat:setProtectedResources', src, resources)
    DebugLog('Client started for ' .. (GetPlayerName(src) or src))
end)

-- Client detected a resource stop (3 second warning)
RegisterNetEvent('anticheat:resourceStopDetected', function(resourceName)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    resourceName = resourceName or 'unknown'
    
    -- Track this pending stop
    if not pendingResourceStops[src] then pendingResourceStops[src] = {} end
    pendingResourceStops[src][resourceName] = os.time()
    
    DebugLog('⚠️ ' .. name .. ' - Resource stop detected: ' .. resourceName .. ' (3 sec grace period)')
    
    -- Log to webhook (warning, not ban yet)
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = '🛡️ Anticheat System',
            embeds = {{
                title = '⚠️ RESOURCE STOP DETECTED',
                description = '**' .. name .. '** stopped a resource - 3 second grace period',
                color = 16776960, -- Yellow
                fields = {
                    { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                    { name = '📦 Resource', value = '`' .. resourceName .. '`', inline = true },
                    { name = '⏱️ Status', value = 'Waiting 3 seconds...', inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end)

-- Client confirmed cheat (resource didn't restart in 3 seconds) = INSTANT BAN
RegisterNetEvent('anticheat:resourceStopped', function(resourceName, stopType)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    resourceName = resourceName or 'unknown'
    stopType = stopType or 'unknown'
    
    ImportantLog('🚨 ' .. name .. ' CONFIRMED CHEAT - Resource: ' .. resourceName .. ' (Type: ' .. stopType .. ')')
    
    -- Clear pending stops
    if pendingResourceStops[src] then
        pendingResourceStops[src][resourceName] = nil
    end
    
    local reason = 'Stopped server resource: ' .. resourceName .. ' (' .. stopType .. ')'
    BanPlayerWithScreenshot(src, reason, nil, 'resource_stop', '🚨 RESOURCE STOP - BANNED', 'Resource Stop')
end)

-- Heartbeat response from client
RegisterNetEvent('anticheat:heartbeatResponse', function()
    local src = source
    if clientHeartbeats[src] then
        clientHeartbeats[src].lastBeat = os.time()
        clientHeartbeats[src].missedBeats = 0
    end
end)

-- Check heartbeats periodically - STRICT VERSION
CreateThread(function()
    Wait(30000) -- Wait 30 seconds before starting checks
    
    while true do
        Wait(10000) -- Check every 10 seconds
        
        for _, playerId in ipairs(GetPlayers()) do
            local src = tonumber(playerId)
            if src and not IsWhitelisted(src) then
                -- Initialize if needed
                if not clientHeartbeats[src] then
                    clientHeartbeats[src] = { lastBeat = os.time(), started = false, missedBeats = 0 }
                end
                
                -- Send heartbeat check
                TriggerClientEvent('anticheat:heartbeatCheck', src)
                
                -- Check if client has been silent
                if clientHeartbeats[src].started then
                    local timeSinceLastBeat = os.time() - clientHeartbeats[src].lastBeat
                    
                    -- If no response for 15+ seconds, count as missed
                    if timeSinceLastBeat > 15 then
                        clientHeartbeats[src].missedBeats = (clientHeartbeats[src].missedBeats or 0) + 1
                        DebugLog((GetPlayerName(src) or src) .. ' - Missed heartbeat #' .. clientHeartbeats[src].missedBeats)
                        
                        -- 3 missed heartbeats = anticheat was disabled = BAN
                        if clientHeartbeats[src].missedBeats >= 3 then
                            local name = GetPlayerName(src) or 'Unknown'
                            ImportantLog(name .. ' - ANTICHEAT DISABLED! Banning...')
                
                            local reason = 'Anticheat client disabled/stopped'
                            BanPlayerWithScreenshot(src, reason, nil, 'heartbeat_fail', '🛑 ANTICHEAT DISABLED', 'Client Disabled')
                        end
                    end
                end
            end
        end
    end
end)

-- ============================================
-- ANTI-EVENT SPAM PROTECTION
-- ============================================
local eventCounts = {}
local eventLimits = {
    ['anticheat:updatePosition'] = { limit = 10, window = 5 },
    ['anticheat:godmodeDetected'] = { limit = 3, window = 10 },
    ['anticheat:noclipDetected'] = { limit = 3, window = 10 },
    ['anticheat:teleportDetected'] = { limit = 3, window = 10 },
    ['anticheat:heartbeatResponse'] = { limit = 5, window = 30 },
    ['anticheat:blacklistedPlate'] = { limit = 5, window = 30 },
    ['anticheat:illegalVehicleMod'] = { limit = 10, window = 30 },
}

local function CheckEventSpam(src, eventName)
    if not eventCounts[src] then eventCounts[src] = {} end
    if not eventCounts[src][eventName] then eventCounts[src][eventName] = { count = 0, firstTime = os.time() } end
    
    local data = eventCounts[src][eventName]
    local limit = eventLimits[eventName]
    
    if not limit then return false end -- No limit for this event
    
    local now = os.time()
    if now - data.firstTime > limit.window then
        -- Reset window
        data.count = 1
        data.firstTime = now
        return false
    end
    
    data.count = data.count + 1
    
    if data.count > limit.limit then
        DebugLog('Event spam detected from ' .. (GetPlayerName(src) or src) .. ': ' .. eventName)
        return true
    end
    
    return false
end

-- Suspicious activity logging
RegisterNetEvent('anticheat:suspiciousActivity', function(activityType)
    local src = source
    if IsWhitelisted(src) then return end
    
    if CheckEventSpam(src, 'anticheat:suspiciousActivity') then
        BanPlayer(src, 'Event spam detected', AC_Config.banDuration)
        return
    end
    
    local name = GetPlayerName(src) or 'Unknown'
    DebugLog('Suspicious activity from ' .. name .. ': ' .. tostring(activityType))
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '⚠️ SUSPICIOUS ACTIVITY',
                description = '**' .. name .. '** triggered: ' .. tostring(activityType),
                color = 16776960,
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end)

-- Initialize player data
AddEventHandler('playerConnecting', function()
    local src = source
    playerData[src] = {
        lastPos = nil,
        lastPosTime = 0,
        teleportViolations = 0,
        godmodeViolations = 0,
        noclipViolations = 0,
        -- Server-side health tracking
        lastHealth = 200,
        lastArmor = 0,
        healthCheckTime = 0,
        noDamageInCombat = 0
    }
    clientHeartbeats[src] = { lastBeat = os.time(), started = false }
end)

-- ============================================
-- SERVER-SIDE HEALTH MONITORING v2.0
-- Backup godmode detection from server
-- ============================================
CreateThread(function()
    Wait(60000) -- Wait 1 minute before starting
    
    while true do
        Wait(5000) -- Check every 5 seconds
        
        for _, playerId in ipairs(GetPlayers()) do
            local src = tonumber(playerId)
            if src and not IsWhitelisted(src) then
                local ped = GetPlayerPed(src)
                
                if ped and DoesEntityExist(ped) then
                    local health = GetEntityHealth(ped)
                    local armor = GetPedArmour(ped)
                    local maxHealth = GetEntityMaxHealth(ped)
                    
                    -- Initialize player data if needed
                    if not playerData[src] then
                        playerData[src] = {
                            lastHealth = health,
                            lastArmor = armor,
                            healthCheckTime = os.time(),
                            noDamageInCombat = 0
                        }
                    end
                    
                    -- Check for super health (server-side verification)
                    if health > 250 then
                        local name = GetPlayerName(src) or 'Unknown'
                        ImportantLog(name .. ' has SUPER HEALTH: ' .. health)
                        
                        -- Log and ban
                        if Config and Config.Webhooks and Config.Webhooks.anticheat then
                            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                                username = '🛡️ Anticheat System',
                                embeds = {{
                                    title = '❤️ SERVER-SIDE: SUPER HEALTH DETECTED',
                                    description = '**' .. name .. '** has impossible health value!',
                                    color = 16711680,
                                    fields = {
                                        { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                                        { name = '❤️ Health', value = '`' .. health .. '`', inline = true },
                                        { name = '🛡️ Max Health', value = '`' .. maxHealth .. '`', inline = true },
                                    },
                                    footer = { text = '🛡️ Server-Side Detection • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                                }}
                            }), { ['Content-Type'] = 'application/json' })
                        end
                        
                        BanPlayer(src, 'Server-side: Super health detected (' .. health .. ')', nil, 'godmode_server')
                    end
                    
                    -- Check for super armor (server-side verification)
                    if armor > 100 then
                        local name = GetPlayerName(src) or 'Unknown'
                        ImportantLog(name .. ' has SUPER ARMOR: ' .. armor)
                        
                        if Config and Config.Webhooks and Config.Webhooks.anticheat then
                            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                                username = '🛡️ Anticheat System',
                                embeds = {{
                                    title = '🛡️ SERVER-SIDE: SUPER ARMOR DETECTED',
                                    description = '**' .. name .. '** has impossible armor value!',
                                    color = 16711680,
                                    fields = {
                                        { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                                        { name = '🛡️ Armor', value = '`' .. armor .. '`', inline = true },
                                    },
                                    footer = { text = '🛡️ Server-Side Detection • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                                }}
                            }), { ['Content-Type'] = 'application/json' })
                        end
                        
                        BanPlayer(src, 'Server-side: Super armor detected (' .. armor .. ')', nil, 'godmode_server')
                    end
                    
                    -- Check for impossible max health
                    if maxHealth > 300 then
                        local name = GetPlayerName(src) or 'Unknown'
                        ImportantLog(name .. ' has MODIFIED MAX HEALTH: ' .. maxHealth)
                        
                        BanPlayer(src, 'Server-side: Modified max health (' .. maxHealth .. ')', nil, 'godmode_server')
                    end
                    
                    -- Update tracking
                    playerData[src].lastHealth = health
                    playerData[src].lastArmor = armor
                    playerData[src].healthCheckTime = os.time()
                end
            end
        end
    end
end)

-- ============================================
-- SERVER-SIDE ANTI-NOCLIP v3.0
-- Backup noclip detection from server
-- Detects: Teleport, Speed, Underground, Wall Pass, Floating
-- ============================================
local serverNoclipData = {}

-- Initialize noclip tracking for player
local function InitNoclipTracking(src)
    if not serverNoclipData[src] then
        serverNoclipData[src] = {
            positions = {},
            maxPositions = 20,
            violations = 0,
            lastCheckTime = os.time(),
            lastPos = nil,
            lastVelocity = nil,
            floatingTime = 0,
            undergroundCount = 0,
            speedViolations = 0,
            teleportViolations = 0,
            upwardCount = 0,       -- New: upward position delta tracking
            extremeHeightCount = 0 -- New: extreme altitude tracking
        }
    end
    return serverNoclipData[src]
end

-- Calculate distance between two positions
local function GetDistance3D(pos1, pos2)
    if not pos1 or not pos2 then return 0 end
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    local dz = pos1.z - pos2.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- Calculate horizontal distance (ignore Z)
local function GetDistance2D(pos1, pos2)
    if not pos1 or not pos2 then return 0 end
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    return math.sqrt(dx*dx + dy*dy)
end

-- Server-side noclip detection thread
CreateThread(function()
    Wait(45000) -- Wait 45 seconds before starting
    -- ImportantLog('Server-Side Anti-Noclip v3.0 Active')
    
    while true do
        Wait(500) -- Check every 500ms for accuracy
        
        local currentTime = os.time()
        local currentMs = GetGameTimer()
        
        for _, playerId in ipairs(GetPlayers()) do
            local src = tonumber(playerId)
            if src and not IsWhitelisted(src) then
                local ped = GetPlayerPed(src)
                
                if ped and DoesEntityExist(ped) then
                    local coords = GetEntityCoords(ped)
                    local velocity = GetEntityVelocity(ped)
                    local speed = math.sqrt(velocity.x^2 + velocity.y^2 + velocity.z^2)
                    local verticalSpeed = velocity.z
                    local name = GetPlayerName(src) or 'Unknown'
                    
                    -- Initialize tracking
                    local data = InitNoclipTracking(src)
                    
                    -- Skip if dead
                    if GetEntityHealth(ped) <= 0 then
                        data.lastPos = nil
                        data.violations = 0
                        goto continueServerNoclip
                    end
                    
                    -- Check if in vehicle
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    local isInVehicle = vehicle ~= 0
                    local vehicleSpeed = 0
                    if isInVehicle then
                        vehicleSpeed = GetEntitySpeed(vehicle) * 3.6 -- km/h
                    end
                    
                    -- ═══════════════════════════════════════════════════════════
                    -- SERVER CHECK 1: UNDERGROUND DETECTION
                    -- ═══════════════════════════════════════════════════════════
                    if coords.z < -50.0 then
                        data.undergroundCount = data.undergroundCount + 1
                        
                        if data.undergroundCount >= 3 then
                            DebugLog('🕳️ ' .. name .. ' UNDERGROUND! Z: ' .. math.floor(coords.z))
                            data.violations = data.violations + 3
                            data.undergroundCount = 0
                            
                            -- Log to webhook
                            if Config and Config.Webhooks and Config.Webhooks.anticheat then
                                PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                                    username = '🛡️ Anticheat System',
                                    embeds = {{
                                        title = '🕳️ SERVER: UNDERGROUND DETECTED',
                                        description = '**' .. name .. '** is below the map!',
                                        color = 16711680,
                                        fields = {
                                            { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                                            { name = '📍 Z Position', value = '`' .. math.floor(coords.z) .. '`', inline = true },
                                        },
                                        footer = { text = '🛡️ Server-Side Detection • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                                    }}
                                }), { ['Content-Type'] = 'application/json' })
                            end
                        end
                    else
                        data.undergroundCount = math.max(0, data.undergroundCount - 1)
                    end
                    
                    -- ═══════════════════════════════════════════════════════════
                    -- SERVER CHECK 2: IMPOSSIBLE SPEED DETECTION
                    -- ═══════════════════════════════════════════════════════════
                    if data.lastPos then
                        local timeDiff = 0.5 -- 500ms
                        local distance = GetDistance3D(coords, data.lastPos)
                        local calculatedSpeed = distance / timeDiff -- m/s
                        
                        -- Max speeds (generous for lag)
                        local maxFootSpeed = 15.0 -- Running + buffer
                        local maxVehicleSpeed = 120.0 -- ~430 km/h for fast cars
                        local maxAircraftSpeed = 200.0 -- For jets
                        
                        local maxAllowedSpeed = maxFootSpeed
                        if isInVehicle then
                            -- Check vehicle class for aircraft
                            local vehicleClass = GetVehicleClass(vehicle)
                            if vehicleClass == 15 or vehicleClass == 16 then -- Helicopters/Planes
                                maxAllowedSpeed = maxAircraftSpeed
                            else
                                maxAllowedSpeed = maxVehicleSpeed
                            end
                        end
                        
                        -- Check for impossible speed
                        if calculatedSpeed > maxAllowedSpeed and distance > 20.0 then
                            data.speedViolations = data.speedViolations + 1
                            
                            if data.speedViolations >= 3 then
                                DebugLog('⚡ ' .. name .. ' IMPOSSIBLE SPEED! ' .. math.floor(calculatedSpeed) .. ' m/s')
                                data.violations = data.violations + 2
                                data.speedViolations = 0
                                
                                -- Log to webhook
                                if Config and Config.Webhooks and Config.Webhooks.anticheat then
                                    PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                                        username = '🛡️ Anticheat System',
                                        embeds = {{
                                            title = '⚡ SERVER: IMPOSSIBLE SPEED',
                                            description = '**' .. name .. '** is moving impossibly fast!',
                                            color = 16711680,
                                            fields = {
                                                { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                                                { name = '🚀 Speed', value = '`' .. math.floor(calculatedSpeed) .. ' m/s`', inline = true },
                                                { name = '📏 Distance', value = '`' .. math.floor(distance) .. 'm in 0.5s`', inline = true },
                                                { name = '🚗 In Vehicle', value = '`' .. (isInVehicle and 'Yes' or 'No') .. '`', inline = true },
                                            },
                                            footer = { text = '🛡️ Server-Side Detection • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                                        }}
                                    }), { ['Content-Type'] = 'application/json' })
                                end
                            end
                        else
                            data.speedViolations = math.max(0, data.speedViolations - 1)
                        end
                        
                        -- ═══════════════════════════════════════════════════════════
                        -- SERVER CHECK 3: TELEPORT DETECTION
                        -- ═══════════════════════════════════════════════════════════
                        -- Instant large distance = teleport
                        if distance > 150.0 and not isInVehicle then
                            data.teleportViolations = data.teleportViolations + 1
                            
                            if data.teleportViolations >= 2 then
                                DebugLog('🌀 ' .. name .. ' TELEPORT! Distance: ' .. math.floor(distance) .. 'm')
                                data.violations = data.violations + 3
                                data.teleportViolations = 0
                                
                                -- Log to webhook
                                if Config and Config.Webhooks and Config.Webhooks.anticheat then
                                    PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                                        username = '🛡️ Anticheat System',
                                        embeds = {{
                                            title = '🌀 SERVER: TELEPORT DETECTED',
                                            description = '**' .. name .. '** teleported!',
                                            color = 16711680,
                                            fields = {
                                                { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                                                { name = '📏 Distance', value = '`' .. math.floor(distance) .. 'm`', inline = true },
                                                { name = '📍 From', value = '`' .. math.floor(data.lastPos.x) .. ', ' .. math.floor(data.lastPos.y) .. ', ' .. math.floor(data.lastPos.z) .. '`', inline = false },
                                                { name = '📍 To', value = '`' .. math.floor(coords.x) .. ', ' .. math.floor(coords.y) .. ', ' .. math.floor(coords.z) .. '`', inline = false },
                                            },
                                            footer = { text = '🛡️ Server-Side Detection • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                                        }}
                                    }), { ['Content-Type'] = 'application/json' })
                                end
                            end
                        else
                            data.teleportViolations = math.max(0, data.teleportViolations - 1)
                        end
                    end
                    
                    -- ═══════════════════════════════════════════════════════════
                    -- SERVER CHECK 4: NOCLIP FLYING DETECTION (v5.0 SERVER-SAFE)
                    -- Uses only server-available data: coords.z, velocity, position delta
                    -- GetEntityHeightAboveGround/GetPedParachuteState are CLIENT-ONLY
                    -- ═══════════════════════════════════════════════════════════
                    if not isInVehicle then
                        -- Calculate REAL vertical + horizontal movement from position delta
                        local realVerticalDelta = 0.0
                        local realHorizSpeed = 0.0
                        if data.lastPos then
                            realVerticalDelta = coords.z - data.lastPos.z -- per 500ms tick
                            local dx = coords.x - data.lastPos.x
                            local dy = coords.y - data.lastPos.y
                            realHorizSpeed = math.sqrt(dx^2 + dy^2) / 0.5 -- m/s
                        end

                        -- === DETECTION A: SUSTAINED HIGH Z + ZERO/POSITIVE VELOCITY ===
                        -- Player at high Z with no downward velocity = flying/floating
                        -- Normal falling has velocity.z < -5
                        if coords.z > 50.0 and verticalSpeed > -2.0 and verticalSpeed < 2.0 and realHorizSpeed > 3.0 then
                            data.floatingTime = data.floatingTime + 1

                            if data.floatingTime >= 8 then -- 8×500ms = 4 seconds
                                DebugLog('✈️ ' .. name .. ' FLYING! Z: ' .. math.floor(coords.z) .. ', VSpeed: ' .. string.format('%.1f', verticalSpeed))
                                data.violations = data.violations + 2
                                data.floatingTime = 0

                                if Config and Config.Webhooks and Config.Webhooks.anticheat then
                                    PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                                        username = '🛡️ Anticheat System',
                                        embeds = {{
                                            title = '✈️ SERVER: FLYING DETECTED',
                                            description = '**' .. name .. '** is flying without vehicle!',
                                            color = 16711680,
                                            fields = {
                                                { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                                                { name = '📍 Z Position', value = '`' .. math.floor(coords.z) .. '`', inline = true },
                                                { name = '🚀 Horiz Speed', value = '`' .. string.format('%.1f', realHorizSpeed) .. ' m/s`', inline = true },
                                                { name = '📍 Position', value = '`' .. math.floor(coords.x) .. ', ' .. math.floor(coords.y) .. ', ' .. math.floor(coords.z) .. '`', inline = false },
                                            },
                                            footer = { text = '🛡️ Server-Side Detection • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                                        }}
                                    }), { ['Content-Type'] = 'application/json' })
                                end
                            end
                        elseif verticalSpeed < -5.0 then
                            -- Falling fast = legitimate
                            data.floatingTime = 0
                        else
                            data.floatingTime = math.max(0, data.floatingTime - 2)
                        end

                        -- === DETECTION B: RAPID UPWARD POSITION DELTA ===
                        -- Z moving up >3m per 500ms without jumping = noclip going up
                        -- Normal jump raises Z by max ~1.5m in 500ms
                        if data.lastPos and realVerticalDelta > 3.0 and coords.z > 30.0 then
                            data.upwardCount = data.upwardCount + 1
                            if data.upwardCount >= 3 then
                                DebugLog('⬆️ ' .. name .. ' UPWARD NOCLIP! Z delta: +' .. string.format('%.1f', realVerticalDelta) .. 'm')
                                data.violations = data.violations + 2
                                data.upwardCount = 0
                            end
                        else
                            data.upwardCount = math.max(0, data.upwardCount - 1)
                        end

                        -- === DETECTION C: EXTREME ALTITUDE ===
                        -- >200m Z without aircraft = impossible without noclip
                        if coords.z > 200.0 then
                            data.extremeHeightCount = data.extremeHeightCount + 1
                            if data.extremeHeightCount >= 2 then
                                DebugLog('🚨 ' .. name .. ' EXTREME ALTITUDE! Z: ' .. math.floor(coords.z))
                                data.violations = data.violations + 3
                                data.extremeHeightCount = 0
                            end
                        else
                            data.extremeHeightCount = 0
                        end
                    else
                        -- In vehicle: reset flying counters
                        data.floatingTime = 0
                        data.upwardCount = 0
                        data.extremeHeightCount = 0
                    end
                    
                    -- ═══════════════════════════════════════════════════════════
                    -- SERVER CHECK 5: POSITION HISTORY ANALYSIS
                    -- Detect erratic movement patterns
                    -- ═══════════════════════════════════════════════════════════
                    table.insert(data.positions, {
                        pos = coords,
                        time = currentMs,
                        speed = speed
                    })
                    
                    -- Keep only last N positions
                    while #data.positions > data.maxPositions do
                        table.remove(data.positions, 1)
                    end
                    
                    -- Analyze movement pattern (need at least 10 positions)
                    if #data.positions >= 10 then
                        local directionChanges = 0
                        local lastDirection = nil
                        
                        for i = 2, #data.positions do
                            local prev = data.positions[i-1].pos
                            local curr = data.positions[i].pos
                            local dx = curr.x - prev.x
                            local dy = curr.y - prev.y
                            
                            -- Calculate direction (simplified to 8 directions)
                            local direction = math.floor((math.atan(dy, dx) + math.pi) / (math.pi / 4))
                            
                            if lastDirection and math.abs(direction - lastDirection) >= 4 then
                                directionChanges = directionChanges + 1
                            end
                            lastDirection = direction
                        end
                        
                        -- Too many direction changes in short time = erratic/noclip
                        if directionChanges >= 6 then
                            DebugLog('🔀 ' .. name .. ' ERRATIC MOVEMENT! Direction changes: ' .. directionChanges)
                            data.violations = data.violations + 1
                        end
                    end
                    
                    -- ═══════════════════════════════════════════════════════════
                    -- VIOLATION CHECK & BAN
                    -- ═══════════════════════════════════════════════════════════
                    local maxViolations = GetACViolations('noclip') + 1 -- Faster bans (was +2)
                    
                    if data.violations >= maxViolations then
                        ImportantLog('🚨 ' .. name .. ' NOCLIP CONFIRMED (Server-Side)! Violations: ' .. data.violations)
                        
                        local banDuration = GetACBanDuration('noclip')
                        
                        -- Detailed webhook
                        if Config and Config.Webhooks and Config.Webhooks.anticheat then
                            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                                username = '🛡️ Anticheat System',
                                embeds = {{
                                    title = '🚨 SERVER-SIDE: NOCLIP CONFIRMED',
                                    description = '**' .. name .. '** was caught by server-side noclip detection!',
                                    color = 16711680,
                                    fields = {
                                        { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                                        { name = '🔢 Violations', value = '`' .. data.violations .. '`', inline = true },
                                        { name = '📍 Position', value = '`' .. math.floor(coords.x) .. ', ' .. math.floor(coords.y) .. ', ' .. math.floor(coords.z) .. '`', inline = false },
                                        { name = '🔍 Detection', value = '`Server-Side Anti-Noclip v3.0`', inline = false },
                                    },
                                    footer = { text = '🛡️ Server-Side Detection • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                                }}
                            }), { ['Content-Type'] = 'application/json' })
                        end
                        
                        BanPlayer(src, 'Server-side: Noclip detected (Violations: ' .. data.violations .. ')', banDuration, 'noclip_server')
                        data.violations = 0
                    else
                        -- Slow decay
                        data.violations = math.max(0, data.violations - 0.2)
                    end
                    
                    -- Update last position
                    data.lastPos = coords
                    data.lastVelocity = velocity
                    data.lastCheckTime = currentTime
                    
                    ::continueServerNoclip::
                end
            end
        end
    end
end)

-- Cleanup server noclip data on disconnect
AddEventHandler('playerDropped', function()
    local src = source
    serverNoclipData[src] = nil
end)

-- ============================================
-- SERVER-SIDE INVINCIBLE FLAG CHECK
-- Periodically check if players have invincible flag set
-- ============================================
CreateThread(function()
    Wait(90000) -- Wait 1.5 minutes before starting
    
    while true do
        Wait(10000) -- Check every 10 seconds
        
        for _, playerId in ipairs(GetPlayers()) do
            local src = tonumber(playerId)
            if src and not IsWhitelisted(src) then
                -- CRITICAL: Don't check if player is in character selection
                if Framework.IsInCharacterSelection(src) then
                    goto continueHealthCheck
                end
                
                -- Don't check if player just connected (grace period)
                if not Framework.IsPlayerLoaded(src) then
                    goto continueHealthCheck
                end
                
                local ped = GetPlayerPed(src)
                
                if ped and DoesEntityExist(ped) then
                    -- Request client to check invincible flag
                    -- (Server can't directly check GetPlayerInvincible)
                    TriggerClientEvent('anticheat:serverHealthCheck', src)
                end
                
                ::continueHealthCheck::
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    
    -- Cleanup event counts and heartbeats
    eventCounts[src] = nil
    clientHeartbeats[src] = nil
    
    -- Check if player was warned and quit
    if warnedPlayers[src] then
        local warnData = warnedPlayers[src]
        local timeSinceWarn = os.time() - warnData.warnTime
        
        -- If quit within 60 seconds of warning = ban
        if timeSinceWarn < 60 then
            local name = warnData.name
            local license = warnData.license
            local discord = warnData.discord
            local steam = warnData.steam
            
            if license then
                local expiry = os.time() + (AC_Config.banDuration * 60)
                
                exports.oxmysql:insert('INSERT INTO ' .. (Config and Config.BanTable or 'admin_bans') .. ' (license, discord, steam, name, reason, admin, expiry) VALUES (?, ?, ?, ?, ?, ?, ?)', {
                    license, discord, steam, name, 'Quit during anticheat warning - Evasion', 'ANTICHEAT', expiry
                })
                
                ImportantLog(name .. ' quit during warning - ban applied!')
                
                -- Webhook
                if Config and Config.Webhooks and Config.Webhooks.anticheat then
                    PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                        username = 'Anticheat',
                        embeds = {{
                            title = '🚨 EVASION BAN',
                            description = '**' .. name .. '** quit during anticheat warning!',
                            color = 16711680,
                            fields = {
                                { name = '👤 Player', value = name, inline = true },
                                { name = '⏱️ Duration', value = '24 hours', inline = true },
                            },
                            footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
                        }}
                    }), { ['Content-Type'] = 'application/json' })
                end
            end
        end
        
        warnedPlayers[src] = nil
    end
    
    playerData[src] = nil
end)

-- Teleport detection from client (new advanced system)
RegisterNetEvent('anticheat:teleportDetected', function(distance, speed)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    ImportantLog(name .. ' TELEPORT DETECTED! Distance: ' .. distance .. 'm')
    
    BanPlayer(src, 'Teleport hack detected (Distance: ' .. distance .. 'm)', AC_Config.banDuration, 'teleport')
end)

-- Legacy position updates (backup system)
RegisterNetEvent('anticheat:updatePosition', function(coords, isInVehicle, vehicleSpeed)
    local src = source
    if IsWhitelisted(src) then return end
    
    if not playerData[src] then
        playerData[src] = { lastPos = nil, lastPosTime = 0, teleportViolations = 0 }
    end
    
    local currentTime = GetGameTimer()
    local data = playerData[src]
    
    if data.lastPos then
        local timeDiff = (currentTime - data.lastPosTime) / 1000
        if timeDiff > 0.5 then
            local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(data.lastPos.x, data.lastPos.y, data.lastPos.z))
            local speed = distance / timeDiff
            
            local maxSpeed = AC_Config.maxTeleportDistance
            if isInVehicle then
                maxSpeed = math.max(maxSpeed, (vehicleSpeed or 0) * 1.5 + 50)
            end
            
            if speed > maxSpeed and distance > 100 then
                data.teleportViolations = data.teleportViolations + 1
                DebugLog((GetPlayerName(src) or src) .. ' teleport violation #' .. data.teleportViolations)
                
                if data.teleportViolations >= AC_Config.teleportViolationsBeforeBan then
                    BanPlayer(src, 'Teleport hack detected', AC_Config.banDuration, 'teleport')
                end
            else
                data.teleportViolations = math.max(0, data.teleportViolations - 1)
            end
        end
    end
    
    data.lastPos = coords
    data.lastPosTime = currentTime
end)

-- Godmode detection from client (ADVANCED v5.0)
RegisterNetEvent('anticheat:godmodeDetected', function(detectionType)
    local src = source
    
    -- Check admin protection first
    if HasAdminProtection(src, 'godmode') then
        DebugLog('Ignoring godmode for admin ' .. src)
        return
    end
    
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    detectionType = detectionType or 'unknown'
    
    ImportantLog(name .. ' GODMODE DETECTED! Type: ' .. detectionType)
    
    -- Parse detection type for better logging
    local detectionCategory = 'Unknown'
    local detectionDetails = detectionType
    local banDuration = AC_Config.banDuration -- Default 24 hours
    local webhookColor = 16711680 -- Red
    local emoji = '🛡️'
    
    if string.find(detectionType, 'invincible_flag') then
        detectionCategory = 'Invincible Flag'
        detectionDetails = 'SetPlayerInvincible() detected'
        emoji = '🚫'
        banDuration = nil -- Permanent for obvious cheats
    elseif string.find(detectionType, 'super_armor') then
        detectionCategory = 'Super Armor'
        local armorValue = string.match(detectionType, 'super_armor_(%d+)')
        detectionDetails = 'Armor value: ' .. (armorValue or '100+')
        emoji = '🛡️'
        banDuration = nil -- Permanent
    elseif string.find(detectionType, 'super_health') then
        detectionCategory = 'Super Health'
        local healthValue = string.match(detectionType, 'super_health_(%d+)')
        detectionDetails = 'Health value: ' .. (healthValue or '250+')
        emoji = '❤️'
        banDuration = nil -- Permanent
    elseif string.find(detectionType, 'fall_damage_immune') then
        detectionCategory = 'Fall Damage Immunity'
        local fallDist = string.match(detectionType, 'fall_damage_immune_(%d+)m')
        detectionDetails = 'Fell ' .. (fallDist or '15+') .. ' meters without damage'
        emoji = '🪂'
        banDuration = AC_Config.banDuration
    elseif string.find(detectionType, 'bullet_immune') then
        detectionCategory = 'Bullet Immunity'
        local shots = string.match(detectionType, 'bullet_immune_(%d+)_shots')
        detectionDetails = 'Received ' .. (shots or '5+') .. ' shots without damage'
        emoji = '🔫'
        banDuration = nil -- Permanent
    elseif string.find(detectionType, 'explosion_immune') then
        detectionCategory = 'Explosion Immunity'
        detectionDetails = 'Near explosion without damage'
        emoji = '💥'
        banDuration = AC_Config.banDuration
    elseif string.find(detectionType, 'fire_immune') then
        detectionCategory = 'Fire Immunity'
        local duration = string.match(detectionType, 'fire_immune_(%d+)s')
        detectionDetails = 'On fire for ' .. (duration or '3+') .. ' seconds without damage'
        emoji = '🔥'
        banDuration = AC_Config.banDuration
    elseif string.find(detectionType, 'drown_immune') then
        detectionCategory = 'Drowning Immunity'
        local duration = string.match(detectionType, 'drown_immune_(%d+)s')
        detectionDetails = 'Underwater for ' .. (duration or '30+') .. ' seconds without damage'
        emoji = '🌊'
        banDuration = AC_Config.banDuration
    end
    
    local durationText = banDuration and (math.floor(banDuration / 60) .. ' hours') or '⛔ PERMANENT'
    
    local reason = 'Godmode detected: ' .. detectionCategory .. ' (' .. detectionDetails .. ')'
    
    -- Ban with screenshot (single webhook)
    BanPlayerWithScreenshot(src, reason, banDuration, 'godmode', emoji .. ' GODMODE DETECTED - ' .. detectionCategory:upper(), detectionCategory)
end)

-- Freecam detection from client
RegisterNetEvent('anticheat:freecamDetected', function(distance)
    local src = source
    if IsWhitelisted(src) then return end
    if not IsDetectionEnabled('freecam') then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    local banDuration = GetACBanDuration('freecam')
    
    ImportantLog(name .. ' FREECAM DETECTED! Distance: ' .. tostring(distance) .. 'm')
    
    local reason = 'Freecam/Spectate hack detected (Distance: ' .. tostring(distance) .. 'm)'
    BanPlayerWithScreenshot(src, reason, banDuration, 'freecam', '📷 FREECAM DETECTED', 'Spectate Hack')
end)

-- Noclip detection from client (ADVANCED v3.0)
RegisterNetEvent('anticheat:noclipDetected', function(detectionType)
    local src = source
    if IsWhitelisted(src) then return end
    if not IsDetectionEnabled('noclip') then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    local banDuration = GetACBanDuration('noclip')
    detectionType = detectionType or 'unknown'
    
    -- Parse detection type for better logging
    local detectionCategory = 'Unknown'
    local emoji = '🚀'
    
    if string.find(detectionType, 'wall') then
        detectionCategory = 'Wall Pass'
        emoji = '🧱'
    elseif string.find(detectionType, 'floating') or string.find(detectionType, 'flying') then
        detectionCategory = 'Flying/Floating'
        emoji = '✈️'
    elseif string.find(detectionType, 'acceleration') then
        detectionCategory = 'Impossible Acceleration'
        emoji = '⚡'
    elseif string.find(detectionType, 'underground') then
        detectionCategory = 'Underground'
        emoji = '🕳️'
    elseif string.find(detectionType, 'invisible') then
        detectionCategory = 'Invisible Noclip'
        emoji = '👻'
    elseif string.find(detectionType, 'frozen') then
        detectionCategory = 'Frozen Entity Moving'
        emoji = '🧊'
    elseif string.find(detectionType, 'collision') then
        detectionCategory = 'No Collision'
        emoji = '💨'
    elseif string.find(detectionType, 'upward') then
        detectionCategory = 'Upward Noclip'
        emoji = '⬆️'
    elseif string.find(detectionType, 'direction') then
        detectionCategory = 'Instant Direction Change'
        emoji = '↩️'
    elseif string.find(detectionType, 'solid') then
        detectionCategory = 'Inside Solid Geometry'
        emoji = '🔲'
    end
    
    ImportantLog(name .. ' NOCLIP DETECTED! Type: ' .. detectionCategory)
    
    local reason = 'Noclip detected: ' .. detectionCategory .. ' (' .. detectionType .. ')'
    
    BanPlayerWithScreenshot(src, reason, banDuration, 'noclip', emoji .. ' NOCLIP DETECTED', detectionCategory)
end)

-- ============================================
-- BEHAVIOR ANALYSIS DETECTIONS
-- ESP, Aimbot, Wallhack
-- ============================================

-- Suspicious aim (aimbot) detection
RegisterNetEvent('anticheat:suspiciousAim', function(aimSpeed)
    local src = source
    if IsWhitelisted(src) then return end
    if not IsDetectionEnabled('aimbot') then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    local violationsNeeded = GetACViolations('aimbot')
    local banDuration = GetACBanDuration('aimbot')
    
    DebugLog(name .. ' SUSPICIOUS AIM! Speed: ' .. tostring(aimSpeed) .. ' deg/s')
    
    -- Track violations
    if not playerData[src] then playerData[src] = {} end
    playerData[src].aimbotViolations = (playerData[src].aimbotViolations or 0) + 1
    
    -- Only log warning webhook (not ban yet)
    if playerData[src].aimbotViolations < violationsNeeded then
        if Config and Config.Webhooks and Config.Webhooks.anticheat then
            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                username = '🛡️ Anticheat System',
                embeds = {{
                    title = '🎯 SUSPICIOUS AIM WARNING',
                    description = '**' .. name .. '** has suspicious aim patterns',
                    color = 16776960,
                    fields = {
                        { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                        { name = '🎯 Aim Speed', value = '`' .. tostring(aimSpeed) .. ' deg/s`', inline = true },
                        { name = '🔢 Violations', value = '`' .. playerData[src].aimbotViolations .. '/' .. violationsNeeded .. '`', inline = true },
                    },
                    footer = { text = '⚠️ Warning - Not banned yet • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                }}
            }), { ['Content-Type'] = 'application/json' })
        end
    end
    
    if playerData[src].aimbotViolations >= violationsNeeded then
        local reason = 'Aimbot detected (Aim speed: ' .. tostring(aimSpeed) .. ' deg/s)'
        BanPlayerWithScreenshot(src, reason, banDuration, 'aimbot', '🎯 AIMBOT DETECTED', 'Suspicious Aim')
        playerData[src].aimbotViolations = 0
    end
end)

-- Silent Aim detection
RegisterNetEvent('anticheat:silentAim', function(distance, angleDiff)
    local src = source
    if IsWhitelisted(src) then return end
    if not IsDetectionEnabled('silentAim') then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    local banDuration = GetACBanDuration('silentAim')
    
    DebugLog(name .. ' SILENT AIM! Distance: ' .. tostring(distance) .. 'm')
    
    local reason = 'Silent Aim detected (Hit at ' .. tostring(angleDiff) .. '° off target)'
    BanPlayerWithScreenshot(src, reason, banDuration, 'silent_aim', '🎯 SILENT AIM DETECTED', 'Silent Aim')
end)

-- Aimbot snap detection
RegisterNetEvent('anticheat:aimbotSnap', function(speed, count)
    local src = source
    if IsWhitelisted(src) then return end
    if not IsDetectionEnabled('aimbot') then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    local banDuration = GetACBanDuration('aimbot')
    
    DebugLog(name .. ' AIMBOT SNAP! Speed: ' .. tostring(speed))
    
    local reason = 'Aimbot detected (Snap speed: ' .. tostring(speed) .. ' deg/s)'
    BanPlayerWithScreenshot(src, reason, banDuration, 'aimbot', '🎯 AIMBOT SNAP DETECTED', 'Aim Snapping')
end)

-- Suspicious accuracy detection
RegisterNetEvent('anticheat:suspiciousAccuracy', function(accType, value)
    local src = source
    if IsWhitelisted(src) then return end
    if not IsDetectionEnabled('aimbot') then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    local violationsNeeded = GetACViolations('aimbot')
    local banDuration = GetACBanDuration('aimbot')
    
    DebugLog(name .. ' SUSPICIOUS ACCURACY! Type: ' .. tostring(accType))
    
    -- Track violations
    if not playerData[src] then playerData[src] = {} end
    playerData[src].accuracyViolations = (playerData[src].accuracyViolations or 0) + 1
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        local title = '🎯 SUSPICIOUS ACCURACY'
        local desc = '**' .. name .. '** has suspicious shooting patterns'
        
        if accType == 'headshots' then
            desc = '**' .. name .. '** has ' .. tostring(value) .. '/10 headshots at long range!'
        elseif accType == 'alignment' then
            desc = '**' .. name .. '** has perfect aim alignment: ' .. tostring(value)
        elseif accType == 'rapidfire' then
            desc = '**' .. name .. '** hit ' .. tostring(value) .. ' targets rapidly!'
        end
        
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = title,
                description = desc,
                color = 16776960,
                fields = {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '📊 Type', value = tostring(accType), inline = true },
                    { name = '🔢 Violations', value = playerData[src].accuracyViolations .. '/' .. violationsNeeded, inline = true },
                },
                footer = { text = 'Review recommended' }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    -- Ban after violations threshold
    if playerData[src].accuracyViolations >= violationsNeeded then
        BanPlayer(src, 'Aimbot detected (Inhuman accuracy)', banDuration, 'aimbot')
        playerData[src].accuracyViolations = 0
    end
end)

-- ============================================
-- WEAPON MODIFIER DETECTION (Infinite Ammo, No Reload, Rapid Fire)
-- ============================================
RegisterNetEvent('anticheat:weaponModifier', function(modType, weaponHash)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    modType = modType or 'unknown'
    
    ImportantLog(name .. ' WEAPON MODIFIER! Type: ' .. modType)
    
    -- Determine ban reason based on type
    local banReason = 'Weapon modifier detected'
    local webhookTitle = '🔫 WEAPON MODIFIER'
    local webhookColor = 16711680 -- Red
    
    if modType == 'infinite_ammo' then
        banReason = 'Infinite Ammo detected'
        webhookTitle = '♾️ INFINITE AMMO DETECTED'
    elseif modType == 'no_reload_clip' then
        banReason = 'No Reload hack detected'
        webhookTitle = '🔄 NO RELOAD DETECTED'
    elseif modType == 'rapid_fire' then
        banReason = 'Rapid Fire hack detected'
        webhookTitle = '⚡ RAPID FIRE DETECTED'
    end
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = '🛡️ Anticheat System',
            embeds = {{
                title = webhookTitle,
                description = '**' .. name .. '** was caught using weapon modifiers!',
                color = webhookColor,
                fields = {
                    { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                    { name = '🔫 Type', value = '`' .. modType .. '`', inline = true },
                    { name = '⚙️ Weapon Hash', value = '`' .. tostring(weaponHash or 'N/A') .. '`', inline = true },
                },
                footer = { text = '🛡️ aether Anticheat • ' .. os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    -- INSTANT BAN
    BanPlayer(src, banReason, AC_Config.banDuration, 'weapon_modifier')
end)

-- ESP detection (looking at hidden players)
RegisterNetEvent('anticheat:espDetected', function(count)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    ImportantLog(name .. ' ESP DETECTED! ' .. tostring(count) .. ' times')
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '👁️ ESP DETECTED',
                description = '**' .. name .. '** is looking at players through walls',
                color = 16711680,
                fields = {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '🔢 Count', value = tostring(count) .. ' times', inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    BanPlayer(src, 'ESP/Wallhack detected', AC_Config.banDuration, 'esp')
end)

-- Wallhack detection (shooting through walls) - 2 violations in 20 sec = BAN
RegisterNetEvent('anticheat:wallhackDetected', function(distance, violations)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    ImportantLog(name .. ' WALLHACK CONFIRMED! Distance: ' .. tostring(distance) .. 'm')
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '🧱 WALLHACK CONFIRMED - BANNED',
                description = '**' .. name .. '** was shooting through walls!',
                color = 16711680,
                fields = {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '📏 Distance', value = tostring(distance) .. 'm', inline = true },
                    { name = '🔢 Violations', value = tostring(violations) .. ' in 20 sec', inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    -- Instant ban - already confirmed by client (2 violations in 20 sec)
    BanPlayer(src, 'Wallhack detected (Shooting through walls - ' .. tostring(violations) .. ' times)', AC_Config.banDuration, 'wallhack')
end)

-- Illegal vehicle detection
RegisterNetEvent('anticheat:illegalVehicle', function(vehicleName)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    ImportantLog(name .. ' spawned illegal vehicle: ' .. tostring(vehicleName))
    
    BanPlayer(src, 'Illegal vehicle spawned: ' .. tostring(vehicleName), nil, 'illegal_vehicle') -- Permanent ban
end)

-- Blacklisted plate detection
RegisterNetEvent('anticheat:blacklistedPlate', function(plate, blacklistedWord, vehicleNetId)
    local src = source
    
    -- Check event spam
    if CheckEventSpam(src, 'anticheat:blacklistedPlate') then
        if Config.Debug then print('[ANTICHEAT] [DEBUG] Event spam detected for blacklistedPlate from player ' .. src) end
        return
    end
    
    if Config.Debug then
        print('[ANTICHEAT] [DEBUG] Received blacklistedPlate event from player ' .. src)
        print('[ANTICHEAT] [DEBUG] Plate: ' .. tostring(plate) .. ', Word: ' .. tostring(blacklistedWord) .. ', NetId: ' .. tostring(vehicleNetId))
    end
    
    if IsWhitelisted(src) then 
        if Config.Debug then print('[ANTICHEAT] [DEBUG] Player ' .. src .. ' is whitelisted, ignoring') end
        return 
    end
    
    local name = GetPlayerName(src) or 'Unknown'
    ImportantLog('BLACKLISTED PLATE! Player: ' .. name .. ', Plate: ' .. tostring(plate))
    
    -- Take screenshot (handled by BanPlayer)
    
    -- Delete the vehicle
    if vehicleNetId then
        if Config.Debug then print('[ANTICHEAT] [DEBUG] Attempting to delete vehicle with NetId: ' .. tostring(vehicleNetId)) end
        local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
        if Config.Debug then print('[ANTICHEAT] [DEBUG] Vehicle entity: ' .. tostring(vehicle)) end
        if DoesEntityExist(vehicle) then
            if Config.Debug then print('[ANTICHEAT] [DEBUG] Vehicle exists, deleting...') end
            DeleteEntity(vehicle)
            if Config.Debug then print('[ANTICHEAT] [DEBUG] Vehicle deleted!') end
        else
            if Config.Debug then print('[ANTICHEAT] [DEBUG] Vehicle does not exist!') end
        end
    else
        if Config.Debug then print('[ANTICHEAT] [DEBUG] No vehicleNetId provided!') end
    end
    
    -- Ban player
    if Config.Debug then print('[ANTICHEAT] [DEBUG] Banning player ' .. src .. '...') end
    BanPlayer(src, 'Blacklisted vehicle plate detected: ' .. tostring(plate) .. ' (cheat signature: ' .. tostring(blacklistedWord) .. ')', nil, 'blacklisted_plate')
    if Config.Debug then print('[ANTICHEAT] [DEBUG] Ban executed!') end
    
    -- Webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '🚗 BLACKLISTED PLATE DETECTED',
                description = '**' .. name .. '** has a vehicle with blacklisted plate (cheat signature)',
                color = 16711680, -- Red
                fields = {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '🔢 Plate', value = tostring(plate), inline = true },
                    { name = '⚠️ Matched', value = tostring(blacklistedWord), inline = true },
                    { name = '🚫 Action', value = 'BANNED', inline = true },
                },
                footer = { text = 'Aether Anticheat • ' .. os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end)

-- Illegal vehicle modification detection (outside mechanic shops)
RegisterNetEvent('anticheat:illegalVehicleMod', function(modType, coords, vehicleNetId)
    local src = source
    
    -- Check event spam
    if CheckEventSpam(src, 'anticheat:illegalVehicleMod') then
        if Config.Debug then print('[ANTICHEAT] [DEBUG] Event spam detected for illegalVehicleMod from player ' .. src) end
        return
    end
    
    if Config.Debug then
        print('[ANTICHEAT] [DEBUG] Received illegalVehicleMod event from player ' .. src)
        print('[ANTICHEAT] [DEBUG] ModType: ' .. tostring(modType) .. ', NetId: ' .. tostring(vehicleNetId))
    end
    
    if IsWhitelisted(src) then 
        if Config.Debug then print('[ANTICHEAT] [DEBUG] Player ' .. src .. ' is whitelisted, ignoring') end
        return 
    end
    
    local name = GetPlayerName(src) or 'Unknown'
    local coordsStr = coords and string.format("%.1f, %.1f, %.1f", coords.x, coords.y, coords.z) or "Unknown"
    
    ImportantLog('ILLEGAL VEHICLE MOD! Player: ' .. name .. ', Type: ' .. tostring(modType))
    
    -- Take screenshot (handled by BanPlayer)
    
    -- Delete the vehicle
    if vehicleNetId then
        if Config.Debug then print('[ANTICHEAT] [DEBUG] Attempting to delete vehicle with NetId: ' .. tostring(vehicleNetId)) end
        local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
        if Config.Debug then print('[ANTICHEAT] [DEBUG] Vehicle entity: ' .. tostring(vehicle)) end
        if DoesEntityExist(vehicle) then
            if Config.Debug then print('[ANTICHEAT] [DEBUG] Vehicle exists, deleting...') end
            DeleteEntity(vehicle)
            if Config.Debug then print('[ANTICHEAT] [DEBUG] Vehicle deleted!') end
        else
            if Config.Debug then print('[ANTICHEAT] [DEBUG] Vehicle does not exist!') end
        end
    else
        if Config.Debug then print('[ANTICHEAT] [DEBUG] No vehicleNetId provided!') end
    end
    
    -- Ban player
    if Config.Debug then print('[ANTICHEAT] [DEBUG] Banning player ' .. src .. '...') end
    BanPlayer(src, 'Illegal vehicle modification outside mechanic shop: ' .. tostring(modType), nil, 'illegal_vehicle_mod')
    if Config.Debug then print('[ANTICHEAT] [DEBUG] Ban executed!') end
    
    -- Webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '🔧 ILLEGAL VEHICLE MODIFICATION',
                description = '**' .. name .. '** modified vehicle outside mechanic shop',
                color = 16711680, -- Red
                fields = {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '🔧 Modification', value = tostring(modType), inline = true },
                    { name = '📍 Location', value = coordsStr, inline = false },
                    { name = '🚫 Action', value = 'BANNED', inline = true },
                },
                footer = { text = 'Aether Anticheat • ' .. os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end)

-- Illegal ped detection
RegisterNetEvent('anticheat:illegalPed', function(pedModel)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    DebugLog(name .. ' used blacklisted ped model: ' .. tostring(pedModel))
    
    -- Kick instead of ban for ped
    DropPlayer(src, '[ANTICHEAT] Blacklisted ped model detected')
    
    -- Webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '⚠️ ILLEGAL PED DETECTED',
                description = '**' .. name .. '** used a blacklisted ped model',
                color = 16776960,
                fields = {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '🎭 Ped Model', value = tostring(pedModel), inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end)

-- Illegal weapon detection
RegisterNetEvent('anticheat:illegalWeapon', function(weaponHash, reason)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    ImportantLog(name .. ' illegal weapon: ' .. tostring(weaponHash))
    
    if reason == 'blacklisted' then
        -- Blacklisted weapon = permanent ban
        BanPlayer(src, 'Blacklisted weapon detected', nil, 'illegal_weapon')
    else
        -- Weapon not in inventory = kick
        DropPlayer(src, '[ANTICHEAT] Weapon not in inventory')
        
        -- Webhook
        if Config and Config.Webhooks and Config.Webhooks.anticheat then
            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                username = 'Anticheat',
                embeds = {{
                    title = '⚠️ WEAPON NOT IN INVENTORY',
                    description = '**' .. name .. '** had a weapon not in their inventory',
                    color = 16776960,
                    fields = {
                        { name = '👤 Player', value = name, inline = true },
                        { name = '🔫 Weapon', value = tostring(weaponHash), inline = true },
                    },
                    footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
                }}
            }), { ['Content-Type'] = 'application/json' })
        end
    end
end)

-- ============================================
-- INVENTORY SYSTEM DETECTION FOR ANTICHEAT (ESX / OX)
-- ============================================
local AC_InventorySystem = {
    type = 'none', -- 'ox', 'esx', 'none'
    ESX = nil
}

-- Detect inventory system on resource start
CreateThread(function()
    Wait(1000)
    
    local configSetting = Config and Config.InventorySystem or 'auto'
    
    if configSetting == 'none' then
        -- Disabled by config
        AC_InventorySystem.type = 'none'
        DebugLog('Inventory System: DISABLED')
    elseif configSetting == 'ox' then
        -- Force OX
        if GetResourceState('ox_inventory') == 'started' then
            AC_InventorySystem.type = 'ox'
            DebugLog('Inventory System: OX Inventory')
        else
            ImportantLog('^1ERROR: ox_inventory not running!^0')
            AC_InventorySystem.type = 'none'
        end
    elseif configSetting == 'esx' then
        -- Force ESX
        if GetResourceState('es_extended') == 'started' then
            AC_InventorySystem.type = 'esx'
            AC_InventorySystem.ESX = exports['es_extended']:getSharedObject()
            DebugLog('Inventory System: ESX')
        else
            ImportantLog('^1ERROR: es_extended not running!^0')
            AC_InventorySystem.type = 'none'
        end
    else
        -- Auto-detect (default)
        if GetResourceState('ox_inventory') == 'started' then
            AC_InventorySystem.type = 'ox'
            DebugLog('Inventory System: OX Inventory (auto-detected)')
        elseif GetResourceState('es_extended') == 'started' then
            AC_InventorySystem.type = 'esx'
            AC_InventorySystem.ESX = exports['es_extended']:getSharedObject()
            DebugLog('Inventory System: ESX (auto-detected)')
        else
            DebugLog('Inventory System: None detected')
            AC_InventorySystem.type = 'none'
        end
    end
end)

-- Get inventory weapons for client (supports ESX and OX)
RegisterNetEvent('anticheat:getInventoryWeapons', function()
    local src = source
    local weapons = {}
    
    if AC_InventorySystem.type == 'ox' then
        -- OX Inventory
        -- Method 1: Try GetInventoryItems
        local success, items = pcall(function()
            return exports.ox_inventory:GetInventoryItems(src)
        end)
        
        if success and items then
            for _, item in pairs(items) do
                if item and item.name then
                    local itemName = item.name:upper()
                    if string.find(itemName, 'WEAPON_') or string.find(itemName, 'weapon_') then
                        table.insert(weapons, itemName)
                        table.insert(weapons, 'WEAPON_' .. itemName:gsub('WEAPON_', ''))
                    end
                end
            end
        end
        
        -- Method 2: Try GetInventory
        local success2, inv = pcall(function()
            return exports.ox_inventory:GetInventory(src)
        end)
        
        if success2 and inv and inv.items then
            for _, item in pairs(inv.items) do
                if item and item.name then
                    local itemName = item.name:upper()
                    if string.find(itemName, 'WEAPON') then
                        if not string.find(itemName, 'WEAPON_') then
                            itemName = 'WEAPON_' .. itemName
                        end
                        table.insert(weapons, itemName)
                    end
                end
            end
        end
        
        
    elseif AC_InventorySystem.type == 'esx' and AC_InventorySystem.ESX then
        -- ESX Inventory
        local xPlayer = AC_InventorySystem.ESX.GetPlayerFromId(src)
        if xPlayer then
            -- Method 1: Get loadout (weapons)
            local loadout = xPlayer.getLoadout()
            if loadout then
                for _, weapon in pairs(loadout) do
                    if weapon and weapon.name then
                        local weaponName = weapon.name:upper()
                        if not string.find(weaponName, 'WEAPON_') then
                            weaponName = 'WEAPON_' .. weaponName
                        end
                        table.insert(weapons, weaponName)
                    end
                end
            end
            
            -- Method 2: Check inventory for weapon items
            local inventory = xPlayer.getInventory()
            if inventory then
                for _, item in pairs(inventory) do
                    if item and item.name and item.count and item.count > 0 then
                        local itemName = item.name:upper()
                        if string.find(itemName, 'WEAPON') then
                            if not string.find(itemName, 'WEAPON_') then
                                itemName = 'WEAPON_' .. itemName
                            end
                            table.insert(weapons, itemName)
                        end
                    end
                end
            end
        end
        
        DebugLog('ESX Weapons for ' .. (GetPlayerName(src) or src) .. ': ' .. #weapons)
    end
    
    -- Debug print weapons
    -- Debug weapon list removed for cleaner console
    
    TriggerClientEvent('anticheat:updateInventoryWeapons', src, weapons)
end)

-- ============================================
-- ADMIN ANTICHEAT COMMANDS
-- ============================================

-- Warn player (fullscreen warning)
RegisterNetEvent('aether_admin:warnPlayer', function(targetId)
    local src = source
    local group = GetAdminGroup(src)
    if group ~= 'superadmin' then return end
    
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then return end
    
    local targetName = GetPlayerName(targetId)
    
    -- Store warn data
    warnedPlayers[targetId] = {
        name = targetName,
        license = GetPlayerLicense(targetId),
        discord = GetPlayerDiscord(targetId),
        steam = GetPlayerSteam(targetId),
        warnTime = os.time(),
        warnedBy = GetPlayerName(src),
        completed = false
    }
    
    -- Send warning to target
    TriggerClientEvent('anticheat:showWarning', targetId)
    
    -- Notify admin
    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Warning sent to ' .. targetName .. ' - They must hold SPACE for 10s' })
    
    -- Log
    DebugLog(GetPlayerName(src) .. ' warned ' .. targetName)
    
    -- Webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '⚠️ PLAYER WARNED',
                description = '**' .. targetName .. '** received anticheat warning',
                color = 16776960,
                fields = {
                    { name = '👤 Target', value = targetName, inline = true },
                    { name = '👮 Admin', value = GetPlayerName(src), inline = true },
                    { name = '⏱️ Duration', value = '10 seconds (hold SPACE)', inline = true }
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
end)

-- Warning started
RegisterNetEvent('anticheat:warningStarted', function()
    local src = source
    if warnedPlayers[src] then
        warnedPlayers[src].started = true
        DebugLog('Warning started for ' .. GetPlayerName(src))
    end
end)

-- Warning completed successfully
RegisterNetEvent('anticheat:warningCompleted', function()
    local src = source
    if warnedPlayers[src] then
        warnedPlayers[src].completed = true
        DebugLog(GetPlayerName(src) .. ' completed warning')
        
        -- Webhook
        if Config and Config.Webhooks and Config.Webhooks.anticheat then
            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                username = 'Anticheat',
                embeds = {{
                    title = '✅ WARNING COMPLETED',
                    description = '**' .. GetPlayerName(src) .. '** acknowledged the warning',
                    color = 65280,
                    footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
                }}
            }), { ['Content-Type'] = 'application/json' })
        end
        
        -- Clear after 5 seconds
        SetTimeout(5000, function()
            warnedPlayers[src] = nil
        end)
    end
end)

-- Detect quit during warning
AddEventHandler('playerDropped', function(reason)
    local src = source
    if warnedPlayers[src] and not warnedPlayers[src].completed then
        local data = warnedPlayers[src]
        local name = data.name
        
        ImportantLog('🚨 ' .. name .. ' quit during warning - BANNING!')
        
        -- Ban player for quitting
        local banReason = 'Disconnected during admin warning (Quit to avoid punishment)'
        local expiry = nil -- Permanent ban
        
        -- Save ban
        pcall(function()
            exports.oxmysql:insert(
                'INSERT INTO admin_bans (license, discord, steam, name, reason, admin, expiry) VALUES (?, ?, ?, ?, ?, ?, ?)',
                {data.license, data.discord, data.steam, name, banReason, 'ANTICHEAT', expiry}
            )
        end)
        
        -- Webhook
        if Config and Config.Webhooks and Config.Webhooks.anticheat then
            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                username = 'Anticheat',
                embeds = {{
                    title = '🚨 QUIT DURING WARNING - BANNED',
                    description = '**' .. name .. '** disconnected during warning and was banned',
                    color = 16711680,
                    fields = {
                        { name = '👤 Player', value = name, inline = true },
                        { name = '👮 Warned By', value = data.warnedBy, inline = true },
                        { name = '📝 Reason', value = banReason, inline = false },
                        { name = '⏱️ Duration', value = 'PERMANENT', inline = true }
                    },
                    footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
                }}
            }), { ['Content-Type'] = 'application/json' })
        end
        
        warnedPlayers[src] = nil
    end
end)

-- Clear entities in radius
RegisterNetEvent('aether_admin:clearEntities', function(entityType, radius)
    local src = source
    local group = GetAdminGroup(src)
    if group ~= 'superadmin' then return end
    
    radius = tonumber(radius) or 50
    local adminPed = GetPlayerPed(src)
    local adminCoords = GetEntityCoords(adminPed)
    local count = 0
    
    -- Broadcast to all clients to delete entities
    TriggerClientEvent('anticheat:clearEntities', -1, entityType, adminCoords, radius, src)
    
    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Clearing ' .. entityType .. ' in ' .. radius .. 'm radius' })
    
    DebugLog(GetPlayerName(src) .. ' cleared ' .. entityType .. ' in ' .. radius .. 'm radius')
end)

-- Toggle debug mode (disable whitelist for testing)
RegisterNetEvent('anticheat:toggleDebugMode', function(enabled)
    local src = source
    local group = GetAdminGroup(src)
    if group ~= 'superadmin' then return end
    
    debugModePlayers[src] = enabled or nil
    
    -- Send debug mode state to client
    TriggerClientEvent('anticheat:setDebugMode', src, enabled)
    
    local status = enabled and 'ENABLED' or 'DISABLED'
    DebugLog('Debug mode ' .. status .. ' for ' .. GetPlayerName(src))
    
    if enabled then
        TriggerClientEvent('ox_lib:notify', src, { 
            type = 'error', 
            description = '⚠️ DEBUG MODE ON - Anticheat will check YOU now!' 
        })
    else
        TriggerClientEvent('ox_lib:notify', src, { 
            type = 'success', 
            description = '✅ Debug mode OFF - You are protected again' 
        })
    end
end)

-- ============================================
-- INVISIBLE DETECTION (PERMA BAN)
-- ============================================
RegisterNetEvent('anticheat:invisibleDetected', function(alpha)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    ImportantLog(name .. ' INVISIBLE DETECTED! Alpha: ' .. tostring(alpha))
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '👻 INVISIBLE PLAYER DETECTED',
                description = '**' .. name .. '** was invisible!',
                color = 16711680,
                fields = {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '👁️ Alpha', value = tostring(alpha), inline = true },
                    { name = '⏱️ Duration', value = 'PERMANENT', inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    -- PERMANENT BAN for invisibility
    BanPlayer(src, 'Invisible hack detected (Alpha: ' .. tostring(alpha) .. ')', nil, 'invisible')
end)

-- ============================================
-- SPOOFED WEAPON DETECTION (PERMA BAN)
-- ============================================
RegisterNetEvent('anticheat:spoofedWeapon', function(weaponHash)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    ImportantLog(name .. ' SPOOFED WEAPON! Hash: ' .. tostring(weaponHash))
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '🔫 SPOOFED WEAPON DETECTED',
                description = '**' .. name .. '** had a weapon not in inventory!',
                color = 16711680,
                fields = {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '🔫 Weapon Hash', value = tostring(weaponHash), inline = true },
                    { name = '⏱️ Duration', value = 'PERMANENT', inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    -- PERMANENT BAN for spoofed weapons
    BanPlayer(src, 'Spoofed weapon detected (Not in inventory)', nil, 'spoofed_weapon')
end)

-- ============================================
-- SPOOFED VEHICLE DETECTION (PERMA BAN)
-- ============================================
RegisterNetEvent('anticheat:spoofedVehicle', function(modelName, reason)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    ImportantLog(name .. ' SPOOFED VEHICLE! Model: ' .. tostring(modelName))
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = 'Anticheat',
            embeds = {{
                title = '🚗 SPOOFED VEHICLE DETECTED',
                description = '**' .. name .. '** had a client-side only vehicle!',
                color = 16711680,
                fields = {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '🚗 Vehicle', value = tostring(modelName), inline = true },
                    { name = '📝 Reason', value = tostring(reason), inline = true },
                    { name = '⏱️ Duration', value = 'PERMANENT', inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    -- PERMANENT BAN for spoofed vehicles
    BanPlayer(src, 'Spoofed vehicle detected (' .. tostring(modelName) .. ' - ' .. tostring(reason) .. ')', nil, 'spoofed_vehicle')
end)

-- Clean up debug mode when player disconnects
AddEventHandler('playerDropped', function()
    local src = source
    debugModePlayers[src] = nil
end)

-- ============================================
-- ANTI-KILL (Kill without weapon in inventory)
-- ============================================
RegisterNetEvent('anticheat:illegalKill', function(victimId, weaponHash, killType)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    local victimName = GetPlayerName(victimId) or 'Unknown'
    
    ImportantLog(name .. ' ILLEGAL KILL! Victim: ' .. victimName)
    
    -- Log with details (screenshot is automatic now)
    LogSuspicious(src, 'ILLEGAL KILL DETECTED', 
        'Killer: ' .. name .. '\nVictim: ' .. victimName .. '\nWeapon: ' .. tostring(weaponHash) .. '\nType: ' .. killType, 
        16711680)
    
    BanPlayer(src, 'Illegal kill (' .. killType .. ') - Victim: ' .. victimName, nil) -- PERMANENT
end)

-- ============================================
-- ANTI-SUICIDE (Cheat suicide)
-- ============================================
RegisterNetEvent('anticheat:cheatSuicide', function(health, weaponHash)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    
    DebugLog(name .. ' CHEAT SUICIDE! Health was: ' .. health)
    
    LogSuspicious(src, 'CHEAT SUICIDE DETECTED', 
        'Player: ' .. name .. '\nHealth before death: ' .. health .. '\nWeapon: ' .. tostring(weaponHash), 
        16711680)
    
    BanPlayer(src, 'Cheat suicide detected (Health was ' .. health .. ')', AC_Config.banDuration)
end)

-- ============================================
-- ANTI-SELF REVIVE (Log first 2, ban on 3rd)
-- ============================================
local selfReviveViolations = {}

RegisterNetEvent('anticheat:selfRevive', function(violations, timeSinceDeath)
    local src = source
    
    -- Check admin protection first
    if HasAdminProtection(src, 'revive') then
        DebugLog('Ignoring self-revive for admin ' .. src)
        return
    end
    
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    
    if not selfReviveViolations[src] then selfReviveViolations[src] = 0 end
    selfReviveViolations[src] = selfReviveViolations[src] + 1
    
    DebugLog(name .. ' SELF-REVIVE! Violations: ' .. selfReviveViolations[src])
    
    if selfReviveViolations[src] < 3 then
        -- Just log (screenshot is automatic)
        LogSuspicious(src, 'SELF-REVIVE DETECTED (' .. selfReviveViolations[src] .. '/3)', 
            'Player: ' .. name .. '\nTime since death: ' .. timeSinceDeath .. 'ms\nWarning ' .. selfReviveViolations[src] .. ' of 3', 
            16776960) -- Yellow
    else
        -- 3rd violation = BAN
        LogSuspicious(src, 'SELF-REVIVE - BANNED (3/3)', 
            'Player: ' .. name .. '\n3rd violation - BANNED', 
            16711680) -- Red
        
        BanPlayer(src, 'Self-revive detected (3 violations)', AC_Config.banDuration, 'self_revive')
        selfReviveViolations[src] = 0
    end
end)

-- ============================================
-- ANTI-SELF HEAL (Log first 2, ban on 3rd)
-- ============================================
local selfHealViolations = {}

RegisterNetEvent('anticheat:selfHeal', function(violations, healAmount)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    
    if not selfHealViolations[src] then selfHealViolations[src] = 0 end
    selfHealViolations[src] = selfHealViolations[src] + 1
    
    DebugLog(name .. ' SELF-HEAL! Amount: ' .. healAmount)
    
    if selfHealViolations[src] < 3 then
        -- Just log (screenshot is automatic)
        LogSuspicious(src, 'SELF-HEAL DETECTED (' .. selfHealViolations[src] .. '/3)', 
            'Player: ' .. name .. '\nHeal amount: +' .. healAmount .. '\nWarning ' .. selfHealViolations[src] .. ' of 3', 
            16776960) -- Yellow
    else
        -- 3rd violation = BAN
        LogSuspicious(src, 'SELF-HEAL - BANNED (3/3)', 
            'Player: ' .. name .. '\n3rd violation - BANNED', 
            16711680) -- Red
        
        BanPlayer(src, 'Self-heal detected (3 violations)', AC_Config.banDuration, 'self_heal')
        selfHealViolations[src] = 0
    end
end)

-- Clean up violations on disconnect
AddEventHandler('playerDropped', function()
    local src = source
    selfReviveViolations[src] = nil
    selfHealViolations[src] = nil
end)

print('[ANTICHEAT] ✅ Server-side anticheat loaded')

-- ============================================
-- ANTI-LUA EXECUTOR DETECTION (CAREFUL VERSION)
-- Only bans on CONFIRMED cheat menu detection
-- ============================================

RegisterNetEvent('anticheat:luaExecutorConfirmed', function(menuName)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    
    ImportantLog(name .. ' CONFIRMED CHEAT MENU: ' .. menuName)
    
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = '🛡️ Anticheat System',
            embeds = {{
                title = '🚨 CHEAT MENU CONFIRMED - BANNED',
                description = '**' .. name .. '** was using **' .. menuName .. '**!',
                color = 16711680,
                fields = {
                    { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                    { name = '🆔 Server ID', value = '`' .. src .. '`', inline = true },
                    { name = '🎮 Cheat Menu', value = '`' .. menuName .. '`', inline = true },
                    { name = '⏱️ Duration', value = '`PERMANENT`', inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    BanPlayer(src, 'Cheat Menu detected: ' .. menuName, nil, 'cheat_menu')
end)

-- print('[ANTICHEAT] Anti-Lua Executor module loaded!')


-- ============================================
-- ANTI-WEAPON MODIFIER DETECTION
-- ============================================

local weaponModViolations = {}

RegisterNetEvent('anticheat:weaponModifier', function(modType, weaponHash)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    
    if not weaponModViolations[src] then
        weaponModViolations[src] = 0
    end
    weaponModViolations[src] = weaponModViolations[src] + 1
    
    DebugLog(name .. ' WEAPON MODIFIER! Type: ' .. modType)
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = '🛡️ Anticheat System',
            embeds = {{
                title = '🔫 WEAPON MODIFIER DETECTED',
                description = '**' .. name .. '** is using weapon modifications!',
                color = 16711680,
                fields = {
                    { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                    { name = '🆔 Server ID', value = '`' .. src .. '`', inline = true },
                    { name = '📝 Type', value = '`' .. modType .. '`', inline = true },
                    { name = '🔫 Weapon', value = '`' .. tostring(weaponHash) .. '`', inline = true },
                    { name = '🔢 Violations', value = '`' .. weaponModViolations[src] .. '`', inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    -- Ban after 3 violations
    if weaponModViolations[src] >= 3 then
        BanPlayer(src, 'Weapon Modifier detected: ' .. modType, nil, 'weapon_mod')
        weaponModViolations[src] = nil
    end
end)

-- ============================================
-- ANTI-FREECAM/SPECTATE ABUSE DETECTION
-- ============================================

local freecamViolations = {}

RegisterNetEvent('anticheat:freecamAbuse', function(distance, abuseType)
    local src = source
    if IsWhitelisted(src) then return end
    
    local name = GetPlayerName(src) or 'Unknown'
    
    if not freecamViolations[src] then
        freecamViolations[src] = 0
    end
    freecamViolations[src] = freecamViolations[src] + 1
    
    DebugLog(name .. ' FREECAM ABUSE! Type: ' .. abuseType)
    
    -- Log to webhook
    if Config and Config.Webhooks and Config.Webhooks.anticheat then
        PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
            username = '🛡️ Anticheat System',
            embeds = {{
                title = '📷 FREECAM/SPECTATE ABUSE',
                description = '**' .. name .. '** is using freecam/spectate hack!',
                color = 16711680,
                fields = {
                    { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                    { name = '🆔 Server ID', value = '`' .. src .. '`', inline = true },
                    { name = '📝 Type', value = '`' .. abuseType .. '`', inline = true },
                    { name = '📏 Distance', value = '`' .. tostring(distance) .. 'm`', inline = true },
                    { name = '🔢 Violations', value = '`' .. freecamViolations[src] .. '`', inline = true },
                },
                footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end
    
    -- Ban after 3 violations
    if freecamViolations[src] >= 3 then
        BanPlayer(src, 'Freecam/Spectate abuse: ' .. abuseType, nil, 'freecam')
        freecamViolations[src] = nil
    end
end)

-- Cleanup on disconnect
AddEventHandler('playerDropped', function()
    local src = source
    weaponModViolations[src] = nil
    freecamViolations[src] = nil
end)

-- print('[ANTICHEAT] Weapon Modifier & Freecam modules loaded!')


-- ============================================
-- SERVER-SIDE PLAYER KILL TRACKING
-- Tracks kills between players for wallhack/aimbot detection
-- More reliable than client-side for PvP
-- ============================================

local playerKillData = {}

-- Track player deaths and who killed them
AddEventHandler('baseevents:onPlayerDied', function(killerType, deathCoords)
    -- Player died but not by another player
end)

AddEventHandler('baseevents:onPlayerKilled', function(killerId, deathData)
    local victimId = source
    local victimName = GetPlayerName(victimId) or 'Unknown'
    local killerName = GetPlayerName(killerId) or 'Unknown'
    
    -- Skip if killer is whitelisted
    if IsWhitelisted(killerId) then return end
    
    -- Initialize killer data
    if not playerKillData[killerId] then
        playerKillData[killerId] = {
            kills = 0,
            headshots = 0,
            longRangeKills = 0,
            recentKills = {},
            lastKillTime = 0
        }
    end
    
    local data = playerKillData[killerId]
    local currentTime = GetGameTimer()
    
    -- Track kill
    data.kills = data.kills + 1
    data.lastKillTime = currentTime
    
    -- Track recent kills (last 60 seconds)
    table.insert(data.recentKills, {
        time = currentTime,
        victim = victimId,
        weapon = deathData and deathData.weaponhash or 0
    })
    
    -- Clean old kills
    local newRecentKills = {}
    for _, kill in ipairs(data.recentKills) do
        if currentTime - kill.time < 60000 then
            table.insert(newRecentKills, kill)
        end
    end
    data.recentKills = newRecentKills
    
    -- Check for suspicious kill rate (more than 10 kills in 60 seconds)
    if #data.recentKills >= 10 then
        DebugLog('SUSPICIOUS KILL RATE! ' .. killerName .. ' has ' .. #data.recentKills .. ' kills in 60 seconds!')
        
        -- Log but don't auto-ban (could be legitimate in big fights)
        LogToDiscord(killerId, 'Suspicious Kill Rate', 'suspicious_kills', 
          killerName .. ' has ' .. #data.recentKills .. ' kills in 60 seconds', nil)
    end
    
    DebugLog('Kill tracked: ' .. killerName .. ' killed ' .. victimName)
end)

-- Cleanup on disconnect
AddEventHandler('playerDropped', function()
    local src = source
    playerKillData[src] = nil
end)

-- Server-side wallhack detection via client report
RegisterNetEvent('anticheat:reportPvPHit', function(victimId, distance, hasLOS, weaponHash)
    local src = source
    if IsWhitelisted(src) then return end
    
    local srcName = GetPlayerName(src) or 'Unknown'
    local victimName = GetPlayerName(victimId) or 'Unknown'
    
    -- If no LOS and long distance = wallhack
    if not hasLOS and distance > 30 then
        if not playerKillData[src] then
            playerKillData[src] = { wallhackViolations = 0 }
        end
        
        playerKillData[src].wallhackViolations = (playerKillData[src].wallhackViolations or 0) + 1
        
        DebugLog('PVP WALLHACK! ' .. srcName .. ' hit ' .. victimName .. ' through walls')
        
        if playerKillData[src].wallhackViolations >= 3 then
            BanPlayer(src, 'Wallhack (PvP): Hit players through walls at ' .. math.floor(distance) .. 'm', nil, 'wallhack')
            playerKillData[src].wallhackViolations = 0
        end
    end
end)

-- print('[ANTICHEAT] Server-side PvP tracking loaded!')


-- Server-side silent aim detection via client report
RegisterNetEvent('anticheat:reportPvPAim', function(victimId, distance, angleDiff, isSuspicious)
    local src = source
    if IsWhitelisted(src) then return end
    
    local srcName = GetPlayerName(src) or 'Unknown'
    local victimName = GetPlayerName(victimId) or 'Unknown'
    
    -- If suspicious aim angle on PvP
    if isSuspicious and distance > 20 then
        if not playerKillData[src] then
            playerKillData[src] = { silentAimViolations = 0 }
        end
        
        playerKillData[src].silentAimViolations = (playerKillData[src].silentAimViolations or 0) + 1
        
        DebugLog('PVP SILENT AIM! ' .. srcName .. ' hit ' .. victimName)
        
        if playerKillData[src].silentAimViolations >= 5 then
            BanPlayer(src, 'Silent Aim (PvP): Hit players at impossible angles (' .. string.format("%.1f", angleDiff) .. '°)', nil, 'aimbot')
            playerKillData[src].silentAimViolations = 0
        end
    end
end)

-- ============================================
-- SERVER-SIDE ADVANCED COMBAT ANALYSIS v2.0
-- Real-time analysis of player combat statistics
-- Detects: Aimbot, Triggerbot, Inhuman Accuracy
-- ============================================
local combatStats = {}

-- Initialize combat stats for player
local function InitCombatStats(src)
    if not combatStats[src] then
        combatStats[src] = {
            -- Kill tracking
            kills = {},
            totalKills = 0,
            headshotKills = 0,
            longRangeKills = 0,
            
            -- Hit tracking
            hits = {},
            totalHits = 0,
            headshots = 0,
            consecutiveHeadshots = 0,
            
            -- Time tracking
            killTimes = {},
            avgTimeBetweenKills = 0,
            
            -- Accuracy
            shotsHit = 0,
            shotsFired = 0,
            
            -- Violations
            violations = 0,
            lastViolationTime = 0
        }
    end
    return combatStats[src]
end

-- Track player shots fired (from client)
RegisterNetEvent('anticheat:shotFired', function(weaponHash)
    local src = source
    if IsWhitelisted(src) then return end
    
    local stats = InitCombatStats(src)
    stats.shotsFired = stats.shotsFired + 1
end)

-- Track player hits (from client)
RegisterNetEvent('anticheat:hitRegistered', function(targetType, distance, isHeadshot, weaponHash, boneHit)
    local src = source
    if IsWhitelisted(src) then return end
    
    local stats = InitCombatStats(src)
    local name = GetPlayerName(src) or 'Unknown'
    local currentTime = os.time()
    
    stats.totalHits = stats.totalHits + 1
    stats.shotsHit = stats.shotsHit + 1
    
    -- Track hit data
    table.insert(stats.hits, {
        time = currentTime,
        distance = distance,
        isHeadshot = isHeadshot,
        targetType = targetType,
        bone = boneHit
    })
    
    -- Keep only last 50 hits
    while #stats.hits > 50 do
        table.remove(stats.hits, 1)
    end
    
    if isHeadshot then
        stats.headshots = stats.headshots + 1
        stats.consecutiveHeadshots = stats.consecutiveHeadshots + 1
    else
        stats.consecutiveHeadshots = 0
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- ANALYSIS 1: HEADSHOT RATE
    -- ═══════════════════════════════════════════════════════════
    if stats.totalHits >= 20 then
        local headshotRate = (stats.headshots / stats.totalHits) * 100
        
        -- Pro players: 15-25% headshot rate
        -- Cheaters: 50%+ headshot rate
        if headshotRate > 60 then
            stats.violations = stats.violations + 1
            print('[ANTICHEAT-SERVER] 🎯 ' .. name .. ' HIGH HEADSHOT RATE: ' .. string.format('%.1f', headshotRate) .. '% (' .. stats.headshots .. '/' .. stats.totalHits .. ')')
            
            if Config and Config.Webhooks and Config.Webhooks.anticheat then
                PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                    username = '🛡️ Anticheat System',
                    embeds = {{
                        title = '🎯 SERVER: HIGH HEADSHOT RATE',
                        description = '**' .. name .. '** has suspicious headshot accuracy!',
                        color = 16776960,
                        fields = {
                            { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                            { name = '🎯 Headshot Rate', value = '`' .. string.format('%.1f', headshotRate) .. '%`', inline = true },
                            { name = '📊 Stats', value = '`' .. stats.headshots .. '/' .. stats.totalHits .. ' hits`', inline = true },
                        },
                        footer = { text = '🛡️ Server-Side Analysis • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                    }}
                }), { ['Content-Type'] = 'application/json' })
            end
        end
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- ANALYSIS 2: CONSECUTIVE HEADSHOTS
    -- ═══════════════════════════════════════════════════════════
    if stats.consecutiveHeadshots >= 7 then
        stats.violations = stats.violations + 2
        print('[ANTICHEAT-SERVER] 🎯 ' .. name .. ' ' .. stats.consecutiveHeadshots .. ' CONSECUTIVE HEADSHOTS!')
        
        if Config and Config.Webhooks and Config.Webhooks.anticheat then
            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                username = '🛡️ Anticheat System',
                embeds = {{
                    title = '🎯 SERVER: CONSECUTIVE HEADSHOTS',
                    description = '**' .. name .. '** hit ' .. stats.consecutiveHeadshots .. ' headshots in a row!',
                    color = 16711680,
                    fields = {
                        { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                        { name = '🎯 Streak', value = '`' .. stats.consecutiveHeadshots .. ' headshots`', inline = true },
                    },
                    footer = { text = '🛡️ Server-Side Analysis • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                }}
            }), { ['Content-Type'] = 'application/json' })
        end
        
        stats.consecutiveHeadshots = 0
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- ANALYSIS 3: LONG RANGE ACCURACY
    -- ═══════════════════════════════════════════════════════════
    if distance > 100 and isHeadshot then
        stats.longRangeKills = stats.longRangeKills + 1
        
        if stats.longRangeKills >= 5 then
            stats.violations = stats.violations + 1
            print('[ANTICHEAT-SERVER] 🎯 ' .. name .. ' LONG RANGE HEADSHOTS: ' .. stats.longRangeKills .. ' at 100m+')
        end
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- ANALYSIS 4: HIT RATE (Accuracy)
    -- ═══════════════════════════════════════════════════════════
    if stats.shotsFired >= 30 then
        local hitRate = (stats.shotsHit / stats.shotsFired) * 100
        
        -- Normal players: 20-40% hit rate
        -- Cheaters: 70%+ hit rate
        if hitRate > 75 then
            stats.violations = stats.violations + 1
            print('[ANTICHEAT-SERVER] 🎯 ' .. name .. ' HIGH HIT RATE: ' .. string.format('%.1f', hitRate) .. '%')
        end
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- BAN CHECK
    -- ═══════════════════════════════════════════════════════════
    local violationsNeeded = GetACViolations('aimbot') + 3 -- Server needs more evidence
    
    if stats.violations >= violationsNeeded then
        local banDuration = GetACBanDuration('aimbot')
        
        print('[ANTICHEAT-SERVER] 🚨 ' .. name .. ' AIMBOT CONFIRMED (Server Analysis)!')
        
        if Config and Config.Webhooks and Config.Webhooks.anticheat then
            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                username = '🛡️ Anticheat System',
                embeds = {{
                    title = '🚨 SERVER: AIMBOT CONFIRMED',
                    description = '**' .. name .. '** was caught by server-side combat analysis!',
                    color = 16711680,
                    fields = {
                        { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                        { name = '🔢 Violations', value = '`' .. stats.violations .. '`', inline = true },
                        { name = '🎯 Headshot Rate', value = '`' .. string.format('%.1f', (stats.headshots / math.max(1, stats.totalHits)) * 100) .. '%`', inline = true },
                        { name = '📊 Total Hits', value = '`' .. stats.totalHits .. '`', inline = true },
                    },
                    footer = { text = '🛡️ Server-Side Analysis • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                }}
            }), { ['Content-Type'] = 'application/json' })
        end
        
        BanPlayer(src, 'Server-side: Aimbot detected (Combat Analysis)', banDuration, 'aimbot_server')
        stats.violations = 0
    end
end)

-- Track player kills
RegisterNetEvent('anticheat:killRegistered', function(victimId, distance, isHeadshot, weaponHash)
    local src = source
    if IsWhitelisted(src) then return end
    
    local stats = InitCombatStats(src)
    local name = GetPlayerName(src) or 'Unknown'
    local currentTime = os.time()
    
    stats.totalKills = stats.totalKills + 1
    
    if isHeadshot then
        stats.headshotKills = stats.headshotKills + 1
    end
    
    -- Track kill times for rapid kill detection
    table.insert(stats.killTimes, currentTime)
    while #stats.killTimes > 10 do
        table.remove(stats.killTimes, 1)
    end
    
    -- ═══════════════════════════════════════════════════════════
    -- ANALYSIS: RAPID KILLS (Triggerbot/Aimbot)
    -- ═══════════════════════════════════════════════════════════
    if #stats.killTimes >= 5 then
        local timeSpan = stats.killTimes[#stats.killTimes] - stats.killTimes[1]
        local killsPerMinute = (#stats.killTimes / math.max(1, timeSpan)) * 60
        
        -- Normal: 2-5 kills per minute max
        -- Cheater: 10+ kills per minute
        if killsPerMinute > 12 and timeSpan > 10 then
            stats.violations = stats.violations + 2
            print('[ANTICHEAT-SERVER] ⚡ ' .. name .. ' RAPID KILLS: ' .. string.format('%.1f', killsPerMinute) .. ' kills/min')
            
            if Config and Config.Webhooks and Config.Webhooks.anticheat then
                PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                    username = '🛡️ Anticheat System',
                    embeds = {{
                        title = '⚡ SERVER: RAPID KILLS',
                        description = '**' .. name .. '** is killing too fast!',
                        color = 16711680,
                        fields = {
                            { name = '👤 Player', value = '`' .. name .. '`', inline = true },
                            { name = '⚡ Kill Rate', value = '`' .. string.format('%.1f', killsPerMinute) .. ' kills/min`', inline = true },
                            { name = '⏱️ Time Span', value = '`' .. timeSpan .. ' seconds`', inline = true },
                        },
                        footer = { text = '🛡️ Server-Side Analysis • ' .. os.date('%Y-%m-%d %H:%M:%S') }
                    }}
                }), { ['Content-Type'] = 'application/json' })
            end
        end
    end
end)

-- Cleanup on disconnect
AddEventHandler('playerDropped', function()
    local src = source
    combatStats[src] = nil
end)

print('[ANTICHEAT] Server-Side Combat Analysis v2.0 loaded!')

