local adminCache = {}
local activeReports = {}
local reportId = 0
local dbReady = false

-- Check if Config is loaded
CreateThread(function()
    Wait(1000)
    if Config and Config.Webhooks then
        print('[wasteland_admin] Config loaded successfully!')
        print('[wasteland_admin] Main webhook: ' .. (Config.Webhooks.main or 'NOT SET'))
    else
        print('[wasteland_admin] ERROR: Config not loaded!')
    end
end)

-- Test webhook command (run in server console: testwebhook)
RegisterCommand('testwebhook', function(source)
    if source ~= 0 then return end -- Console only
    print('[wasteland_admin] Testing webhook...')
    if not Config or not Config.Webhooks then
        print('[wasteland_admin] ERROR: Config not loaded!')
        return
    end
    local webhook = Config.Webhooks.main
    if not webhook or webhook == '' then
        print('[wasteland_admin] No webhook configured!')
        return
    end
    print('[wasteland_admin] Sending to: ' .. string.sub(webhook, 1, 50) .. '...')
    PerformHttpRequest(webhook, function(statusCode, response)
        print('[wasteland_admin] Webhook test result - Status: ' .. tostring(statusCode))
        if response then print('[wasteland_admin] Response: ' .. tostring(response)) end
    end, 'POST', json.encode({
        username = 'Admin Panel Test',
        content = 'Test message from wasteland_admin!'
    }), { ['Content-Type'] = 'application/json' })
end, true)

-- MySQL wrapper functions using exports
local function MySQL_Query(query, params, cb)
    if cb then
        exports.oxmysql:execute(query, params or {}, cb)
    else
        return exports.oxmysql:executeSync(query, params or {})
    end
end

local function MySQL_Insert(query, params, cb)
    if cb then
        exports.oxmysql:insert(query, params or {}, cb)
    else
        return exports.oxmysql:insertSync(query, params or {})
    end
end

local function MySQL_Single(query, params, cb)
    if cb then
        exports.oxmysql:single(query, params or {}, cb)
    else
        return exports.oxmysql:singleSync(query, params or {})
    end
end

-- ============================================
-- ADVANCED IDENTIFIER SYSTEM (Anti-Spoof)
-- Collects ALL possible identifiers for banning
-- ============================================

-- Get specific identifier
local function GetPlayerLicense(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 8) == "license:" then return id end
    end
    return nil
end

local function GetPlayerLicense2(src)
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if string.sub(id, 1, 9) == "license2:" then return id end
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

-- Get ALL tokens (hardware IDs)
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

-- Get ALL identifiers as a table
local function GetAllIdentifiers(src)
    return {
        license = GetPlayerLicense(src),
        license2 = GetPlayerLicense2(src),
        discord = GetPlayerDiscord(src),
        steam = GetPlayerSteam(src),
        xbl = GetPlayerXbl(src),
        live = GetPlayerLive(src),
        fivem = GetPlayerFivem(src),
        ip = GetPlayerIP(src),
        tokens = GetPlayerTokens(src)
    }
end

-- Get admin group
local function GetAdminGroup(src)
    src = tonumber(src)
    if not src then return nil end
    if adminCache[src] then return adminCache[src] end
    
    for _, id in pairs(GetPlayerIdentifiers(src) or {}) do
        if Config.Admins[id] then
            adminCache[src] = Config.Admins[id]
            return Config.Admins[id]
        end
    end
    return nil
end

local function HasPermission(src, perm)
    local group = GetAdminGroup(src)
    return group and Config.AdminGroups[group] and Config.AdminGroups[group][perm] == true
end

-- Discord Webhook Logging
local function SendWebhook(webhookType, title, description, fields, color, imageUrl)
    local webhook = Config.Webhooks[webhookType] or Config.Webhooks.main
    if not webhook or webhook == '' then 
        print('[wasteland_admin] Webhook not configured for: ' .. tostring(webhookType))
        return 
    end
    
    print('[wasteland_admin] Sending webhook: ' .. tostring(webhookType) .. ' - ' .. tostring(title))
    
    local embed = {
        title = title,
        description = description,
        color = color or Config.WebhookColors.default,
        fields = fields or {},
        footer = { text = Config.ServerName .. ' • ' .. os.date('%Y-%m-%d %H:%M:%S') },
        timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }
    
    if imageUrl then
        embed.image = { url = imageUrl }
    end
    
    local payload = json.encode({
        username = 'Admin Panel',
        avatar_url = 'https://i.imgur.com/oBQXYQX.png',
        embeds = { embed }
    })
    
    PerformHttpRequest(webhook, function(statusCode, response, headers)
        if statusCode == 204 or statusCode == 200 then
            print('[wasteland_admin] Webhook sent successfully!')
        else
            print('[wasteland_admin] Webhook failed! Status: ' .. tostring(statusCode) .. ' Response: ' .. tostring(response))
        end
    end, 'POST', payload, { ['Content-Type'] = 'application/json' })
end

local function LogAction(src, action, webhookType, extraFields, imageUrl)
    local adminName = GetPlayerName(src) or 'Console'
    local group = GetAdminGroup(src) or 'unknown'
    
    if Config.LogActions then
        print(('[ADMIN][%s] %s (%s): %s'):format(group:upper(), adminName, src, action))
    end
    
    local fields = {
        { name = '👤 Admin', value = adminName, inline = true },
        { name = '🎖️ Rank', value = group:upper(), inline = true },
        { name = '🆔 Server ID', value = tostring(src), inline = true },
    }
    
    if extraFields then
        for _, f in ipairs(extraFields) do table.insert(fields, f) end
    end
    
    SendWebhook(webhookType or 'main', '📋 Admin Action', action, fields, Config.WebhookColors[webhookType] or Config.WebhookColors.default, imageUrl)
end

