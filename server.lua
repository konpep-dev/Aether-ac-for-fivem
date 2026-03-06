local adminCache = {}
local activeReports = {}
local reportId = 0
local dbReady = false

-- ============================================
-- ANTI-TAMPER VERIFICATION
-- Verifies that protection system is running
-- ============================================
local protectionVerified = false

CreateThread(function()
    Wait(2000)  -- Wait for anti_tamper to load
    
    -- Check if anti_tamper exports exist
    local success, isProtected = pcall(function()
        return exports['aether-anticheat']:IsProtected()
    end)
    
    if not success or not isProtected then
        print('========================================')
        print('CRITICAL ERROR: Protection system not running!')
        print('Anti-tamper verification failed')
        print('All connections will be blocked')
        print('========================================')
        protectionVerified = false
    else
        print('[PROTECTION] ✅ Anti-tamper system verified')
        protectionVerified = true
    end
end)

-- Block connections if protection not verified
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    if (GlobalBanBlocked and GlobalBanBlocked[source]) or (LocalBanBlocked and LocalBanBlocked[source]) then return end
    if not protectionVerified then
        deferrals.defer()
        Wait(100)
        
        deferrals.presentCard([[
{
    "type": "AdaptiveCard",
    "body": [
        {
            "type": "Container",
            "items": [
                {
                    "type": "TextBlock",
                    "text": "🔒",
                    "size": "ExtraLarge",
                    "horizontalAlignment": "Center",
                    "color": "Attention"
                },
                {
                    "type": "TextBlock",
                    "text": "SECURITY ERROR",
                    "weight": "Bolder",
                    "size": "ExtraLarge",
                    "horizontalAlignment": "Center",
                    "color": "Attention"
                }
            ],
            "style": "warning"
        },
        {
            "type": "Container",
            "items": [
                {
                    "type": "TextBlock",
                    "text": "Server protection system is not running properly. All connections are blocked for security reasons.",
                    "wrap": true,
                    "horizontalAlignment": "Center"
                }
            ]
        },
        {
            "type": "Container",
            "style": "emphasis",
            "items": [
                {
                    "type": "FactSet",
                    "facts": [
                        {
                            "title": "Status:",
                            "value": "Protection Offline"
                        },
                        {
                            "title": "Action:",
                            "value": "Connections Blocked"
                        }
                    ]
                }
            ]
        }
    ],
    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
    "version": "1.3"
}
        ]])
    end
end)

-- Check if Config is loaded
CreateThread(function()
    Wait(1000)
    if Config and Config.Webhooks then
        print('[aether_admin] Config loaded successfully!')
        print('[aether_admin] Main webhook: ' .. (Config.Webhooks.main or 'NOT SET'))
    else
        print('[aether_admin] ERROR: Config not loaded!')
    end
end)

-- Test webhook command (run in server console: testwebhook)
RegisterCommand('testwebhook', function(source)
    if source ~= 0 then return end -- Console only
    print('[aether_admin] Testing webhook...')
    if not Config or not Config.Webhooks then
        print('[aether_admin] ERROR: Config not loaded!')
        return
    end
    local webhook = Config.Webhooks.main
    if not webhook or webhook == '' then
        print('[aether_admin] No webhook configured!')
        return
    end
    print('[aether_admin] Sending to: ' .. string.sub(webhook, 1, 50) .. '...')
    PerformHttpRequest(webhook, function(statusCode, response)
        print('[aether_admin] Webhook test result - Status: ' .. tostring(statusCode))
        if response then print('[aether_admin] Response: ' .. tostring(response)) end
    end, 'POST', json.encode({
        username = 'Admin Panel Test',
        content = 'Test message from aether_admin!'
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
        print('[aether_admin] Webhook not configured for: ' .. tostring(webhookType))
        return 
    end
    
    print('[aether_admin] Sending webhook: ' .. tostring(webhookType) .. ' - ' .. tostring(title))
    
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
            print('[aether_admin] Webhook sent successfully!')
        else
            print('[aether_admin] Webhook failed! Status: ' .. tostring(statusCode) .. ' Response: ' .. tostring(response))
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
    
    -- Create bans table with ALL identifiers
    MySQL_Query([[
        CREATE TABLE IF NOT EXISTS ]] .. Config.BanTable .. [[ (
            id INT AUTO_INCREMENT PRIMARY KEY,
            license VARCHAR(100) NOT NULL,
            license2 VARCHAR(100),
            discord VARCHAR(100),
            steam VARCHAR(100),
            xbl VARCHAR(100),
            live VARCHAR(100),
            fivem VARCHAR(100),
            ip VARCHAR(50),
            tokens TEXT,
            name VARCHAR(100),
            reason TEXT,
            admin VARCHAR(100),
            expiry BIGINT,
            screenshot_url TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            INDEX (license),
            INDEX (license2),
            INDEX (discord),
            INDEX (steam),
            INDEX (xbl),
            INDEX (live),
            INDEX (fivem),
            INDEX (ip)
        )
    ]])
    
    -- Add missing columns to existing table (for upgrades)
    MySQL_Query([[
        ALTER TABLE ]] .. Config.BanTable .. [[ 
        ADD COLUMN IF NOT EXISTS license2 VARCHAR(100) AFTER license,
        ADD COLUMN IF NOT EXISTS xbl VARCHAR(100) AFTER steam,
        ADD COLUMN IF NOT EXISTS live VARCHAR(100) AFTER xbl,
        ADD COLUMN IF NOT EXISTS fivem VARCHAR(100) AFTER live,
        ADD COLUMN IF NOT EXISTS ip VARCHAR(50) AFTER fivem,
        ADD COLUMN IF NOT EXISTS tokens TEXT AFTER ip,
        ADD COLUMN IF NOT EXISTS screenshot_url TEXT AFTER expiry
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
            print('[aether_admin] Loaded ' .. #results .. ' admins from database')
        end
    end)
end)

-- Log to database
local function LogToDatabase(logType, playerSrc, targetSrc, details, coords)
    if not dbReady then 
        print('[aether_admin] Database not ready, skipping log: ' .. logType)
        return 
    end
    
    local playerName = playerSrc and GetPlayerName(playerSrc) or nil
    local playerLicense = playerSrc and GetPlayerLicense(playerSrc) or nil
    local playerDiscord = playerSrc and GetPlayerDiscord(playerSrc) or nil
    local targetName = targetSrc and GetPlayerName(targetSrc) or nil
    local targetLicense = targetSrc and GetPlayerLicense(targetSrc) or nil
    local coordsStr = coords and string.format("%.2f, %.2f, %.2f", coords.x, coords.y, coords.z) or nil
    
    print('[aether_admin] Logging to database: ' .. logType .. ' - ' .. (details or 'no details'))
    
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
    
    local serverName = Config and Config.ServerName or "aether Server"
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
        ["text"] = "Aether Anticheat v4.5.0 • Coded by konpep",
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
                ["text"] = "Aether Anticheat v4.5.0 • Coded by konpep",
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
-- ANTI-VPN SYSTEM UTILITIES
-- ============================================
local vpnCache = {}  -- Cache checked IPs to save API requests

-- Check if IP is using VPN/Proxy
local function CheckVPN(ip, callback)
    if not Config.AntiVPN or not Config.AntiVPN.enabled then
        callback(false, nil)
        return
    end
    
    -- Check whitelist
    if Config.AntiVPN.whitelist[ip] then
        print('[ANTI-VPN] IP ' .. ip .. ' is whitelisted')
        callback(false, nil)
        return
    end
    
    -- Check cache
    if vpnCache[ip] then
        local cached = vpnCache[ip]
        local age = os.time() - cached.timestamp
        
        if age < Config.AntiVPN.cacheDuration then
            print('[ANTI-VPN] Using cached result for ' .. ip .. ' (age: ' .. math.floor(age/3600) .. 'h)')
            callback(cached.isVPN, cached.data)
            return
        else
            print('[ANTI-VPN] Cache expired for ' .. ip)
            vpnCache[ip] = nil
        end
    end
    
    -- Make API request
    local apiUrl = 'http://proxycheck.io/v2/' .. ip .. '?key=' .. Config.AntiVPN.apiKey .. '&vpn=1&asn=1&risk=1'
    
    print('[ANTI-VPN] Checking IP: ' .. ip)
    
    PerformHttpRequest(apiUrl, function(statusCode, response, headers)
        if statusCode ~= 200 then
            print('[ANTI-VPN] API Error: Status ' .. statusCode)
            callback(false, nil)
            return
        end
        
        local success, data = pcall(function() return json.decode(response) end)
        
        if not success or not data then
            print('[ANTI-VPN] Failed to parse API response')
            callback(false, nil)
            return
        end
        
        local ipData = data[ip]
        if not ipData then
            print('[ANTI-VPN] No data for IP')
            callback(false, nil)
            return
        end
        
        local isVPN = ipData.proxy == 'yes'
        local vpnType = ipData.type or 'Unknown'
        local country = ipData.country or 'Unknown'
        local risk = ipData.risk or 0
        
        -- Cache result
        vpnCache[ip] = {
            isVPN = isVPN,
            timestamp = os.time(),
            data = {
                type = vpnType,
                country = country,
                risk = risk,
                provider = ipData.provider or 'Unknown'
            }
        }
        
        if isVPN then
            print('[ANTI-VPN] ⚠️ VPN DETECTED! IP: ' .. ip .. ' | Type: ' .. vpnType .. ' | Country: ' .. country .. ' | Risk: ' .. risk)
        else
            print('[ANTI-VPN] ✅ Clean IP: ' .. ip .. ' | Country: ' .. country)
        end
        
        callback(isVPN, vpnCache[ip].data)
    end, 'GET')
end

-- ============================================
-- VPN/BLACKLIST CARD GENERATORS
-- ============================================
local function GenerateVPNCard(playerName, ip, data)
    local cardBody = {
        {
            ["type"] = "TextBlock",
            ["text"] = "🛡️ AETHER ANTICHEAT • VPN DETECTED / ΕΝΤΟΠΙΣΤΗΚΕ VPN",
            ["weight"] = "Bolder",
            ["size"] = "Small",
            ["color"] = "Attention",
            ["horizontalAlignment"] = "Center"
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "⚠️ Access Denied / Η πρόσβαση απορρίφθηκε",
            ["weight"] = "Bolder",
            ["size"] = "Medium",
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "Small"
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "Your connection has been blocked for security reasons (VPN/Proxy).",
            ["wrap"] = true,
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "Small"
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "Η σύνδεσή σας έχει αποκλειστεί για λόγους ασφαλείας (VPN/Proxy).",
            ["wrap"] = true,
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "None"
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "🌐 IP: " .. ip .. "\n🔒 Type: " .. (data.type or "VPN/Proxy") .. "\n🌍 Country: " .. (data.country or "Unknown") .. "\n⚠️ Risk: " .. tostring(data.risk or 0) .. "%",
            ["wrap"] = true,
            ["spacing"] = "Medium",
            ["horizontalAlignment"] = "Center"
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "💡 How to Fix: Disable your VPN and reconnect.\n💡 Επίλυση: Απενεργοποιήστε το VPN και συνδεθείτε ξανά.",
            ["wrap"] = true,
            ["size"] = "Small",
            ["color"] = "Good",
            ["spacing"] = "Medium",
            ["horizontalAlignment"] = "Center"
        },
        {
            ["type"] = "ActionSet",
            ["spacing"] = "Medium",
            ["actions"] = {
                {
                    ["type"] = "Action.OpenUrl",
                    ["title"] = "💬 Support Discord",
                    ["url"] = Config.DiscordInvite or "https://discord.gg/your-server"
                }
            }
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "Aether Anticheat v4.5.0 • Coded by konpep",
            ["size"] = "Small",
            ["isSubtle"] = true,
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "Medium"
        }
    }
    
    local card = {
        ["type"] = "AdaptiveCard",
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ["version"] = "1.5",
        ["body"] = cardBody
    }
    return json.encode(card)
end

local function GenerateBlacklistCard(playerName, ip, country)
    local cardBody = {
        {
            ["type"] = "TextBlock",
            ["text"] = "🚫 REGION RESTRICTED / ΠΕΡΙΟΡΙΣΜΟΣ ΠΕΡΙΟΧΗΣ",
            ["weight"] = "Bolder",
            ["size"] = "Small",
            ["color"] = "Attention",
            ["horizontalAlignment"] = "Center"
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "⚠️ Access Denied / Η πρόσβαση απορρίφθηκε",
            ["weight"] = "Bolder",
            ["size"] = "Medium",
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "Small"
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "Connections from your country are not accepted.",
            ["wrap"] = true,
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "Small"
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "Δεν γίνονται δεκτές συνδέσεις από τη χώρα σας.",
            ["wrap"] = true,
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "None"
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "🌐 IP: " .. ip .. "\n🌍 Country: " .. (country or "Unknown"),
            ["wrap"] = true,
            ["spacing"] = "Medium",
            ["horizontalAlignment"] = "Center"
        },
        {
            ["type"] = "ActionSet",
            ["spacing"] = "Medium",
            ["actions"] = {
                {
                    ["type"] = "Action.OpenUrl",
                    ["title"] = "💬 Support Discord",
                    ["url"] = Config.DiscordInvite or "https://discord.gg/your-server"
                }
            }
        },
        {
            ["type"] = "TextBlock",
            ["text"] = "Aether Anticheat v4.5.0 • Coded by konpep",
            ["size"] = "Small",
            ["isSubtle"] = true,
            ["horizontalAlignment"] = "Center",
            ["spacing"] = "Medium"
        }
    }
    
    local card = {
        ["type"] = "AdaptiveCard",
        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
        ["version"] = "1.5",
        ["body"] = cardBody
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

-- Global flag tables so handlers can cooperate
GlobalBanBlocked = GlobalBanBlocked or {}
LocalBanBlocked = LocalBanBlocked or {}

-- Connect/Disconnect Logging
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    
    -- Check if player was already blocked by any ban system
    if (GlobalBanBlocked and GlobalBanBlocked[src]) or (LocalBanBlocked and LocalBanBlocked[src]) then
        print('[BAN CHECK] ⛔ Player already blocked, letting the responsible script handle the card...')
        return
    end
    
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
    
    -- ADVANCED BAN CHECK - Check ALL identifiers (anti-bypass)
    local banCheckDone = false
    local ban = nil
    
    print('[BAN CHECK] ========================================')
    print('[BAN CHECK] Player: ' .. name)
    print('[BAN CHECK] License: ' .. tostring(ids.license))
    
    -- Build query to check ALL identifiers
    local query = [[
        SELECT id, license, discord, steam, name, reason, admin, expiry, screenshot_url, created_at 
        FROM admin_bans 
        WHERE (expiry IS NULL OR expiry > ?)
        AND (
            license = ? OR
            license2 = ? OR
            discord = ? OR
            steam = ? OR
            xbl = ? OR
            live = ? OR
            fivem = ? OR
            ip = ?
    ]]
    
    -- Add token checking if available
    local tokens = {}
    for i = 0, GetNumPlayerTokens(src) - 1 do
        table.insert(tokens, GetPlayerToken(src, i))
    end
    
    if #tokens > 0 then
        for i = 1, #tokens do
            query = query .. " OR tokens LIKE ?"
        end
    end
    
    query = query .. ") ORDER BY id DESC LIMIT 1"
    
    -- Build parameters
    local params = {
        os.time(), -- Current time for expiry check
        ids.license or '',
        ids.license2 or '',
        ids.discord or '',
        ids.steam or '',
        ids.xbl or '',
        ids.live or '',
        ids.fivem or '',
        ids.ip or ''
    }
    
    -- Add token parameters
    for _, token in ipairs(tokens) do
        table.insert(params, '%' .. token .. '%')
    end
    
    exports.oxmysql:single(query, params, function(testBan)
        if testBan then
            print('[BAN CHECK] 🚨 BANNED PLAYER DETECTED!')
            print('[BAN CHECK] Ban ID: ' .. tostring(testBan.id))
            ban = testBan
            LocalBanBlocked[src] = true
        else
            print('[BAN CHECK] ✅ No active bans found')
        end
        banCheckDone = true
    end)
    
    -- Wait for async check (max 5 seconds)
    local dbTimeout = 0
    while not banCheckDone and dbTimeout < 50 do
        dbTimeout = dbTimeout + 1
        Wait(100)
    end
    
    if not banCheckDone then
        print('[BAN CHECK] ❌ DATABASE TIMEOUT - Proceeding for safety')
    end
    
    print('[BAN CHECK] ========================================')
    
    if ban then
        -- UPDATE BAN WITH NEW IDENTIFIERS (Anti-Bypass)
        print('[BAN CHECK] 🔄 Updating ban with new identifiers...')
        
        local tokens = {}
        for i = 0, GetNumPlayerTokens(src) - 1 do
            table.insert(tokens, GetPlayerToken(src, i))
        end
        local tokensStr = table.concat(tokens, ',')
        
        pcall(function()
            exports.oxmysql:execute(
                'UPDATE admin_bans SET license2 = ?, discord = ?, steam = ?, xbl = ?, live = ?, fivem = ?, ip = ?, tokens = ?, name = ? WHERE id = ?',
                {
                    ids.license2 or ban.license2,
                    ids.discord or ban.discord,
                    ids.steam or ban.steam,
                    ids.xbl or ban.xbl,
                    ids.live or ban.live,
                    ids.fivem or ban.fivem,
                    ids.ip or ban.ip,
                    tokensStr ~= '' and tokensStr or ban.tokens,
                    name,
                    ban.id
                }
            )
            print('[BAN CHECK] ✅ Ban updated with new identifiers')
        end)
        
        -- Log bypass attempt
        pcall(function()
            exports.oxmysql:insert(
                'INSERT INTO admin_logs (log_type, player_name, player_license, details) VALUES (?, ?, ?, ?)',
                {'ban_bypass_attempt', name, ids.license, 'Tried to bypass ban ID: ' .. ban.id}
            )
        end)
        
        -- Send webhook alert
        if Config and Config.Webhooks and Config.Webhooks.anticheat then
            PerformHttpRequest(Config.Webhooks.anticheat, function() end, 'POST', json.encode({
                username = '🛡️ Anticheat System',
                embeds = {{
                    title = '🚨 BAN BYPASS ATTEMPT',
                    description = '**' .. name .. '** tried to bypass a ban!',
                    color = 16711680,
                    fields = {
                        {name = '🆔 Ban ID', value = '```' .. tostring(ban.id) .. '```', inline = true},
                        {name = '📝 Reason', value = '```' .. (ban.reason or 'N/A') .. '```', inline = false},
                        {name = '🔑 License', value = '```' .. tostring(ids.license) .. '```', inline = true},
                        {name = '💬 Discord', value = '```' .. tostring(ids.discord or 'N/A') .. '```', inline = true},
                        {name = '🎮 Steam', value = '```' .. tostring(ids.steam or 'N/A') .. '```', inline = true},
                        {name = '🌐 IP', value = '```' .. tostring(ids.ip or 'N/A') .. '```', inline = true}
                    },
                    footer = {
                        text = '🛡️ Aether Anticheat v4.5.0',
                        icon_url = 'https://i.imgur.com/AfFp7pu.png'
                    },
                    timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
                }}
            }), {['Content-Type'] = 'application/json' })
        end
        
        -- Get screenshot URL ONLY (don't use LONGBLOB - too slow)
        local screenshotUrl = ban.screenshot_url
        
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
        
        print('[BAN CARD] 🛡️ Presenting local ban card to ' .. name)
        deferrals.presentCard(banCard, function(data, rawData)
            deferrals.done('You are banned from this server.')
        end)
        
        -- Cleanup flag after a delay to release the slot
        SetTimeout(30000, function()
            LocalBanBlocked[src] = nil
        end)
        return
    end
    
    -- Not banned - Now check connection security (VPN/Blacklist)
    local ip = GetPlayerEndpoint(src)
    if ip then ip = ip:match("([^:]+)") end
    
    local vpnChecked = false
    local isVPN = false
    local vpnData = nil
    
    -- Start async check
    CheckVPN(ip, function(result, data)
        isVPN = result
        vpnData = data
        vpnChecked = true
    end)
    
    -- Keep-alive loop while waiting for API (max 10 seconds)
    local timeout = 0
    while not vpnChecked and timeout < 100 do
        timeout = timeout + 1
        deferrals.update('🔍 Verifying connection security... ' .. timeout .. '%')
        Wait(100)
    end

    -- Process results
    if vpnChecked then
        -- 1. Check country blacklist
        if Config.AntiVPN.countryBlacklistEnabled and vpnData and vpnData.country then
            local currentCountry = string.lower(vpnData.country)
            local isBlacklisted = false
            
            for countryName, enabled in pairs(Config.AntiVPN.blacklistedCountries) do
                if enabled and string.lower(countryName) == currentCountry then
                    isBlacklisted = true
                    break
                end
            end

            if isBlacklisted then
                print('[ANTI-VPN] 🚫 BLACKLISTED COUNTRY DETECTED! IP: ' .. ip .. ' | Country: ' .. vpnData.country)
                local card = GenerateBlacklistCard(name, ip, vpnData.country)
                
                -- Show card and wait for interaction (Same as Ban Card)
                deferrals.presentCard(card, function(data, rawData)
                    deferrals.done('Access denied: Your region is restricted.')
                end)
                
                -- Webhook log
                if Config.Webhooks and Config.Webhooks.main then
                    PerformHttpRequest(Config.Webhooks.main, function() end, 'POST', json.encode({
                        username = 'Anti-VPN',
                        embeds = {{
                            title = '🌍 BLACKLISTED COUNTRY BLOCKED',
                            description = '**' .. name .. '** blocked from **' .. vpnData.country .. '**',
                            color = 16711680,
                            fields = {
                                { name = '👤 Player', value = name, inline = true },
                                { name = '🌐 IP Address', value = ip, inline = true },
                                { name = '🌍 Country', value = vpnData.country, inline = true }
                            }
                        }}
                    }), { ['Content-Type'] = 'application/json' })
                end
                return -- EXIT handler while showing the card
            end
        end
        
        -- 2. Check VPN
        if isVPN and vpnData then
            print('[ANTI-VPN] 🛡️ VPN DETECTED! Blocking connection for: ' .. name)
            local card = GenerateVPNCard(name, ip, vpnData)
            
            -- Show card and wait for interaction (Same as Ban Card)
            deferrals.presentCard(card, function(data, rawData)
                deferrals.done('Access denied: VPN/Proxy detected.')
            end)

            -- Webhook log
            if Config.Webhooks and Config.Webhooks.main then
                PerformHttpRequest(Config.Webhooks.main, function() end, 'POST', json.encode({
                    username = 'Anti-VPN System',
                    embeds = {{
                        title = '🛡️ VPN/PROXY BLOCKED',
                        description = '**' .. name .. '** was blocked from connecting',
                        color = 16711680,
                        fields = {
                            { name = '👤 Player', value = name, inline = true },
                            { name = '🌐 IP Address', value = ip, inline = true },
                            { name = '🔒 Type', value = vpnData.type or 'VPN/Proxy', inline = true },
                            { name = '🌍 Country', value = vpnData.country or 'Unknown', inline = true },
                            { name = '⚠️ Risk Score', value = tostring(vpnData.risk or 0) .. '%', inline = true }
                        }
                    }}
                }), { ['Content-Type'] = 'application/json' })
            end
            return -- EXIT handler while showing the card
        end
    end

    -- IDENTIFIERS TRACKING (Only if connection is clean)
    TrackPlayerIdentifiers(name, ids)
    
    -- CHECK TOS
    local tosEnabled = Config and Config.TOS and Config.TOS.enabled
    if not tosEnabled then
        deferrals.update('✅ Welcome, ' .. name .. '!')
        Wait(500)
        deferrals.done()
        LogToDatabase('connect', src, nil, 'Player connected')
        return
    end
    
    deferrals.update('📜 Checking Terms of Service...')
    local tosRecord = nil
    pcall(function()
        tosRecord = exports.oxmysql:singleSync('SELECT * FROM anticheat_tos WHERE license = ?', { ids.license })
    end)
    
    if tosRecord and (tosRecord.accepted == 1 or tosRecord.accepted == '1' or tosRecord.accepted == true) then
        deferrals.update('✅ Welcome back, ' .. name .. '!')
        Wait(500)
        deferrals.done()
        LogToDatabase('connect', src, nil, 'Player connected')
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
RegisterNetEvent('aether_admin:logKill', function(targetId, weapon, headshot)
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
RegisterNetEvent('aether_admin:takeScreenshot', function(targetId)
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
    
    -- Correct event for screenshot-basic: requestScreenshot
    TriggerClientEvent('screenshot-basic:requestScreenshot', targetId, {
        encoding = 'jpg',
        quality = 0.8
    }, function(data)
        if not data then
            print('[SCREENSHOT] Failed to get data')
            TriggerClientEvent('ox_lib:notify', src, { type = 'error', description = 'Screenshot failed!' })
            return
        end
        
        print('[SCREENSHOT] Success! Data length: ' .. tostring(#data))
        
        -- Show in admin UI
        TriggerClientEvent('aether_admin:screenshotResult', src, data, targetName)
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
RegisterNetEvent('aether_admin:checkPermission', function()
    local src = source
    local group = GetAdminGroup(src)
    local perms = group and Config.AdminGroups[group] or nil
    TriggerClientEvent('aether_admin:permissionResult', src, group ~= nil, group, perms)
end)

-- Get players with more info
RegisterNetEvent('aether_admin:getPlayers', function()
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
    TriggerClientEvent('aether_admin:updatePlayers', src, players)
end)

-- Get items
-- ============================================
-- FRAMEWORK INITIALIZATION
-- ============================================
CreateThread(function()
    Wait(1000)
    Framework.Detect()
end)

RegisterNetEvent('aether_admin:getItems', function()
    local src = source
    if not HasPermission(src, 'giveItem') then return end
    
    local items = {}
    local itemsList = Framework.GetItemsList()
    
    if itemsList then
        for name, data in pairs(itemsList) do
            local label = type(data) == 'table' and (data.label or data.name or name) or name
            table.insert(items, { name = name, label = label, system = Framework.Type:upper() })
        end
    end
    
    table.sort(items, function(a, b) return (a.label or a.name) < (b.label or b.name) end)
    TriggerClientEvent('aether_admin:itemsList', src, items)
end)

-- Give item (supports all frameworks)
RegisterNetEvent('aether_admin:giveItem', function(targetId, item, count)
    local src = source
    if not HasPermission(src, 'giveItem') then return end
    
    targetId = tonumber(targetId)
    count = tonumber(count) or 1
    
    local success = Framework.AddItem(targetId, item, count)
    
    if success then
        LogAction(src, 'Gave **' .. count .. 'x ' .. item .. '** to ' .. (GetPlayerName(targetId) or targetId) .. ' [' .. Framework.Type:upper() .. ']', 'spawn', {
            { name = '🎯 Target', value = GetPlayerName(targetId) or 'Unknown', inline = true },
            { name = '📦 Item', value = item, inline = true },
            { name = '🔢 Amount', value = tostring(count), inline = true },
            { name = '📋 Framework', value = Framework.Type:upper(), inline = true },
        })
        LogToDatabase('give_item', src, targetId, item .. ' x' .. count .. ' [' .. Framework.Type:upper() .. ']')
    end
end)

-- Teleport
RegisterNetEvent('aether_admin:teleportToPlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'teleport') then return end
    
    local targetPed = GetPlayerPed(targetId)
    if targetPed then
        TriggerClientEvent('aether_admin:teleportTo', src, GetEntityCoords(targetPed))
        LogAction(src, 'Teleported to **' .. (GetPlayerName(targetId) or targetId) .. '**', 'teleport')
    end
end)

-- Bring
RegisterNetEvent('aether_admin:bringPlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'bring') then return end
    
-- Notify anticheat to ignore teleport detection for this player
    TriggerClientEvent('anticheat:adminActionProtection', targetId, 'bring', 5000)
    
    TriggerClientEvent('aether_admin:teleportTo', targetId, GetEntityCoords(GetPlayerPed(src)))
    LogAction(src, 'Brought **' .. (GetPlayerName(targetId) or targetId) .. '**', 'teleport')
end)

-- Kick
RegisterNetEvent('aether_admin:kickPlayer', function(targetId, reason)
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
RegisterNetEvent('aether_admin:banPlayer', function(targetId, reason, duration)
    local src = source
    if not HasPermission(src, 'ban') then return end
    
    local targetName = GetPlayerName(targetId) or 'Unknown'
    
    -- Get ALL identifiers
    local ids = GetAllIdentifiers(targetId)
    local license = ids.license
    local license2 = ids.license2
    local discord = ids.discord
    local steam = ids.steam
    local xbl = ids.xbl
    local live = ids.live
    local fivem = ids.fivem
    local ip = ids.ip
    local tokens = table.concat(ids.tokens or {}, ',')
    
    if license then
        local expiry = duration and duration > 0 and (os.time() + duration * 60) or nil
        
        -- Insert ban with ALL identifiers
        MySQL_Insert('INSERT INTO ' .. Config.BanTable .. ' (license, license2, discord, steam, xbl, live, fivem, ip, tokens, name, reason, admin, expiry) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            license, license2, discord, steam, xbl, live, fivem, ip, tokens, targetName, reason or 'No reason', GetPlayerName(src), expiry
        })
        
        LogToDatabase('ban', src, targetId, reason or 'No reason')
        DropPlayer(targetId, 'Banned: ' .. (reason or 'No reason'))
        
        local durationText = expiry and (duration .. ' minutes') or 'Permanent'
        LogAction(src, 'Banned **' .. targetName .. '**', 'bans', {
            { name = '🎯 Player', value = targetName, inline = true },
            { name = '⏱️ Duration', value = durationText, inline = true },
            { name = '📝 Reason', value = reason or 'No reason', inline = false },
            { name = '🔑 License', value = license or 'N/A', inline = false },
            { name = '💬 Discord', value = discord or 'N/A', inline = true },
            { name = '🎮 Steam', value = steam or 'N/A', inline = true },
        })
    end
end)

-- Freeze
RegisterNetEvent('aether_admin:freezePlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'freeze') then return end
    
    -- Notify anticheat to ignore checks for this player
    TriggerClientEvent('anticheat:adminActionProtection', targetId, 'freeze', 5000)
    
    TriggerClientEvent('aether_admin:freeze', targetId)
    LogAction(src, 'Froze **' .. (GetPlayerName(targetId) or targetId) .. '**')
end)

-- Weather
RegisterNetEvent('aether_admin:setWeather', function(weather)
    local src = source
    if not HasPermission(src, 'setWeather') then return end
    TriggerClientEvent('aether_admin:syncWeather', -1, weather)
    LogAction(src, 'Set weather to **' .. weather .. '**')
end)

-- Time
RegisterNetEvent('aether_admin:setTime', function(hour, minute)
    local src = source
    if not HasPermission(src, 'setTime') then return end
    TriggerClientEvent('aether_admin:syncTime', -1, hour, minute)
    LogAction(src, 'Set time to **' .. hour .. ':' .. (minute < 10 and '0' or '') .. minute .. '**')
end)

-- Revive
RegisterNetEvent('aether_admin:revivePlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'revive') then return end
    
    -- Notify anticheat to ignore self-revive/heal detection for this player
    TriggerClientEvent('anticheat:adminActionProtection', targetId, 'revive', 10000)
    
    -- Use framework revive if available
    Framework.Revive(targetId)
    LogAction(src, 'Revived **' .. (GetPlayerName(targetId) or targetId) .. '**')
end)

-- Announce
RegisterNetEvent('aether_admin:announce', function(message)
    local src = source
    if not HasPermission(src, 'announce') then return end
    TriggerClientEvent('chat:addMessage', -1, { color = {255, 200, 0}, args = {'[ADMIN]', message} })
    LogAction(src, 'Announced: **' .. message .. '**')
end)

-- Spectate
RegisterNetEvent('aether_admin:spectatePlayer', function(targetId)
    local src = source
    if not HasPermission(src, 'spectate') then return end
    
    targetId = tonumber(targetId)
    if targetId and GetPlayerName(targetId) then
        local targetPed = GetPlayerPed(targetId)
        local coords = GetEntityCoords(targetPed)
        TriggerClientEvent('aether_admin:startSpectate', src, targetId, coords)
        LogAction(src, 'Started spectating **' .. GetPlayerName(targetId) .. '**')
    end
end)

-- Get admins
RegisterNetEvent('aether_admin:getAdmins', function()
    local src = source
    if not HasPermission(src, 'managePerms') then return end
    
    local admins = {}
    for id, group in pairs(Config.Admins) do
        table.insert(admins, { license = id, group = group })
    end
    TriggerClientEvent('aether_admin:adminsList', src, admins)
end)

-- Set admin
RegisterNetEvent('aether_admin:setAdmin', function(identifier, group)
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
            TriggerClientEvent('aether_admin:permissionResult', serverId, true, group, Config.AdminGroups[group])
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
    TriggerClientEvent('aether_admin:adminsList', src, admins)
end)

-- Remove admin
RegisterNetEvent('aether_admin:removeAdmin', function(identifier)
    local src = source
    if not HasPermission(src, 'managePerms') then return end
    
    Config.Admins[identifier] = nil
    MySQL_Query('DELETE FROM ' .. Config.AdminTable .. ' WHERE identifier = ?', { identifier })
    
    for _, pid in ipairs(GetPlayers()) do
        for _, id in pairs(GetPlayerIdentifiers(tonumber(pid)) or {}) do
            if id == identifier then
                adminCache[tonumber(pid)] = nil
                TriggerClientEvent('aether_admin:permissionResult', tonumber(pid), false, nil, nil)
            end
        end
    end
    
    LogAction(src, 'Removed admin **' .. identifier .. '**', 'permissions')
    
    Wait(100)
    local admins = {}
    for id, grp in pairs(Config.Admins) do table.insert(admins, { license = id, group = grp }) end
    TriggerClientEvent('aether_admin:adminsList', src, admins)
end)

-- Open inventory (view other player's inventory) - Supports ESX and OX
RegisterNetEvent('aether_admin:openInventory', function(targetId)
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
        TriggerClientEvent('aether_admin:showInventory', src, inventoryData)
        LogAction(src, 'Viewed inventory of **' .. GetPlayerName(targetId) .. '** [' .. invType:upper() .. ']')
        LogToDatabase('view_inventory', src, targetId, 'Viewed inventory [' .. invType:upper() .. ']')
    end
end)

-- Get player inventory for viewing - Supports ESX and OX
RegisterNetEvent('aether_admin:getPlayerInventory', function(targetId)
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
        TriggerClientEvent('aether_admin:inventoryData', src, inventoryData)
    end
end)

-- Reports
RegisterNetEvent('aether_admin:submitReport', function(targetId, reason, category)
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
            TriggerClientEvent('aether_admin:newReport', tonumber(pid), report)
        end
    end
    
    TriggerClientEvent('ox_lib:notify', src, { type = 'success', description = 'Report submitted!' })
    
    SendWebhook('reports', '🚨 New Report', '**' .. GetPlayerName(src) .. '** submitted a report', {
        { name = '📋 Category', value = category or 'Other', inline = true },
        { name = '🎯 Target', value = targetId and GetPlayerName(targetId) or 'None', inline = true },
        { name = '📝 Reason', value = reason or 'No reason', inline = false },
    }, Config.WebhookColors.report)
end)

RegisterNetEvent('aether_admin:getReports', function()
    local src = source
    if not GetAdminGroup(src) then return end
    local reports = {}
    for _, r in pairs(activeReports) do table.insert(reports, r) end
    TriggerClientEvent('aether_admin:reportsList', src, reports)
end)

RegisterNetEvent('aether_admin:claimReport', function(id)
    local src = source
    if not GetAdminGroup(src) then return end
    if activeReports[id] then
        activeReports[id].claimedBy = { id = src, name = GetPlayerName(src) }
        for _, pid in ipairs(GetPlayers()) do
            if GetAdminGroup(tonumber(pid)) then
                TriggerClientEvent('aether_admin:reportUpdated', tonumber(pid), activeReports[id])
            end
        end
    end
end)

RegisterNetEvent('aether_admin:closeReport', function(id)
    local src = source
    if not GetAdminGroup(src) then return end
    if activeReports[id] then
        LogAction(src, 'Closed report #' .. id)
        activeReports[id] = nil
        for _, pid in ipairs(GetPlayers()) do
            if GetAdminGroup(tonumber(pid)) then
                TriggerClientEvent('aether_admin:reportClosed', tonumber(pid), id)
            end
        end
    end
end)

RegisterNetEvent('aether_admin:gotoReport', function(id)
    local src = source
    if not HasPermission(src, 'teleport') then return end
    if activeReports[id] and activeReports[id].coords then
        TriggerClientEvent('aether_admin:teleportTo', src, activeReports[id].coords)
    end
end)

-- Get logs from database
RegisterNetEvent('aether_admin:getLogs', function(logType, limit)
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
        TriggerClientEvent('aether_admin:logsData', src, results or {})
    end)
end)

-- ============================================
-- BAN LIST MANAGEMENT
-- ============================================

-- Get all bans
RegisterNetEvent('aether_admin:getBans', function()
    local src = source
    if not HasPermission(src, 'ban') then return end
    
    MySQL_Query('SELECT * FROM ' .. Config.BanTable .. ' ORDER BY created_at DESC', {}, function(results)
        TriggerClientEvent('aether_admin:bansList', src, results or {})
    end)
end)

-- Unban player
RegisterNetEvent('aether_admin:unbanPlayer', function(banId)
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
                TriggerClientEvent('aether_admin:bansList', src, results or {})
            end)
        end
    end)
end)


-- ============================================
-- EXPORTS FOR OTHER SCRIPTS
-- Use these to prevent false positives
-- ============================================

-- Enable/Disable safe mode for a player
-- Usage: exports['aether-anticheat']:SetPlayerSafeMode(source, true)
function SetPlayerSafeMode(src, enabled)
    Framework.SetPlayerSafeMode(src, enabled)
end

-- Check if player is in safe mode
-- Usage: local isSafe = exports['aether-anticheat']:IsPlayerInSafeMode(source)
function IsPlayerInSafeMode(src)
    return Framework.IsPlayerInSafeMode(src)
end


-- Server events for client-triggered safe mode
RegisterNetEvent('aether:enableSafeMode', function()
    local src = source
    exports['aether-anticheat']:SetPlayerSafeMode(src, true)
end)

RegisterNetEvent('aether:disableSafeMode', function()
    local src = source
    exports['aether-anticheat']:SetPlayerSafeMode(src, false)
end)


-- ============================================
-- AC INFO COMMAND
-- Shows anticheat information to admins
-- ============================================
RegisterCommand('ac', function(source, args, rawCommand)
    if source == 0 then
        print('[ANTICHEAT] Aether Anticheat v4.5 - Coded by konpep')
        print('[ANTICHEAT] Advanced Protection System')
        print('[ANTICHEAT] Use /ac info in-game for detailed information')
        return
    end
    
    -- Check if player has admin permissions
    local adminGroup = GetAdminGroup(source)
    if not adminGroup then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Anticheat", "You don't have permission to use this command!"}
        })
        return
    end
    
    -- Check subcommand
    if args[1] == 'info' then
        -- Trigger client UI
        TriggerClientEvent('anticheat:showInfo', source)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 200, 255},
            multiline = true,
            args = {"Anticheat", "Usage: /ac info - Show anticheat information"}
        })
    end
end, false)


-- ============================================
-- PLAYER INFO COMMAND
-- Shows detailed player information to admins
-- ============================================
RegisterCommand('info', function(source, args, rawCommand)
    if source == 0 then
        print('[ADMIN] Usage: /info [playerid]')
        return
    end
    
    -- Check if player has admin permissions
    local adminGroup = GetAdminGroup(source)
    if not adminGroup then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Admin", "You don't have permission to use this command!"}
        })
        return
    end
    
    -- Check if player ID was provided
    if not args[1] then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 100, 100},
            multiline = true,
            args = {"Admin", "Usage: /info [playerid]"}
        })
        return
    end
    
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 100, 100},
            multiline = true,
            args = {"Admin", "Invalid player ID!"}
        })
        return
    end
    
    -- Check if player exists
    local targetName = GetPlayerName(targetId)
    if not targetName then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 100, 100},
            multiline = true,
            args = {"Admin", "Player not found!"}
        })
        return
    end
    
    -- Get player identifiers
    local license = GetPlayerLicense(targetId) or 'Unknown'
    local discord = GetPlayerDiscord(targetId) or 'Unknown'
    local steam = GetPlayerSteam(targetId) or 'Unknown'
    local ip = GetPlayerEndpoint(targetId) or 'Unknown'
    
    print('[DEBUG] Getting info for player: ' .. targetName .. ' (ID: ' .. targetId .. ')')
    print('[DEBUG] License: ' .. license)
    
    -- Query database for bans
    MySQL_Query('SELECT COUNT(*) as count FROM ' .. Config.BanTable .. ' WHERE license = ? OR discord = ? OR steam = ?', 
        {license, discord, steam}, 
        function(bans)
            print('[DEBUG] Ban query completed')
            local banCount = bans and bans[1] and bans[1].count or 0
            print('[DEBUG] Ban count: ' .. banCount)
            
            -- Try to get screenshots (with error handling)
            local screenshotList = {}
            pcall(function()
                MySQL_Query('SELECT screenshot_url, reason, created_at FROM admin_screenshots WHERE license = ? ORDER BY created_at DESC LIMIT 20', 
                    {license}, 
                    function(screenshots)
                        if screenshots then
                            print('[DEBUG] Found ' .. #screenshots .. ' screenshots')
                            for _, ss in ipairs(screenshots) do
                                table.insert(screenshotList, {
                                    url = ss.screenshot_url,
                                    reason = ss.reason or 'No reason',
                                    date = ss.created_at or 'Unknown'
                                })
                            end
                        end
                    end
                )
            end)
            
            -- Try to get logs (with error handling)
            local logList = {}
            pcall(function()
                MySQL_Query('SELECT action, details, timestamp FROM admin_logs WHERE target_license = ? ORDER BY timestamp DESC LIMIT 10', 
                    {license}, 
                    function(logs)
                        if logs then
                            print('[DEBUG] Found ' .. #logs .. ' logs')
                            for _, log in ipairs(logs) do
                                table.insert(logList, {
                                    action = log.action or 'Unknown',
                                    details = log.details or '',
                                    time = log.timestamp or 'Unknown'
                                })
                            end
                        end
                    end
                )
            end)
            
            -- Wait a bit for async queries to complete, then send
            Wait(500)
            
            -- Build player info
            local playerInfo = {
                id = targetId,
                name = targetName,
                license = license,
                discord = discord,
                steam = steam,
                ip = ip,
                bans = banCount,
                kicks = 0,
                warns = 0,
                playtime = "Unknown",
                firstJoin = "Unknown",
                lastSeen = "Now (Online)",
                screenshots = screenshotList,
                logs = logList
            }
            
            print('[DEBUG] Sending player info to client ' .. source)
            print('[DEBUG] Screenshots count: ' .. #screenshotList)
            print('[DEBUG] Logs count: ' .. #logList)
            -- Send to client
            TriggerClientEvent('admin:showPlayerInfo', source, playerInfo)
            print('[DEBUG] Player info sent!')
        end
    )
end, false)


-- ============================================
-- ANTI-VPN SYSTEM
-- Checks for VPN/Proxy on player connect
-- ============================================

local vpnCache = {}  -- Cache checked IPs to save API requests

-- Load cache from file (optional - for persistence across restarts)
CreateThread(function()
    -- You could load from database here if needed
    print('[ANTI-VPN] System initialized')
end)

-- Check if IP is using VPN/Proxy
local function CheckVPN(ip, callback)
    if not Config.AntiVPN or not Config.AntiVPN.enabled then
        callback(false, nil)
        return
    end
    
    -- Check whitelist
    if Config.AntiVPN.whitelist[ip] then
        print('[ANTI-VPN] IP ' .. ip .. ' is whitelisted')
        callback(false, nil)
        return
    end
    
    -- Check cache
    if vpnCache[ip] then
        local cached = vpnCache[ip]
        local age = os.time() - cached.timestamp
        
        if age < Config.AntiVPN.cacheDuration then
            print('[ANTI-VPN] Using cached result for ' .. ip .. ' (age: ' .. math.floor(age/3600) .. 'h)')
            callback(cached.isVPN, cached.data)
            return
        else
            print('[ANTI-VPN] Cache expired for ' .. ip)
            vpnCache[ip] = nil
        end
    end
    
    -- Make API request
    local apiUrl = 'http://proxycheck.io/v2/' .. ip .. '?key=' .. Config.AntiVPN.apiKey .. '&vpn=1&asn=1&risk=1'
    
    print('[ANTI-VPN] Checking IP: ' .. ip)
    
    PerformHttpRequest(apiUrl, function(statusCode, response, headers)
        if statusCode ~= 200 then
            print('[ANTI-VPN] API Error: Status ' .. statusCode)
            callback(false, nil)
            return
        end
        
        local success, data = pcall(function() return json.decode(response) end)
        
        if not success or not data then
            print('[ANTI-VPN] Failed to parse API response')
            callback(false, nil)
            return
        end
        
        local ipData = data[ip]
        if not ipData then
            print('[ANTI-VPN] No data for IP')
            callback(false, nil)
            return
        end
        
        local isVPN = ipData.proxy == 'yes'
        local vpnType = ipData.type or 'Unknown'
        local country = ipData.country or 'Unknown'
        local risk = ipData.risk or 0
        
        -- Cache result
        vpnCache[ip] = {
            isVPN = isVPN,
            timestamp = os.time(),
            data = {
                type = vpnType,
                country = country,
                risk = risk,
                provider = ipData.provider or 'Unknown'
            }
        }
        
        if isVPN then
            print('[ANTI-VPN] ⚠️ VPN DETECTED! IP: ' .. ip .. ' | Type: ' .. vpnType .. ' | Country: ' .. country .. ' | Risk: ' .. risk)
        else
            print('[ANTI-VPN] ✅ Clean IP: ' .. ip .. ' | Country: ' .. country)
        end
        
        callback(isVPN, vpnCache[ip].data)
    end, 'GET')
end

-- Player connecting event

-- Command to check IP manually (admin only)
RegisterCommand('checkip', function(source, args, rawCommand)
    if source == 0 then
        print('[ANTI-VPN] Usage: checkip [ip]')
        return
    end
    
    local adminGroup = GetAdminGroup(source)
    if not adminGroup then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            args = {"Anti-VPN", "No permission!"}
        })
        return
    end
    
    if not args[1] then
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 100, 100},
            args = {"Anti-VPN", "Usage: /checkip [ip]"}
        })
        return
    end
    
    local ip = args[1]
    
    TriggerClientEvent('chat:addMessage', source, {
        color = {100, 200, 255},
        args = {"Anti-VPN", "Checking IP: " .. ip .. "..."}
    })
    
    CheckVPN(ip, function(isVPN, data)
        if isVPN and data then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 50, 50},
                args = {"Anti-VPN", "⚠️ VPN DETECTED! Type: " .. (data.type or 'Unknown') .. " | Country: " .. (data.country or 'Unknown') .. " | Risk: " .. (data.risk or 0) .. "%"}
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {50, 255, 50},
                args = {"Anti-VPN", "✅ Clean IP | Country: " .. (data and data.country or 'Unknown')}
            })
        end
    end)
end, false)

-- Command to clear VPN cache
RegisterCommand('clearvpncache', function(source, args, rawCommand)
    if source ~= 0 then
        local adminGroup = GetAdminGroup(source)
        if not adminGroup or adminGroup ~= 'superadmin' then
            return
        end
    end
    
    vpnCache = {}
    print('[ANTI-VPN] Cache cleared!')
    
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 255, 100},
            args = {"Anti-VPN", "Cache cleared!"}
        })
    end
end, false)