-- Initialize database
CreateThread(function()
    Wait(2000) -- Wait for oxmysql to be ready
    dbReady = true
    
    -- Create admin permissions table
    MySQL_Query([[
        CREATE TABLE IF NOT EXISTS ]] .. Config.AdminTable .. [[ (
            id INT AUTO_INCREMENT PRIMARY KEY,
            identifier VARCHAR(100) NOT NULL UNIQUE,
            admin_group VARCHAR(50) NOT NULL,
            added_by VARCHAR(100),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])
    
    -- Create bans table
    MySQL_Query([[
        CREATE TABLE IF NOT EXISTS ]] .. Config.BanTable .. [[ (
            id INT AUTO_INCREMENT PRIMARY KEY,
            license VARCHAR(100) NOT NULL,
            discord VARCHAR(100),
            steam VARCHAR(100),
            name VARCHAR(100),
            reason TEXT,
            admin VARCHAR(100),
            expiry BIGINT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX (license),
            INDEX (discord),
            INDEX (steam)
        )
    ]])
    
    -- Create logs table
    MySQL_Query([[
        CREATE TABLE IF NOT EXISTS admin_logs (
            id INT AUTO_INCREMENT PRIMARY KEY,
            log_type VARCHAR(50) NOT NULL,
            player_name VARCHAR(100),
            player_license VARCHAR(100),
            player_discord VARCHAR(100),
            target_name VARCHAR(100),
            target_license VARCHAR(100),
            details TEXT,
            coords VARCHAR(100),
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX (log_type),
            INDEX (player_license),
            INDEX (created_at)
        )
    ]])
    
    -- Load admins from database
    MySQL_Query('SELECT * FROM ' .. Config.AdminTable, {}, function(results)
        if results then
            for _, row in ipairs(results) do
                Config.Admins[row.identifier] = row.admin_group
            end
            print('[wasteland_admin] Loaded ' .. #results .. ' admins from database')
        end
    end)
end)

-- Log to database
local function LogToDatabase(logType, playerSrc, targetSrc, details, coords)
    if not dbReady then 
        print('[wasteland_admin] Database not ready, skipping log: ' .. logType)
        return 
    end
    
    local playerName = playerSrc and GetPlayerName(playerSrc) or nil
    local playerLicense = playerSrc and GetPlayerLicense(playerSrc) or nil
    local playerDiscord = playerSrc and GetPlayerDiscord(playerSrc) or nil
    local targetName = targetSrc and GetPlayerName(targetSrc) or nil
    local targetLicense = targetSrc and GetPlayerLicense(targetSrc) or nil
    local coordsStr = coords and string.format("%.2f, %.2f, %.2f", coords.x, coords.y, coords.z) or nil
    
    print('[wasteland_admin] Logging to database: ' .. logType .. ' - ' .. (details or 'no details'))
    
    MySQL_Insert('INSERT INTO admin_logs (log_type, player_name, player_license, player_discord, target_name, target_license, details, coords) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        logType, playerName, playerLicense, playerDiscord, targetName, targetLicense, details, coordsStr
    })
end

-- ============================================
-- BEAUTIFUL BAN SCREEN WITH ADAPTIVE CARD
-- Shows a nice card when banned player tries to connect
-- ============================================

-- Generate beautiful ban card
local function GenerateBanCard(playerName, reason, admin, banDate, expiry, banId, screenshotUrl)
    local expiryText = "PERMANENT"
    local expiryColor = "attention"
    
    if expiry then
        expiryText = os.date('%d/%m/%Y %H:%M', expiry)
        expiryColor = "warning"
    end
    
    local serverName = Config and Config.ServerName or "Wasteland Server"
    local banDateText = banDate and os.date('%d/%m/%Y %H:%M', banDate) or os.date('%d/%m/%Y %H:%M')
    
    local cardBody = {}
    
    -- Header compact
    table.insert(cardBody, {
        ["type"] = "TextBlock",
        ["text"] = "🛡️ AETHER ANTICHEAT • " .. serverName,
        ["weight"] = "Bolder",
        ["size"] = "Small",
        ["color"] = "Accent",
        ["horizontalAlignment"] = "Center"
    })
    
    -- Ban Title
    table.insert(cardBody, {
        ["type"] = "TextBlock",
        ["text"] = "⛔ YOU ARE BANNED",
        ["weight"] = "Bolder",
        ["size"] = "Medium",
        ["color"] = "Attention",
        ["horizontalAlignment"] = "Center",
        ["spacing"] = "Small"
    })
    
    -- All info in one compact line
    table.insert(cardBody, {
        ["type"] = "TextBlock",
        ["text"] = "👤 " .. (playerName or "Unknown") .. " • 🆔 #" .. tostring(banId or "N/A"),
        ["size"] = "Small",
        ["horizontalAlignment"] = "Center",
        ["spacing"] = "Small"
    })
    
    -- Reason compact
    table.insert(cardBody, {
        ["type"] = "TextBlock",
        ["text"] = "📝 " .. (reason or "No reason provided"),
        ["wrap"] = true,
        ["size"] = "Small",
        ["horizontalAlignment"] = "Center",
        ["spacing"] = "Small"
    })
    
    -- Dates in one line
    table.insert(cardBody, {
        ["type"] = "TextBlock",
        ["text"] = "📅 " .. banDateText .. " → ⏰ " .. expiryText,
        ["size"] = "Small",
        ["horizontalAlignment"] = "Center",
        ["spacing"] = "Small",
        ["color"] = expiryColor
    })
    
    -- Banned by
    table.insert(cardBody, {
        ["type"] = "TextBlock",
        ["text"] = "👮 " .. (admin or "ANTICHEAT"),
        ["size"] = "Small",
        ["isSubtle"] = true,
        ["horizontalAlignment"] = "Center",
        ["spacing"] = "None"
    })
    
    -- Appeal button (BEFORE screenshot)
    table.insert(cardBody, {
        ["type"] = "ActionSet",
        ["spacing"] = "Small",
        ["actions"] = {
            {
                ["type"] = "Action.OpenUrl",
                ["title"] = "💬 Appeal on Discord",
                ["url"] = Config and Config.DiscordInvite or "https://discord.gg/your-server",
                ["style"] = "positive"
            }
        }
    })
    
    -- Footer (BEFORE screenshot)
    table.insert(cardBody, {
        ["type"] = "TextBlock",
        ["text"] = "Aether Anticheat v4.0 • Coded by konpep",
        ["size"] = "Small",
        ["isSubtle"] = true,
        ["horizontalAlignment"] = "Center",
        ["spacing"] = "Small"
    })
    
    -- Screenshot (if available) - At the bottom, large
    if screenshotUrl and screenshotUrl ~= '' then
        table.insert(cardBody, {
            ["type"] = "TextBlock",
            ["text"] = "📸 EVIDENCE",
            ["weight"] = "Bolder",
            ["size"] = "Small",
            ["color"] = "Warning",
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "Medium"
        })
        
        table.insert(cardBody, {
            ["type"] = "Image",
            ["url"] = screenshotUrl,
            ["size"] = "Stretch",
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "Small"
        })
    end
    
    local card = {
        ["type"] = "AdaptiveCard",
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ["version"] = "1.5",
        ["body"] = cardBody
    }
    
    return json.encode(card)
end

-- ============================================
-- TOS (TERMS OF SERVICE) CARD
-- Shows when player hasn't accepted TOS yet
-- ============================================
local function GenerateTOSCard(playerName, serverName)
    -- Get rules from config or use defaults
    local rules = Config and Config.TOS and Config.TOS.rules or {
        "Not use any cheats, hacks, or exploits",
        "Not use any mod menus or injectors",
        "Not exploit bugs or glitches",
        "Respect other players and staff",
        "Follow all server rules"
    }
    
    -- Build rules items
    local rulesItems = {
        {
            ["type"] = "TextBlock",
            ["text"] = "By joining this server, you agree to:",
            ["size"] = "Small",
            ["wrap"] = true
        }
    }
    
    for i, rule in ipairs(rules) do
        table.insert(rulesItems, {
            ["type"] = "TextBlock",
            ["text"] = "✅ " .. rule,
            ["size"] = "Small",
            ["spacing"] = i == 1 and "Small" or "None"
        })
    end
    
    local card = {
        ["type"] = "AdaptiveCard",
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ["version"] = "1.5",
        ["body"] = {
            -- Header
            {
                ["type"] = "Container",
                ["spacing"] = "Medium",
                ["items"] = {
                    {
                        ["type"] = "TextBlock",
                        ["text"] = "🛡️ AETHER ANTICHEAT",
                        ["weight"] = "Bolder",
                        ["size"] = "Medium",
                        ["color"] = "Accent",
                        ["horizontalAlignment"] = "Center"
                    },
                    {
                        ["type"] = "TextBlock",
                        ["text"] = serverName or "Server",
                        ["spacing"] = "None",
                        ["size"] = "Small",
                        ["isSubtle"] = true,
                        ["horizontalAlignment"] = "Center"
                    }
                }
            },
            -- Divider
            {
                ["type"] = "TextBlock",
                ["text"] = "─────────────────────────",
                ["horizontalAlignment"] = "Center",
                ["color"] = "Accent",
                ["size"] = "Small",
                ["spacing"] = "Small"
            },
            -- Welcome
            {
                ["type"] = "TextBlock",
                ["text"] = "👋 Welcome, " .. playerName .. "!",
                ["weight"] = "Bolder",
                ["size"] = "Medium",
                ["horizontalAlignment"] = "Center",
                ["spacing"] = "Medium"
            },
            -- TOS Title
            {
                ["type"] = "TextBlock",
                ["text"] = "📜 TERMS OF SERVICE",
                ["weight"] = "Bolder",
                ["color"] = "Warning",
                ["horizontalAlignment"] = "Center",
                ["spacing"] = "Medium"
            },
            -- TOS Content (Dynamic from config)
            {
                ["type"] = "Container",
                ["style"] = "emphasis",
                ["spacing"] = "Small",
                ["items"] = rulesItems
            },
            -- Warning
            {
                ["type"] = "Container",
                ["style"] = "attention",
                ["spacing"] = "Medium",
                ["items"] = {
                    {
                        ["type"] = "TextBlock",
                        ["text"] = "⚠️ WARNING",
                        ["weight"] = "Bolder",
                        ["color"] = "Attention",
                        ["horizontalAlignment"] = "Center"
                    },
                    {
                        ["type"] = "TextBlock",
                        ["text"] = "Our anticheat monitors all players. Cheating = PERMANENT BAN.",
                        ["size"] = "Small",
                        ["wrap"] = true,
                        ["horizontalAlignment"] = "Center"
                    }
                }
            },
            -- Checkbox
            {
                ["type"] = "Input.Toggle",
                ["id"] = "acceptTOS",
                ["title"] = "I agree to the Terms of Service",
                ["spacing"] = "Medium"
            },
            -- Submit Button
            {
                ["type"] = "ActionSet",
                ["spacing"] = "Medium",
                ["actions"] = {
                    {
                        ["type"] = "Action.Submit",
                        ["title"] = "✅ Accept & Join",
                        ["style"] = "positive",
                        ["id"] = "accept"
                    }
                }
            },
            -- Footer
            {
                ["type"] = "TextBlock",
                ["text"] = "Aether Anticheat v4.0 • Coded by konpep",
                ["size"] = "Small",
                ["isSubtle"] = true,
                ["horizontalAlignment"] = "Center",
                ["spacing"] = "Small"
            }
        }
    }
    
    return json.encode(card)
end

-- ============================================
-- ADVANCED BAN CHECK (Anti-Spoof)
-- Checks ALL identifiers + Hardware Tokens
-- ============================================

-- Helper: Find which identifier matched the ban
local function GetMatchedIdentifier(ban, ids)
    if ban.license and ban.license == ids.license then return "License" end
    if ban.license2 and ban.license2 == ids.license2 then return "License2" end
    if ban.discord and ban.discord == ids.discord then return "Discord" end
    if ban.steam and ban.steam == ids.steam then return "Steam" end
    if ban.xbl and ban.xbl == ids.xbl then return "Xbox Live" end
    if ban.live and ban.live == ids.live then return "Live" end
    if ban.fivem and ban.fivem == ids.fivem then return "FiveM" end
    if ban.ip and ban.ip == ids.ip then return "IP Address" end
    if ban.tokens then
        for _, token in ipairs(ids.tokens or {}) do
            if string.find(ban.tokens, token) then
                return "Hardware Token"
            end
        end
    end
    return "Unknown"
end

-- ============================================
-- IDENTIFIER TRACKING SYSTEM (Anti-Spoof)
-- Tracks all player identifiers and detects changes
-- ============================================
local function TrackPlayerIdentifiers(name, ids)
    local tokensStr = table.concat(ids.tokens or {}, ',')
    
    -- Check if we have a record for any of these identifiers
    local query = [[
        SELECT * FROM anticheat_identifiers 
        WHERE license = ? OR license2 = ? OR discord = ? OR steam = ? OR fivem = ?
        LIMIT 1
    ]]
    
    MySQL_Single(query, {
        ids.license or '', ids.license2 or '', ids.discord or '', ids.steam or '', ids.fivem or ''
    }, function(existing)
        if existing then
            -- Player exists, check for changes
            local changes = {}
            local isSuspicious = false
            
            -- Check each identifier for changes
            if existing.license and ids.license and existing.license ~= ids.license then
                table.insert(changes, {type = 'license', old = existing.license, new = ids.license})
                isSuspicious = true
            end
            if existing.license2 and ids.license2 and existing.license2 ~= ids.license2 then
                table.insert(changes, {type = 'license2', old = existing.license2, new = ids.license2})
                isSuspicious = true
            end
            if existing.discord and ids.discord and existing.discord ~= ids.discord then
                table.insert(changes, {type = 'discord', old = existing.discord, new = ids.discord})
            end
            if existing.steam and ids.steam and existing.steam ~= ids.steam then
                table.insert(changes, {type = 'steam', old = existing.steam, new = ids.steam})
                isSuspicious = true
            end
            if existing.fivem and ids.fivem and existing.fivem ~= ids.fivem then
                table.insert(changes, {type = 'fivem', old = existing.fivem, new = ids.fivem})
                isSuspicious = true
            end
            if existing.ip and ids.ip and existing.ip ~= ids.ip then
                table.insert(changes, {type = 'ip', old = existing.ip, new = ids.ip})
                -- IP changes are normal, not suspicious alone
            end
            
            -- Find what identifier matched
            local matchedBy = 'unknown'
            local matchedValue = ''
            if existing.license == ids.license then matchedBy = 'license'; matchedValue = ids.license or ''
            elseif existing.discord == ids.discord then matchedBy = 'discord'; matchedValue = ids.discord or ''
            elseif existing.steam == ids.steam then matchedBy = 'steam'; matchedValue = ids.steam or ''
            elseif existing.fivem == ids.fivem then matchedBy = 'fivem'; matchedValue = ids.fivem or ''
            end
            
            -- Log changes
            if #changes > 0 then
                for _, change in ipairs(changes) do
                    -- Insert change log
                    exports.oxmysql:insert([[
                        INSERT INTO anticheat_id_changes 
                        (name, identifier_type, old_value, new_value, matched_by, matched_value, is_suspicious) 
                        VALUES (?, ?, ?, ?, ?, ?, ?)
                    ]], {
                        name, change.type, change.old, change.new, matchedBy, matchedValue, isSuspicious and 1 or 0
                    })
                end
                
                -- Send webhook for suspicious changes
                if isSuspicious then
                    local changesList = ""
                    for _, change in ipairs(changes) do
                        changesList = changesList .. "• **" .. change.type .. "**: `" .. (change.old or 'N/A') .. "` → `" .. (change.new or 'N/A') .. "`\n"
                    end
                    
                    SendWebhook('anticheat', '🔄 IDENTIFIER CHANGE DETECTED', '**' .. name .. '** has changed identifiers!', {
                        { name = '👤 Player', value = name, inline = true },
                        { name = '🔍 Matched By', value = matchedBy, inline = true },
                        { name = '⚠️ Suspicious', value = isSuspicious and 'YES' or 'No', inline = true },
                        { name = '📝 Changes', value = changesList, inline = false },
                    }, isSuspicious and 16711680 or 16776960)
                    
                    print('[ANTICHEAT] ⚠️ SPOOF DETECTED: ' .. name .. ' changed ' .. #changes .. ' identifiers!')
                end
            end
            
            -- Update existing record with new/additional identifiers
            exports.oxmysql:execute([[
                UPDATE anticheat_identifiers SET
                    name = ?,
                    license = COALESCE(?, license),
                    license2 = COALESCE(?, license2),
                    discord = COALESCE(?, discord),
                    steam = COALESCE(?, steam),
                    xbl = COALESCE(?, xbl),
                    live = COALESCE(?, live),
                    fivem = COALESCE(?, fivem),
                    ip = ?,
                    tokens = CONCAT(COALESCE(tokens, ''), IF(tokens IS NULL OR tokens = '', '', ','), ?),
                    times_connected = times_connected + 1,
                    last_seen = NOW()
                WHERE id = ?
            ]], {
                name, ids.license, ids.license2, ids.discord, ids.steam, 
                ids.xbl, ids.live, ids.fivem, ids.ip, tokensStr, existing.id
            })
        else
            -- New player, insert record
            exports.oxmysql:insert([[
                INSERT INTO anticheat_identifiers 
                (name, license, license2, discord, steam, xbl, live, fivem, ip, tokens) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ]], {
                name, ids.license, ids.license2, ids.discord, ids.steam,
                ids.xbl, ids.live, ids.fivem, ids.ip, tokensStr
            })
            
            print('[ANTICHEAT] New player registered: ' .. name)
        end
    end)
end

local function CheckPlayerBanned(src, callback)
    local ids = GetAllIdentifiers(src)
    local tokens = ids.tokens or {}
    local tokensStr = table.concat(tokens, ',')
    
    -- Build comprehensive ban check query
    local query = [[
        SELECT * FROM ]] .. Config.BanTable .. [[ 
        WHERE (expiry IS NULL OR expiry > ?) 
        AND (
            (license IS NOT NULL AND license = ?) OR
            (license2 IS NOT NULL AND license2 = ?) OR
            (discord IS NOT NULL AND discord = ?) OR
            (steam IS NOT NULL AND steam = ?) OR
            (xbl IS NOT NULL AND xbl = ?) OR
            (live IS NOT NULL AND live = ?) OR
            (fivem IS NOT NULL AND fivem = ?) OR
            (ip IS NOT NULL AND ip = ?)
    ]]
    
    local params = {
        os.time(),
        ids.license or '',
        ids.license2 or '',
        ids.discord or '',
        ids.steam or '',
        ids.xbl or '',
        ids.live or '',
        ids.fivem or '',
        ids.ip or ''
    }
    
    -- Check each token
    for _, token in ipairs(tokens) do
        query = query .. " OR (tokens IS NOT NULL AND tokens LIKE ?)"
        table.insert(params, '%' .. token .. '%')
    end
    
    query = query .. ") LIMIT 1"
    
    MySQL_Single(query, params, function(ban)
        callback(ban, ids)
    end)
end

-- Connect/Disconnect Logging
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    Wait(0)
    deferrals.update('🔍 Collecting identifiers...')
    
    local ids = GetAllIdentifiers(src)
    
    if not ids.license then 
        deferrals.done('❌ Could not verify your identity. Please restart FiveM.')
        return 
    end
    
    Wait(200)
    deferrals.update('🛡️ Checking ban database...')
    Wait(100)
    
    -- Simple ban check (SYNC) - check main identifiers only
    local ban = nil
    local success, err = pcall(function()
        print('[BAN CHECK] ========================================')
        print('[BAN CHECK] Player: ' .. name)
        print('[BAN CHECK] License: ' .. tostring(ids.license))
        print('[BAN CHECK] Discord: ' .. tostring(ids.discord))
        print('[BAN CHECK] Steam: ' .. tostring(ids.steam))
        print('[BAN CHECK] Current time: ' .. tostring(os.time()))
        print('[BAN CHECK] Table: ' .. tostring(Config.BanTable))
        
        -- First, check if ANY bans exist for this license (ignore expiry)
        local testBan = exports.oxmysql:singleSync(
            'SELECT * FROM admin_bans WHERE license = ? LIMIT 1',
            {ids.license or ''}
        )
        
        if testBan then
            print('[BAN CHECK] 🔍 Found ban record in DB!')
            print('[BAN CHECK] Ban ID: ' .. tostring(testBan.id))
            print('[BAN CHECK] Ban License: ' .. tostring(testBan.license))
            print('[BAN CHECK] Ban Expiry: ' .. tostring(testBan.expiry))
            print('[BAN CHECK] Ban Reason: ' .. tostring(testBan.reason))
            
            -- Check if ban is still active
            if testBan.expiry == nil or testBan.expiry > os.time() then
                print('[BAN CHECK] ✅ Ban is ACTIVE!')
                ban = testBan
            else
                print('[BAN CHECK] ⏰ Ban has EXPIRED (expiry: ' .. tostring(testBan.expiry) .. ' < now: ' .. tostring(os.time()) .. ')')
            end
        else
            print('[BAN CHECK] ❌ No ban found for license: ' .. tostring(ids.license))
        end
        
        print('[BAN CHECK] ========================================')
    end)
    
    if not success then
        print('[BAN CHECK] ❌ DATABASE ERROR: ' .. tostring(err))
        -- Continue anyway - don't block player for DB error
    end
    
    if ban then
        -- Get screenshot URL from admin_bans (saved by discord_screenshots.py)
        local screenshotUrl = ban.screenshot_url
        
        if screenshotUrl then
            print('[BAN CARD] ✅ Found screenshot URL: ' .. screenshotUrl)
        else
            print('[BAN CARD] No screenshot URL saved yet')
        end
        
        -- Generate ban card with screenshot
        local banCard = GenerateBanCard(
            ban.name or name,
            ban.reason or 'Violation of server rules',
            ban.admin or 'ANTICHEAT',
            ban.created_at and os.time() or os.time(),
            ban.expiry,
            ban.id,
            screenshotUrl
        )
        
        deferrals.presentCard(banCard, function(data, rawData)
            deferrals.done('You are banned from this server.')
        end)
        return
    end
    
    -- Not banned - Track identifiers for anti-spoof
    TrackPlayerIdentifiers(name, ids)
    
    -- Check TOS
    local tosEnabled = Config and Config.TOS and Config.TOS.enabled
    
    if not tosEnabled then
        deferrals.update('✅ Welcome, ' .. name .. '!')
        Wait(500)
        deferrals.done()
        LogToDatabase('connect', src, nil, 'Player connected')
        SendWebhook('connects', '🟢 Player Connected', '**' .. name .. '** joined the server', {
            { name = '👤 Player', value = name, inline = true },
            { name = '🔑 License', value = ids.license or 'N/A', inline = true },
        }, 3066993)
        return
    end
    
    deferrals.update('📜 Checking Terms of Service...')
    Wait(100)
    
    local tosRecord = nil
    pcall(function()
        tosRecord = exports.oxmysql:singleSync('SELECT * FROM anticheat_tos WHERE license = ?', { ids.license })
    end)
    
    print('[TOS DEBUG] License: ' .. tostring(ids.license))
    print('[TOS DEBUG] Record found: ' .. tostring(tosRecord ~= nil))
    if tosRecord then
        print('[TOS DEBUG] Accepted value: ' .. tostring(tosRecord.accepted) .. ' (type: ' .. type(tosRecord.accepted) .. ')')
    end
    
    if tosRecord and (tosRecord.accepted == 1 or tosRecord.accepted == '1' or tosRecord.accepted == true) then
        deferrals.update('✅ Welcome back, ' .. name .. '!')
        Wait(500)
        deferrals.done()
        
        LogToDatabase('connect', src, nil, 'Player connected')
        SendWebhook('connects', '🟢 Player Connected', '**' .. name .. '** joined the server', {
            { name = '👤 Player', value = name, inline = true },
            { name = '🔑 License', value = ids.license or 'N/A', inline = true },
        }, 3066993)
    else
        local serverName = Config and Config.ServerName or "Server"
        local tosCard = GenerateTOSCard(name, serverName)
        
        deferrals.presentCard(tosCard, function(data, rawData)
            if data and data.acceptTOS == "true" then
                exports.oxmysql:insert('INSERT INTO anticheat_tos (license, discord, steam, name, accepted, accepted_at) VALUES (?, ?, ?, ?, 1, NOW()) ON DUPLICATE KEY UPDATE accepted = 1, accepted_at = NOW()', {
                    ids.license, ids.discord, ids.steam, name
                })
                
                deferrals.update('✅ Welcome, ' .. name .. '!')
                Wait(500)
                deferrals.done()
                
                LogToDatabase('connect', src, nil, 'Player connected (TOS accepted)')
                SendWebhook('connects', '🟢 New Player', '**' .. name .. '** accepted TOS and joined', {
                    { name = '👤 Player', value = name, inline = true },
                    { name = '📜 TOS', value = 'Accepted', inline = true },
                }, 3066993)
            else
                deferrals.done('❌ You must accept the Terms of Service to join.')
            end
        end)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local name = GetPlayerName(src) or 'Unknown'
    local license = GetPlayerLicense(src)
    
    adminCache[src] = nil
    
    LogToDatabase('disconnect', src, nil, 'Disconnected: ' .. reason)
    SendWebhook('connects', '🔴 Player Disconnected', '**' .. name .. '** left the server', {
        { name = '👤 Player', value = name, inline = true },
        { name = '📝 Reason', value = reason or 'Unknown', inline = true },
        { name = '🔑 License', value = license or 'N/A', inline = true },
    }, 15158332)
end)

-- Kill Logging
RegisterNetEvent('wasteland_admin:logKill', function(targetId, weapon, headshot)
    local src = source
    local killerName = GetPlayerName(src) or 'Unknown'
    local victimName = targetId and GetPlayerName(targetId) or 'Unknown'
    local killerPed = GetPlayerPed(src)
    local coords = GetEntityCoords(killerPed)
    
    local details = string.format('%s killed %s with %s%s', killerName, victimName, weapon or 'Unknown', headshot and ' (Headshot)' or '')
    LogToDatabase('kill', src, targetId, details, coords)
    
    SendWebhook('kills', '💀 Player Kill', details, {
        { name = '🔫 Killer', value = killerName, inline = true },
        { name = '☠️ Victim', value = victimName, inline = true },
        { name = '🔧 Weapon', value = weapon or 'Unknown', inline = true },
        { name = '🎯 Headshot', value = headshot and 'Yes' or 'No', inline = true },
        { name = '📍 Location', value = string.format("%.1f, %.1f, %.1f", coords.x, coords.y, coords.z), inline = true },
    }, 15158332)
end)

-- Screenshot functionality - Simple version
RegisterNetEvent('wasteland_admin:takeScreenshot', function(targetId)
    local src = source
    if not GetAdminGroup(src) then return end
    
    targetId = tonumber(targetId) or src
    local targetName = GetPlayerName(targetId) or 'Unknown'
    local adminName = GetPlayerName(src) or 'Unknown'
    
    print('[SCREENSHOT] Requested for ' .. targetName .. ' by ' .. adminName)
    
    if GetResourceState('screenshot-basic') ~= 'started' then
        print('[SCREENSHOT] ERROR: screenshot-basic not running!')
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'screenshot-basic not running!' })
        return
    end
    
    TriggerClientEvent('ox_lib:notify', src, { type = 'info', description = 'Taking screenshot...' })
    
    exports['screenshot-basic']:requestClientScreenshot(targetId, {
        encoding = 'jpg',
        quality = 0.8
    }, function(err, data)
        if err ~= false or not data then
            print('[SCREENSHOT] Failed: ' .. tostring(err))
            TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Screenshot failed!' })
            return
        end
        
        print('[SCREENSHOT] Success! Data length: ' .. tostring(#data))
        
        -- Show in admin UI
        TriggerClientEvent('wasteland_admin:screenshotResult', src, data, targetName)
        TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Screenshot taken!' })
        
        -- Save to database
        local adminLicense = GetPlayerLicense(src)
        local targetLicense = GetPlayerLicense(targetId)
        exports.oxmysql:insert('INSERT INTO admin_logs (log_type, player_name, player_license, target_name, target_license, details, screenshot) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            'screenshot', adminName, adminLicense, targetName, targetLicense, 'Screenshot by ' .. adminName, data
        })
        
        -- Get webhook
        local webhook = Config and Config.Webhooks and (Config.Webhooks.screenshots or Config.Webhooks.anticheat or Config.Webhooks.main)
        if not webhook then 
            print('[SCREENSHOT] No webhook configured')
            return 
        end
        
        -- Send simple notification to Discord (Python script will send the actual image)
        print('[SCREENSHOT] Sending notification to Discord (image will be sent by Python script)')
        PerformHttpRequest(webhook, function(c) print('[SCREENSHOT] Discord: ' .. tostring(c)) end, 'POST', json.encode({
            embeds = {{
                title = '📸 Screenshot: ' .. targetName,
                description = 'By: ' .. adminName .. '\nID: ' .. targetId,
                color = 3447003,
                footer = { text = '📷 Image will follow via Python script • ' .. os.date('%Y-%m-%d %H:%M:%S') }
            }}
        }), { ['Content-Type'] = 'application/json' })
    end)
end)

-- Check permission
RegisterNetEvent('wasteland_admin:checkPermission', function()
    local src = source
    local group = GetAdminGroup(src)
    local perms = group and Config.AdminGroups[group] or nil
    TriggerClientEvent('wasteland_admin:permissionResult', src, group ~= nil, group, perms)
end)

-- Get players with more info
RegisterNetEvent('wasteland_admin:getPlayers', function()
    local src = source
    if not GetAdminGroup(src) then return end
    
    local players = {}
    for _, pid in ipairs(GetPlayers()) do
        local ped = GetPlayerPed(pid)
        local coords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(ped, false)
        table.insert(players, {
            id = tonumber(pid),
            name = GetPlayerName(pid),
            ping = GetPlayerPing(pid),
            health = GetEntityHealth(ped),
            armor = GetPedArmour(ped),
            coords = { x = coords.x, y = coords.y, z = coords.z },
            inVehicle = vehicle ~= 0,
            license = GetPlayerLicense(tonumber(pid)),
            discord = GetPlayerDiscord(tonumber(pid))
        })
    end
    TriggerClientEvent('wasteland_admin:updatePlayers', src, players)
end)

-- Get items
-- ============================================
-- INVENTORY SYSTEM DETECTION (ESX / OX)
-- ============================================
local InventorySystem = {
    type = 'none', -- 'ox', 'esx', 'none'
    ESX = nil
}

-- Detect inventory system on resource start
CreateThread(function()
    Wait(1000)
    
    local configSetting = Config.InventorySystem or 'auto'
    
    if configSetting == 'none' then
        -- Disabled by config
        InventorySystem.type = 'none'
        print('[ADMIN] Inventory System: DISABLED (Config.InventorySystem = none)')
    elseif configSetting == 'ox' then
        -- Force OX
        if GetResourceState('ox_inventory') == 'started' then
            InventorySystem.type = 'ox'
            print('[ADMIN] Inventory System: OX Inventory (forced by config)')
        else
            print('[ADMIN] ^1ERROR: Config.InventorySystem = ox but ox_inventory is not running!^0')
            InventorySystem.type = 'none'
        end
    elseif configSetting == 'esx' then
        -- Force ESX
        if GetResourceState('es_extended') == 'started' then
            InventorySystem.type = 'esx'
            InventorySystem.ESX = exports['es_extended']:getSharedObject()
            print('[ADMIN] Inventory System: ESX (forced by config)')
        else
            print('[ADMIN] ^1ERROR: Config.InventorySystem = esx but es_extended is not running!^0')
            InventorySystem.type = 'none'
        end
    else
        -- Auto-detect (default)
        if GetResourceState('ox_inventory') == 'started' then
            InventorySystem.type = 'ox'
            print('[ADMIN] Inventory System: OX Inventory (auto-detected)')
        elseif GetResourceState('es_extended') == 'started' then
            InventorySystem.type = 'esx'
            InventorySystem.ESX = exports['es_extended']:getSharedObject()
            print('[ADMIN] Inventory System: ESX (auto-detected)')
        else
            print('[ADMIN] Inventory System: None detected')
            InventorySystem.type = 'none'
        end
    end
end)

-- Helper function to get inventory system type
local function GetInventoryType()
    return InventorySystem.type
end

-- Export for other scripts
exports('GetInventoryType', GetInventoryType)

RegisterNetEvent('wasteland_admin:getItems', function()
    local src = source
    if not HasPermission(src, 'giveItem') then return end
    
    local items = {}
    local invType = GetInventoryType()
    
    if invType == 'ox' then
        for name, data in pairs(exports.ox_inventory:Items() or {}) do
            table.insert(items, { name = name, label = data.label, system = 'OX' })
        end
    elseif invType == 'esx' and InventorySystem.ESX then
        -- ESX items from database or shared items
        local esxItems = InventorySystem.ESX.GetItems()
        if esxItems then
            for name, data in pairs(esxItems) do
                table.insert(items, { name = name, label = data.label or name, system = 'ESX' })
            end
        end
    end
    
    table.sort(items, function(a, b) return (a.label or a.name) < (b.label or b.name) end)
    TriggerClientEvent('wasteland_admin:itemsList', src, items)
end)

-- Give item (supports ESX and OX)
RegisterNetEvent('wasteland_admin:giveItem', function(targetId, item, count)
    local src = source
    if not HasPermission(src, 'giveItem') then return end
    
    targetId = tonumber(targetId)
    count = tonumber(count) or 1
    local invType = GetInventoryType()
    local success = false
    
    if invType == 'ox' and targetId then
        exports.ox_inventory:AddItem(targetId, item, count)
        success = true
    elseif invType == 'esx' and InventorySystem.ESX and targetId then
        local xPlayer = InventorySystem.ESX.GetPlayerFromId(targetId)
        if xPlayer then
            xPlayer.addInventoryItem(item, count)
            success = true
        end
    end
    
    if success then
        LogAction(src, 'Gave **' .. count .. 'x ' .. item .. '** to ' .. (GetPlayerName(targetId) or targetId) .. ' [' .. invType:upper() .. ']', 'spawn', {
            { name = '🎯 Target', value = GetPlayerName(targetId) or 'Unknown', inline = true },
            { name = '📦 Item', value = item, inline = true },
            { name = '🔢 Amount', value = tostring(count), inline = true },
            { name = '📋 System', value = invType:upper(), inline = true },
        })
        LogToDatabase('give_item', src, targetId, item .. ' x' .. count .. ' [' .. invType:upper() .. ']')
    end
end)

-- Teleport
RegisterNetEvent('wasteland_admin:teleportToPlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'teleport') then return end
    
    local targetPed = GetPlayerPed(targetId)
    if targetPed then
        TriggerClientEvent('wasteland_admin:teleportTo', src, GetEntityCoords(targetPed))
        LogAction(src, 'Teleported to **' .. (GetPlayerName(targetId) or targetId) .. '**', 'teleport')
    end
end)

-- Bring
RegisterNetEvent('wasteland_admin:bringPlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'bring') then return end
    
-- Notify anticheat to ignore teleport detection for this player
    TriggerClientEvent('anticheat:adminActionProtection', targetId, 'bring', 5000)
    
    TriggerClientEvent('wasteland_admin:teleportTo', targetId, GetEntityCoords(GetPlayerPed(src)))
    LogAction(src, 'Brought **' .. (GetPlayerName(targetId) or targetId) .. '**', 'teleport')
end)

-- Kick
RegisterNetEvent('wasteland_admin:kickPlayer', function(targetId, reason)
    local src = source
    if not HasPermission(src, 'kick') then return end
    
    local targetName = GetPlayerName(targetId) or 'Unknown'
    local targetLicense = GetPlayerLicense(targetId)
    
    LogToDatabase('kick', src, targetId, reason or 'No reason')
    DropPlayer(targetId, reason or 'Kicked by admin')
    
    LogAction(src, 'Kicked **' .. targetName .. '**', 'kicks', {
        { name = '🎯 Player', value = targetName, inline = true },
        { name = '🔑 License', value = targetLicense or 'N/A', inline = true },
        { name = '📝 Reason', value = reason or 'No reason', inline = false },
    })
end)

-- Ban
RegisterNetEvent('wasteland_admin:banPlayer', function(targetId, reason, duration)
    local src = source
    if not HasPermission(src, 'ban') then return end
    
    local targetName = GetPlayerName(targetId) or 'Unknown'
    local license = GetPlayerLicense(targetId)
    local discord = GetPlayerDiscord(targetId)
    local steam = GetPlayerSteam(targetId)
    
    if license then
        local expiry = duration and duration > 0 and (os.time() + duration * 60) or nil
        
        MySQL_Insert('INSERT INTO ' .. Config.BanTable .. ' (license, discord, steam, name, reason, admin, expiry) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            license, discord, steam, targetName, reason or 'No reason', GetPlayerName(src), expiry
        })
        
        LogToDatabase('ban', src, targetId, reason or 'No reason')
        DropPlayer(targetId, 'Banned: ' .. (reason or 'No reason'))
        
        local durationText = expiry and (duration .. ' minutes') or 'Permanent'
        LogAction(src, 'Banned **' .. targetName .. '**', 'bans', {
            { name = '🎯 Player', value = targetName, inline = true },
            { name = '⏱️ Duration', value = durationText, inline = true },
            { name = '📝 Reason', value = reason or 'No reason', inline = false },
            { name = '🔑 License', value = license or 'N/A', inline = false },
        })
    end
end)

-- Freeze
RegisterNetEvent('wasteland_admin:freezePlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'freeze') then return end
    
    -- Notify anticheat to ignore checks for this player
    TriggerClientEvent('anticheat:adminActionProtection', targetId, 'freeze', 5000)
    
    TriggerClientEvent('wasteland_admin:freeze', targetId)
    LogAction(src, 'Froze **' .. (GetPlayerName(targetId) or targetId) .. '**')
end)

-- Weather
RegisterNetEvent('wasteland_admin:setWeather', function(weather)
    local src = source
    if not HasPermission(src, 'setWeather') then return end
    TriggerClientEvent('wasteland_admin:syncWeather', -1, weather)
    LogAction(src, 'Set weather to **' .. weather .. '**')
end)

-- Time
RegisterNetEvent('wasteland_admin:setTime', function(hour, minute)
    local src = source
    if not HasPermission(src, 'setTime') then return end
    TriggerClientEvent('wasteland_admin:syncTime', -1, hour, minute)
    LogAction(src, 'Set time to **' .. hour .. ':' .. (minute < 10 and '0' or '') .. minute .. '**')
end)

-- Revive
RegisterNetEvent('wasteland_admin:revivePlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'revive') then return end
    
    -- Notify anticheat to ignore self-revive/heal detection for this player
    TriggerClientEvent('anticheat:adminActionProtection', targetId, 'revive', 10000)
    
    TriggerClientEvent('wasteland_admin:revive', targetId)
    LogAction(src, 'Revived **' .. (GetPlayerName(targetId) or targetId) .. '**')
end)

-- Announce
RegisterNetEvent('wasteland_admin:announce', function(message)
    local src = source
    if not HasPermission(src, 'announce') then return end
    TriggerClientEvent('chat:addMessage', -1, { color = {255, 200, 0}, args = {'[ADMIN]', message} })
    LogAction(src, 'Announced: **' .. message .. '**')
end)

-- Spectate
RegisterNetEvent('wasteland_admin:spectatePlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'spectate') then return end
    
    targetId = tonumber(targetId)
    if targetId and GetPlayerName(targetId) then
        local targetPed = GetPlayerPed(targetId)
        local coords = GetEntityCoords(targetPed)
        TriggerClientEvent('wasteland_admin:startSpectate', src, targetId, coords)
        LogAction(src, 'Started spectating **' .. GetPlayerName(targetId) .. '**')
    end
end)

-- Get admins
RegisterNetEvent('wasteland_admin:getAdmins', function()
    local src = source
    if not HasPermission(src, 'managePerms') then return end
    
    local admins = {}
    for id, group in pairs(Config.Admins) do
        table.insert(admins, { license = id, group = group })
    end
    TriggerClientEvent('wasteland_admin:adminsList', src, admins)
end)

-- Set admin
RegisterNetEvent('wasteland_admin:setAdmin', function(identifier, group)
    local src = source
    if not HasPermission(src, 'managePerms') then return end
    if not group or not Config.AdminGroups[group] then return end
    
    local serverId = tonumber(identifier)
    local saveId, targetName
    
    if serverId and GetPlayerName(serverId) then
        targetName = GetPlayerName(serverId)
        saveId = GetPlayerDiscord(serverId) or GetPlayerLicense(serverId)
        if saveId then
            adminCache[serverId] = group
            TriggerClientEvent('wasteland_admin:permissionResult', serverId, true, group, Config.AdminGroups[group])
        end
    else
        saveId = identifier
        targetName = identifier
    end
    
    if saveId then
        Config.Admins[saveId] = group
        MySQL_Query('INSERT INTO ' .. Config.AdminTable .. ' (identifier, admin_group, added_by) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE admin_group = ?', {
            saveId, group, GetPlayerName(src), group
        })
        
        LogAction(src, 'Set **' .. (targetName or saveId) .. '** as **' .. group:upper() .. '**', 'permissions', {
            { name = '🎯 Target', value = targetName or 'Unknown', inline = true },
            { name = '🎖️ New Rank', value = group:upper(), inline = true },
            { name = '🔑 Identifier', value = saveId, inline = false },
        })
    end
    
    Wait(100)
    local admins = {}
    for id, grp in pairs(Config.Admins) do table.insert(admins, { license = id, group = grp }) end
    TriggerClientEvent('wasteland_admin:adminsList', src, admins)
end)

-- Remove admin
RegisterNetEvent('wasteland_admin:removeAdmin', function(identifier)
    local src = source
    if not HasPermission(src, 'managePerms') then return end
    
    Config.Admins[identifier] = nil
    MySQL_Query('DELETE FROM ' .. Config.AdminTable .. ' WHERE identifier = ?', { identifier })
    
    for _, pid in ipairs(GetPlayers()) do
        for _, id in pairs(GetPlayerIdentifiers(tonumber(pid)) or {}) do
            if id == identifier then
                adminCache[tonumber(pid)] = nil
                TriggerClientEvent('wasteland_admin:permissionResult', tonumber(pid), false, nil, nil)
            end
        end
    end
    
    LogAction(src, 'Removed admin **' .. identifier .. '**', 'permissions')
    
    Wait(100)
    local admins = {}
    for id, grp in pairs(Config.Admins) do table.insert(admins, { license = id, group = grp }) end
    TriggerClientEvent('wasteland_admin:adminsList', src, admins)
end)

-- Open inventory (view other player's inventory) - Supports ESX and OX
RegisterNetEvent('wasteland_admin:openInventory', function(targetId)
    local src = source
    if not GetAdminGroup(src) then return end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then return end
    
    local invType = GetInventoryType()
    local inventoryData = nil
    
    if invType == 'ox' then
        local targetInv = exports.ox_inventory:GetInventory(targetId)
        if targetInv then
            -- Add system tag to each item
            local itemsWithSystem = {}
            for _, item in pairs(targetInv.items or {}) do
                if item then
                    item.system = 'OX'
                    table.insert(itemsWithSystem, item)
                end
            end
            inventoryData = {
                targetId = targetId,
                targetName = GetPlayerName(targetId),
                items = itemsWithSystem,
                weight = targetInv.weight or 0,
                maxWeight = targetInv.maxWeight or 0,
                system = 'OX'
            }
        end
    elseif invType == 'esx' and InventorySystem.ESX then
        local xPlayer = InventorySystem.ESX.GetPlayerFromId(targetId)
        if xPlayer then
            local esxInv = xPlayer.getInventory()
            local itemsWithSystem = {}
            local totalWeight = 0
            for _, item in pairs(esxInv or {}) do
                if item and item.count and item.count > 0 then
                    table.insert(itemsWithSystem, {
                        name = item.name,
                        label = item.label or item.name,
                        count = item.count,
                        weight = item.weight or 0,
                        system = 'ESX'
                    })
                    totalWeight = totalWeight + ((item.weight or 0) * item.count)
                end
            end
            inventoryData = {
                targetId = targetId,
                targetName = GetPlayerName(targetId),
                items = itemsWithSystem,
                weight = totalWeight,
                maxWeight = xPlayer.maxWeight or 24000,
                system = 'ESX'
            }
        end
    end
    
    if inventoryData then
        TriggerClientEvent('wasteland_admin:showInventory', src, inventoryData)
        LogAction(src, 'Viewed inventory of **' .. GetPlayerName(targetId) .. '** [' .. invType:upper() .. ']')
        LogToDatabase('view_inventory', src, targetId, 'Viewed inventory [' .. invType:upper() .. ']')
    end
end)

-- Get player inventory for viewing - Supports ESX and OX
RegisterNetEvent('wasteland_admin:getPlayerInventory', function(targetId)
    local src = source
    if not GetAdminGroup(src) then return end
    targetId = tonumber(targetId)
    if not targetId or not GetPlayerName(targetId) then return end
    
    local invType = GetInventoryType()
    local inventoryData = nil
    
    if invType == 'ox' then
        local targetInv = exports.ox_inventory:GetInventory(targetId)
        if targetInv then
            local itemsWithSystem = {}
            for _, item in pairs(targetInv.items or {}) do
                if item then
                    item.system = 'OX'
                    table.insert(itemsWithSystem, item)
                end
            end
            inventoryData = {
                targetId = targetId,
                targetName = GetPlayerName(targetId),
                items = itemsWithSystem,
                weight = targetInv.weight or 0,
                maxWeight = targetInv.maxWeight or 0,
                system = 'OX'
            }
        end
    elseif invType == 'esx' and InventorySystem.ESX then
        local xPlayer = InventorySystem.ESX.GetPlayerFromId(targetId)
        if xPlayer then
            local esxInv = xPlayer.getInventory()
            local itemsWithSystem = {}
            local totalWeight = 0
            for _, item in pairs(esxInv or {}) do
                if item and item.count and item.count > 0 then
                    table.insert(itemsWithSystem, {
                        name = item.name,
                        label = item.label or item.name,
                        count = item.count,
                        weight = item.weight or 0,
                        system = 'ESX'
                    })
                    totalWeight = totalWeight + ((item.weight or 0) * item.count)
                end
            end
            inventoryData = {
                targetId = targetId,
                targetName = GetPlayerName(targetId),
                items = itemsWithSystem,
                weight = totalWeight,
                maxWeight = xPlayer.maxWeight or 24000,
                system = 'ESX'
            }
        end
    end
    
    if inventoryData then
        TriggerClientEvent('wasteland_admin:inventoryData', src, inventoryData)
    end
end)

-- Reports
RegisterNetEvent('wasteland_admin:submitReport', function(targetId, reason, category)
    local src = source
    reportId = reportId + 1
    local coords = GetEntityCoords(GetPlayerPed(src))
    
    local report = {
        id = reportId,
        reporter = { id = src, name = GetPlayerName(src) },
        target = targetId and GetPlayerName(targetId) and { id = targetId, name = GetPlayerName(targetId) } or nil,
        reason = reason or 'No reason',
        category = category or 'Other',
        time = os.date('%H:%M'),
        coords = { x = coords.x, y = coords.y, z = coords.z }
    }
    activeReports[reportId] = report
    
    for _, pid in ipairs(GetPlayers()) do
        if GetAdminGroup(tonumber(pid)) then
            TriggerClientEvent('wasteland_admin:newReport', tonumber(pid), report)
        end
    end
    
    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Report submitted!' })
    
    SendWebhook('reports', '🚨 New Report', '**' .. GetPlayerName(src) .. '** submitted a report', {
        { name = '📋 Category', value = category or 'Other', inline = true },
        { name = '🎯 Target', value = targetId and GetPlayerName(targetId) or 'None', inline = true },
        { name = '📝 Reason', value = reason or 'No reason', inline = false },
    }, Config.WebhookColors.report)
end)

RegisterNetEvent('wasteland_admin:getReports', function()
    local src = source
    if not GetAdminGroup(src) then return end
    local reports = {}
    for _, r in pairs(activeReports) do table.insert(reports, r) end
    TriggerClientEvent('wasteland_admin:reportsList', src, reports)
end)

RegisterNetEvent('wasteland_admin:claimReport', function(id)
    local src = source
    if not GetAdminGroup(src) then return end
    if activeReports[id] then
        activeReports[id].claimedBy = { id = src, name = GetPlayerName(src) }
        for _, pid in ipairs(GetPlayers()) do
            if GetAdminGroup(tonumber(pid)) then
                TriggerClientEvent('wasteland_admin:reportUpdated', tonumber(pid), activeReports[id])
            end
        end
    end
end)

RegisterNetEvent('wasteland_admin:closeReport', function(id)
    local src = source
    if not GetAdminGroup(src) then return end
    if activeReports[id] then
        LogAction(src, 'Closed report #' .. id)
        activeReports[id] = nil
        for _, pid in ipairs(GetPlayers()) do
            if GetAdminGroup(tonumber(pid)) then
                TriggerClientEvent('wasteland_admin:reportClosed', tonumber(pid), id)
            end
        end
    end
end)

RegisterNetEvent('wasteland_admin:gotoReport', function(id)
    local src = source
    if not HasPermission(src, 'teleport') then return end
    if activeReports[id] and activeReports[id].coords then
        TriggerClientEvent('wasteland_admin:teleportTo', src, activeReports[id].coords)
    end
end)

-- Get logs from database
RegisterNetEvent('wasteland_admin:getLogs', function(logType, limit)
    local src = source
    if not GetAdminGroup(src) then return end
    
    limit = tonumber(limit) or 50
    local query = 'SELECT * FROM admin_logs'
    local params = {}
    
    if logType and logType ~= 'all' then
        query = query .. ' WHERE log_type = ?'
        table.insert(params, logType)
    end
    
    query = query .. ' ORDER BY created_at DESC LIMIT ?'
    table.insert(params, limit)
    
    MySQL_Query(query, params, function(results)
        TriggerClientEvent('wasteland_admin:logsData', src, results or {})
    end)
end)

-- ============================================
-- BAN LIST MANAGEMENT
-- ============================================

-- Get all bans
RegisterNetEvent('wasteland_admin:getBans', function()
    local src = source
    if not HasPermission(src, 'ban') then return end
    
    MySQL_Query('SELECT * FROM ' .. Config.BanTable .. ' ORDER BY created_at DESC', {}, function(results)
        TriggerClientEvent('wasteland_admin:bansList', src, results or {})
    end)
end)

-- Unban player
RegisterNetEvent('wasteland_admin:unbanPlayer', function(banId)
    local src = source
    if not HasPermission(src, 'ban') then return end
    
    banId = tonumber(banId)
    if not banId then return end
    
    -- Get ban info before deleting
    MySQL_Single('SELECT * FROM ' .. Config.BanTable .. ' WHERE id = ?', { banId }, function(ban)
        if ban then
            MySQL_Query('DELETE FROM ' .. Config.BanTable .. ' WHERE id = ?', { banId })
            
            LogAction(src, 'Unbanned **' .. (ban.name or 'Unknown') .. '**', 'bans', {
                { name = '🎯 Player', value = ban.name or 'Unknown', inline = true },
                { name = '🔑 License', value = ban.license or 'N/A', inline = true },
                { name = '📝 Original Reason', value = ban.reason or 'No reason', inline = false },
            })
            
            LogToDatabase('unban', src, nil, 'Unbanned: ' .. (ban.name or 'Unknown'))
            
            TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Player unbanned!' })
            
            -- Refresh ban list
            MySQL_Query('SELECT * FROM ' .. Config.BanTable .. ' ORDER BY created_at DESC', {}, function(results)
                TriggerClientEvent('wasteland_admin:bansList', src, results or {})
            end)
        end
    end)
end)
