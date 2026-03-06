-- ============================================
-- aether ANTICHEAT - CLIENT SIDE v4.5.0
-- Advanced Protection System
-- ============================================

-- ============================================
-- DEBUG HELPER FUNCTION
-- ============================================
local function DebugPrint(message)
    if Config and Config.Debug then
        print(message)
    end
end

-- ============================================
-- FANCY CONSOLE OUTPUT
-- ============================================
local function PrintFancyBanner()
    local colors = {
        red = "^1",
        green = "^2", 
        yellow = "^3",
        blue = "^4",
        cyan = "^5",
        purple = "^6",
        white = "^7",
        orange = "^8",
        reset = "^0"
    }
    
    DebugPrint("")
    DebugPrint(colors.cyan .. "╔═══════════════════════════════════════════════════════════════════════════╗")
    DebugPrint(colors.cyan .. "║" .. colors.purple .. "      █████╗ ███████╗████████╗██╗  ██╗███████╗██████╗                      " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.purple .. "     ██╔══██╗██╔════╝╚══██╔══╝██║  ██║██╔════╝██╔══██╗                     " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.purple .. "     ███████║█████╗     ██║   ███████║█████╗  ██████╔╝                     " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.purple .. "     ██╔══██║██╔══╝     ██║   ██╔══██║██╔══╝  ██╔══██╗                     " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.purple .. "     ██║  ██║███████╗   ██║   ██║  ██║███████╗██║  ██║                     " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.purple .. "     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝                     " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "╠═══════════════════════════════════════════════════════════════════════════╣")
    DebugPrint(colors.cyan .. "║" .. colors.yellow .. "      █████╗ ███╗   ██╗████████╗██╗ ██████╗██╗  ██╗███████╗ █████╗ ████████╗" .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.yellow .. "     ██╔══██╗████╗  ██║╚══██╔══╝██║██╔════╝██║  ██║██╔════╝██╔══██╗╚══██╔══╝" .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.yellow .. "     ███████║██╔██╗ ██║   ██║   ██║██║     ███████║█████╗  ███████║   ██║   " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.yellow .. "     ██╔══██║██║╚██╗██║   ██║   ██║██║     ██╔══██║██╔══╝  ██╔══██║   ██║   " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.yellow .. "     ██║  ██║██║ ╚████║   ██║   ██║╚██████╗██║  ██║███████╗██║  ██║   ██║   " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.yellow .. "     ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "╠═══════════════════════════════════════════════════════════════════════════╣")
    DebugPrint(colors.cyan .. "║" .. colors.white .. "                    ADVANCED PROTECTION SYSTEM v4.5.0                     " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "║" .. colors.green .. "                         Coded by konpep                                  " .. colors.cyan .. "║")
    DebugPrint(colors.cyan .. "╚═══════════════════════════════════════════════════════════════════════════╝" .. colors.reset)
    DebugPrint("")
end

local function PrintProtectionStatus()
    local colors = {
        red = "^1",
        green = "^2", 
        yellow = "^3",
        blue = "^4",
        cyan = "^5",
        purple = "^6",
        white = "^7",
        orange = "^8",
        reset = "^0"
    }
    
    local check = colors.green .. "✓" .. colors.reset
    local shield = colors.cyan .. "🛡️" .. colors.reset
    
    DebugPrint(colors.purple .. "┌─────────────────────────────────────────────────────────────────┐")
    DebugPrint(colors.purple .. "│" .. colors.yellow .. "                    ⚡ PROTECTION MODULES LOADED ⚡               " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "├─────────────────────────────────────────────────────────────────┤")
    DebugPrint(colors.purple .. "│                                                                 │")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Godmode v5.0 (8 Methods)   " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Invincible Flag Detection" .. colors.purple .. "                                │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Super Health/Armor Detection" .. colors.purple .. "                             │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Fall Damage Immunity Detection" .. colors.purple .. "                           │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Bullet Immunity Detection" .. colors.purple .. "                                │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Explosion Immunity Detection" .. colors.purple .. "                             │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Fire Immunity Detection" .. colors.purple .. "                                  │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "└─ Drowning Immunity Detection" .. colors.purple .. "                              │")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Teleport Detection         " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Noclip v3.0 (6 Methods)    " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Wall Passing Detection (Multi-Raycast)" .. colors.purple .. "                    │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Impossible Acceleration Detection" .. colors.purple .. "                         │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Floating in Air Detection" .. colors.purple .. "                                 │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Phase Through Objects Detection" .. colors.purple .. "                           │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Swimming in Air Detection" .. colors.purple .. "                                 │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "└─ Velocity/Animation Mismatch Detection" .. colors.purple .. "                     │")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Freecam Detection          " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Invisible Detection        " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Aimbot v3.0 (10 Methods)   " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Silent Aim Detection" .. colors.purple .. "                                      │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Headshot Rate Analysis" .. colors.purple .. "                                    │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Bone Lock Detection" .. colors.purple .. "                                       │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Aim Snap Detection" .. colors.purple .. "                                        │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Smooth Aimbot Detection" .. colors.purple .. "                                   │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ Triggerbot Detection" .. colors.purple .. "                                      │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "├─ No Recoil Detection" .. colors.purple .. "                                       │")
    DebugPrint(colors.purple .. "│    " .. colors.cyan .. "└─ Target Switch Speed Analysis" .. colors.purple .. "                              │")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Silent Aim Detection       " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Wallhack Detection         " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-ESP Detection              " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Resource Stop              " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Self Heal/Revive           " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Spoofed Weapons            " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Spoofed Vehicles           " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Anti-Illegal Peds               " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Heartbeat System                " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Spawn Protection System         " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Admin Action Protection         " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│  " .. check .. colors.white .. " Safezone Protection             " .. colors.green .. "[ACTIVE]" .. colors.white .. "   " .. shield .. "              " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "│                                                                 │")
    DebugPrint(colors.purple .. "├─────────────────────────────────────────────────────────────────┤")
    DebugPrint(colors.purple .. "│" .. colors.cyan .. "              ALL SYSTEMS OPERATIONAL - YOU ARE PROTECTED        " .. colors.purple .. "│")
    DebugPrint(colors.purple .. "└─────────────────────────────────────────────────────────────────┘" .. colors.reset)
    DebugPrint("")
    DebugPrint(colors.cyan .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. colors.reset)
    DebugPrint(colors.green .. "  🎮 Aether Anticheat v4.5.0 - Client Initialized Successfully!")
    DebugPrint(colors.purple .. "  💜 Coded by konpep")
    DebugPrint(colors.cyan .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" .. colors.reset)
    DebugPrint("")
end

-- Print banner on load (only if debug is on)
CreateThread(function()
    Wait(2000) -- Wait for config to load
    if Config and Config.Debug then
        PrintFancyBanner()
        PrintProtectionStatus()
    end
end)

local isAdmin = false
local debugModeEnabled = false
local playerWeapons = {}
local anticheatActive = true

-- Violation counters
local teleportViolations = 0
local godmodeViolations = 0
local noclipViolations = 0
local freecamViolations = 0

-- Position tracking
local lastPosition = nil
local lastPositionTime = 0
local positionHistory = {}

-- Godmode detection
local lastDamageTime = 0
local damageReceived = false
local healthHistory = {}

-- Self heal/revive detection
local selfHealData = {
    lastHealth = 0,
    lastArmor = 0,
    violations = 0,
    lastDeathTime = 0,
    wasDeadRecently = false
}

-- Build lookup tables
local blacklistedVehicles = {}
local blacklistedPeds = {}
local blacklistedWeapons = {}

-- ============================================
-- SPAWN PROTECTION SYSTEM
-- Allows other scripts (aether_spawn) to temporarily disable checks
-- ============================================
local spawnProtection = {
    active = false,
    endTime = 0,
    duration = 10000 -- 10 seconds default
}

-- ============================================
-- ADMIN ACTION PROTECTION SYSTEM
-- When admin does bring/heal/revive/teleport on a player,
-- anticheat ignores checks for that player temporarily
-- ============================================
local adminActionProtection = {
    active = false,
    endTime = 0,
    reason = ''
}

-- Called from server when admin performs action on this player
RegisterNetEvent('anticheat:adminActionProtection', function(actionType, duration)
    adminActionProtection.active = true
    adminActionProtection.endTime = GetGameTimer() + (duration or 5000)
    adminActionProtection.reason = actionType or 'admin_action'
    -- Reset violation counters
    selfHealData.violations = 0
    selfHealData.wasDeadRecently = false
    teleportViolations = 0
    godmodeViolations = 0
    DebugPrint('[ANTICHEAT] Admin action protection ENABLED: ' .. adminActionProtection.reason .. ' for ' .. (duration or 5000) .. 'ms')
end)

-- Check if admin action protection is active
local function IsAdminActionProtected()
    if not adminActionProtection.active then return false end
    if GetGameTimer() > adminActionProtection.endTime then
        adminActionProtection.active = false
        DebugPrint('[ANTICHEAT] Admin action protection EXPIRED')
        return false
    end
    return true
end

-- ============================================
-- SAFEZONE PROTECTION SYSTEM
-- When player is in a safezone (hrs_zombies, etc), godmode is allowed
-- Other scripts can call this to tell anticheat player is in safezone
-- ============================================
local safezoneProtection = {
    active = false,
    zoneName = ''
}

-- Export: Call this from any script when player enters/exits safezone
-- Usage: exports['aether_admin']:SetSafezoneProtection(true, 'greenzone')
local function SetSafezoneProtection(enabled, zoneName)
    safezoneProtection.active = enabled
    safezoneProtection.zoneName = zoneName or 'safezone'
    if enabled then
        -- Reset godmode violations when entering safezone
        godmodeViolations = 0
        DebugPrint('[ANTICHEAT] Safezone protection ENABLED: ' .. safezoneProtection.zoneName)
    else
        DebugPrint('[ANTICHEAT] Safezone protection DISABLED')
    end
end

-- Export the function
exports('SetSafezoneProtection', SetSafezoneProtection)

-- Event alternative (for scripts that prefer events)
-- Usage: TriggerEvent('anticheat:setSafezoneProtection', true, 'greenzone')
RegisterNetEvent('anticheat:setSafezoneProtection', function(enabled, zoneName)
    SetSafezoneProtection(enabled, zoneName)
end)

-- Also listen for common safezone events from other scripts
AddEventHandler('safezone:enter', function(zoneName)
    SetSafezoneProtection(true, zoneName or 'safezone')
end)

AddEventHandler('safezone:exit', function()
    SetSafezoneProtection(false)
end)

-- hrs_zombies specific events (if they use these)
AddEventHandler('hrs_zombies:enterSafezone', function(zoneName)
    SetSafezoneProtection(true, zoneName or 'hrs_safezone')
end)

AddEventHandler('hrs_zombies:exitSafezone', function()
    SetSafezoneProtection(false)
end)

-- Check if safezone protection is active
local function IsInSafezone()
    return safezoneProtection.active
end

-- Export: Call this from aether_spawn when player spawns
-- Usage: exports['aether_admin']:SetSpawnProtection(true)
local function SetSpawnProtection(enabled, duration)
    if enabled then
        spawnProtection.active = true
        spawnProtection.endTime = GetGameTimer() + (duration or spawnProtection.duration)
        -- Reset violation counters
        selfHealData.violations = 0
        selfHealData.wasDeadRecently = false
        teleportViolations = 0
        godmodeViolations = 0
        DebugPrint('[ANTICHEAT] Spawn protection ENABLED for ' .. (duration or spawnProtection.duration) .. 'ms')
    else
        spawnProtection.active = false
        DebugPrint('[ANTICHEAT] Spawn protection DISABLED')
    end
end

-- Export the function
exports('SetSpawnProtection', SetSpawnProtection)

-- Event alternative (if exports don't work)
RegisterNetEvent('anticheat:setSpawnProtection', function(enabled, duration)
    SetSpawnProtection(enabled, duration)
end)

-- Check if spawn protection is active
local function IsSpawnProtected()
    if not spawnProtection.active then return false end
    if GetGameTimer() > spawnProtection.endTime then
        spawnProtection.active = false
        DebugPrint('[ANTICHEAT] Spawn protection EXPIRED')
        return false
    end
    return true
end

local function ShouldCheckPlayer()
    -- Spawn protection = skip all checks
    if IsSpawnProtected() then return false end
    -- Admin action protection = skip all checks
    if IsAdminActionProtected() then return false end
    -- Debug mode = ENABLE checks for admin (to test if anticheat catches you)
    if debugModeEnabled then return true end
    return not isAdmin
end

-- ============================================
-- ANTI-RESOURCE STOP - STRICT MODE
-- Protects ALL server scripts from being stopped
-- ANY resource stop = INSTANT BAN (3 second grace period for legit restarts)
-- ============================================
local protectedResources = {} -- All running server resources
local allowedToStop = {} -- Resources that admin is restarting
local resourceStopPending = {} -- Track pending stops for 3 second ban

-- Receive all protected resources from server
RegisterNetEvent('anticheat:setProtectedResources', function(resources)
    protectedResources = resources or {}
    DebugPrint('[ANTICHEAT] Protected ' .. (resources and #resources or 0) .. ' server resources')
end)

-- Admin is restarting a resource (temporary allow)
RegisterNetEvent('anticheat:allowResourceStop', function(resourceName)
    allowedToStop[resourceName] = true
    DebugPrint('[ANTICHEAT] Temporarily allowing stop for: ' .. resourceName)
    -- Remove after 10 seconds
    SetTimeout(10000, function()
        allowedToStop[resourceName] = nil
    end)
end)

-- STRICT: Monitor ALL resource stops
AddEventHandler('onResourceStop', function(resourceName)
    -- Skip if not checking this player (admin with whitelist)
    if not ShouldCheckPlayer() then return end
    
    -- Skip if admin is legitimately restarting this resource
    if allowedToStop[resourceName] then 
        DebugPrint('[ANTICHEAT] Allowed resource stop: ' .. resourceName)
        return 
    end
    
    -- Skip client-side only resources (not protected by server)
    if not protectedResources[resourceName] then
        return
    end
    
    DebugPrint('[ANTICHEAT] ⚠️ RESOURCE STOP DETECTED: ' .. resourceName)
    
    -- Track this stop - if not cancelled in 3 seconds = BAN
    resourceStopPending[resourceName] = GetGameTimer()
    
    -- Immediately notify server
    TriggerServerEvent('anticheat:resourceStopDetected', resourceName)
    
    -- After 3 seconds, if still pending = CONFIRMED CHEAT = BAN
    SetTimeout(3000, function()
        if resourceStopPending[resourceName] then
            DebugPrint('[ANTICHEAT] 🚨 CONFIRMED CHEAT - Resource stop not cancelled: ' .. resourceName)
            TriggerServerEvent('anticheat:resourceStopped', resourceName, 'cheat_confirmed')
            resourceStopPending[resourceName] = nil
        end
    end)
end)

-- If resource starts again within 3 seconds, cancel the ban (was legit restart)
AddEventHandler('onResourceStart', function(resourceName)
    if resourceStopPending[resourceName] then
        DebugPrint('[ANTICHEAT] Resource restarted - cancelling ban: ' .. resourceName)
        resourceStopPending[resourceName] = nil
    end
end)

-- ============================================
-- HEARTBEAT SYSTEM - Server checks if client is alive
-- If client stops responding = anticheat was disabled = BAN
-- ============================================
RegisterNetEvent('anticheat:heartbeatCheck', function()
    TriggerServerEvent('anticheat:heartbeatResponse')
end)

-- Also send heartbeat automatically every 5 seconds
CreateThread(function()
    Wait(5000)
    while true do
        TriggerServerEvent('anticheat:heartbeatResponse')
        Wait(5000)
    end
end)

-- ============================================
-- SERVER HEALTH CHECK - Server requests client to verify health
-- ============================================
RegisterNetEvent('anticheat:serverHealthCheck', function()
    if not ShouldCheckPlayer() then return end
    if IsInSafezone() then return end
    
    local ped = PlayerPedId()
    local playerId = PlayerId()
    
    if IsEntityDead(ped) then return end
    
    -- Check invincible flag (server can't check this directly)
    local isInvincible = GetPlayerInvincible(playerId)
    if isInvincible then
        DebugPrint('[ANTICHEAT] Server health check: Invincible flag detected!')
        TriggerServerEvent('anticheat:godmodeDetected', 'server_check_invincible')
    end
    
    -- Check health values
    local health = GetEntityHealth(ped)
    local armor = GetPedArmour(ped)
    local maxHealth = GetEntityMaxHealth(ped)
    
    if health > 250 then
        DebugPrint('[ANTICHEAT] Server health check: Super health detected! ' .. health)
        TriggerServerEvent('anticheat:godmodeDetected', 'server_check_health_' .. health)
    end
    
    if armor > 100 then
        DebugPrint('[ANTICHEAT] Server health check: Super armor detected! ' .. armor)
        TriggerServerEvent('anticheat:godmodeDetected', 'server_check_armor_' .. armor)
    end
    
    if maxHealth > 300 then
        DebugPrint('[ANTICHEAT] Server health check: Modified max health! ' .. maxHealth)
        TriggerServerEvent('anticheat:godmodeDetected', 'server_check_maxhealth_' .. maxHealth)
    end
end)

-- ============================================
-- ANTI-FREECAM DETECTION v2 (REMOVED - Use unified system at bottom)
-- ============================================
-- Logic moved to unified system to prevent conflicts

-- Helper function to normalize vector
function norm(v)
    local len = #v
    if len > 0 then
        return vector3(v.x / len, v.y / len, v.z / len)
    end
    return vector3(0, 0, 0)
end

-- ============================================
-- BLACKLISTED SCREEN TEXT DETECTION
-- Detects cheat menus by scanning for suspicious text
-- ============================================
local blacklistedTexts = {
    -- Menu names
    'eulen', 'eulenmenu', 'skid', 'lynx', 'hammafia', 'redengine',
    'brutan', 'dopamine', 'cherax', 'stand', 'kiddion', 'impulse',
    'phantom', 'paragon', 'disturbed', 'ozark', 'luna', '2take1',
    -- Cheat features
    'godmode', 'god mode', 'noclip', 'no clip', 'teleport', 'esp',
    'aimbot', 'triggerbot', 'wallhack', 'speedhack', 'flyhack',
    'money drop', 'money hack', 'rp hack', 'level hack',
    'vehicle spawn', 'weapon spawn', 'infinite ammo', 'no reload',
    'super jump', 'fast run', 'invisible', 'invincible',
    -- Lua executor
    'lua executor', 'script executor', 'execute lua', 'run script',
    'inject', 'injector', 'dll inject', 'mod menu', 'cheat menu',
    'trainer', 'hack menu', 'exploit',
}

-- Check for suspicious natives being called
local suspiciousNatives = {
    'SetEntityInvincible',
    'SetPlayerInvincible', 
    'SetEntityVisible',
    'SetEntityCollision',
    'FreezeEntityPosition',
}

-- ============================================
-- INITIALIZE
-- ============================================
CreateThread(function()
    Wait(1000)
    -- Build blacklisted vehicles lookup (NEW - blacklist instead of whitelist)
    for _, v in ipairs(Config.BlacklistedVehicles or {}) do
        blacklistedVehicles[GetHashKey(v)] = true
        blacklistedVehicles[v:lower()] = true
    end
    for _, p in ipairs(Config.BlacklistedPeds or {}) do
        blacklistedPeds[GetHashKey(p)] = true
    end
    for _, w in ipairs(Config.BlacklistedWeapons or {}) do
        blacklistedWeapons[GetHashKey(w)] = true
    end
    
    -- Notify server that anticheat started
    TriggerServerEvent('anticheat:clientStarted')
    DebugPrint('[ANTICHEAT] Client v3.0 initialized')
    DebugPrint('[ANTICHEAT] Blacklisted vehicles: ' .. #(Config.BlacklistedVehicles or {}))
end)

-- Admin check
CreateThread(function()
    Wait(3000)
    TriggerServerEvent('aether_admin:checkPermission')
end)

RegisterNetEvent('aether_admin:permissionResult', function(result)
    isAdmin = result
end)

RegisterNetEvent('anticheat:setDebugMode', function(enabled)
    debugModeEnabled = enabled
    SendNUIMessage({ action = 'updateDebugMode', enabled = enabled })
end)

RegisterNetEvent('anticheat:updateInventoryWeapons', function(weapons)
    playerWeapons = weapons or {}
end)

-- ============================================
-- ADVANCED ANTI-GODMODE v5.0
-- Multiple detection methods with damage testing
-- Detects: Invincible flag, no damage taken, fall damage immunity, bullet immunity
-- ============================================

-- Get config values with defaults
local function GetACConfig(key, default)
    if Config and Config.Anticheat and Config.Anticheat[key] ~= nil then
        return Config.Anticheat[key]
    end
    return default
end

local function GetViolationsNeeded(detectionType)
    if Config and Config.Anticheat and Config.Anticheat.violations then
        return Config.Anticheat.violations[detectionType] or 1
    end
    return 1 -- Default: instant ban
end

local function GetThreshold(key, default)
    if Config and Config.Anticheat and Config.Anticheat.thresholds then
        return Config.Anticheat.thresholds[key] or default
    end
    return default
end

local godmodeData = {
    invincibleCount = 0,
    lastDamageTime = 0,
    lastHealth = 200,
    lastArmor = 0,
    damageTestPending = false,
    combatNoDamageTime = 0,
    -- Damage tracking
    damageEvents = {},
    expectedDamage = 0,
    -- Fall damage tracking
    fallStartHeight = 0,
    isFalling = false,
    fallDamageExpected = false,
    -- Combat tracking
    inCombat = false,
    combatStartTime = 0,
    shotsTaken = 0,
    damageReceived = 0,
    -- Violation tracking
    noDamageViolations = 0,
    fallDamageViolations = 0,
    bulletImmuneViolations = 0
}

-- Track when player takes damage
local function OnPlayerDamaged(damageAmount)
    godmodeData.lastDamageTime = GetGameTimer()
    godmodeData.damageReceived = godmodeData.damageReceived + damageAmount
    godmodeData.noDamageViolations = 0
    godmodeData.bulletImmuneViolations = 0
end

-- Track damage events
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local isFatal = args[4] == 1
        local weaponHash = args[7]
        
        -- Check if WE are the victim
        if victim == PlayerPedId() then
            local damageAmount = args[6] or 0
            OnPlayerDamaged(damageAmount)
            godmodeData.shotsTaken = godmodeData.shotsTaken + 1
            
            -- Reset fall damage violations if we took damage
            godmodeData.fallDamageViolations = 0
        end
    end
end)

-- Main godmode detection thread
CreateThread(function()
    Wait(20000) -- Wait before starting
    
    while true do
        Wait(2000)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            local playerId = PlayerId()
            
            -- Skip checks if dead
            if IsEntityDead(ped) then
                godmodeData.invincibleCount = 0
                godmodeData.noDamageViolations = 0
                godmodeData.fallDamageViolations = 0
                godmodeData.bulletImmuneViolations = 0
                goto skipGodmode
            end
            
            -- Skip checks if in safezone
            if IsInSafezone() then
                godmodeData.invincibleCount = 0
                goto skipGodmode
            end
            
            local health = GetEntityHealth(ped)
            local armor = GetPedArmour(ped)
            local maxHealth = GetThreshold('maxHealth', 250)
            local maxArmor = GetThreshold('maxArmor', 100)
            local violationsNeeded = GetViolationsNeeded('invincibleFlag')
            
            -- ═══════════════════════════════════════════
            -- METHOD 1: Check GetPlayerInvincible flag
            -- ═══════════════════════════════════════════
            local isInvincible = GetPlayerInvincible(playerId)
            if isInvincible then
                godmodeData.invincibleCount = godmodeData.invincibleCount + 1
                DebugPrint('[ANTICHEAT] Invincible flag ON! Count: ' .. godmodeData.invincibleCount .. '/' .. violationsNeeded)
                
                if godmodeData.invincibleCount >= violationsNeeded then
                    DebugPrint('[ANTICHEAT] 🚨 GODMODE CONFIRMED - Invincible flag!')
                    TriggerServerEvent('anticheat:godmodeDetected', 'invincible_flag')
                    godmodeData.invincibleCount = 0
                end
            else
                godmodeData.invincibleCount = math.max(0, godmodeData.invincibleCount - 1)
            end
            
            -- ═══════════════════════════════════════════
            -- METHOD 2: Check super armor (instant)
            -- ═══════════════════════════════════════════
            if armor > maxArmor then
                DebugPrint('[ANTICHEAT] 🚨 SUPER ARMOR DETECTED: ' .. armor)
                TriggerServerEvent('anticheat:godmodeDetected', 'super_armor_' .. armor)
            end
            
            -- ═══════════════════════════════════════════
            -- METHOD 3: Check super health (instant)
            -- ═══════════════════════════════════════════
            if health > maxHealth then
                DebugPrint('[ANTICHEAT] 🚨 SUPER HEALTH DETECTED: ' .. health)
                TriggerServerEvent('anticheat:godmodeDetected', 'super_health_' .. health)
            end
            
            -- Store for next check
            godmodeData.lastHealth = health
            godmodeData.lastArmor = armor
            
            ::skipGodmode::
        end
    end
end)

-- ═══════════════════════════════════════════
-- METHOD 4: FALL DAMAGE DETECTION
-- If player falls from height and takes no damage = godmode
-- ═══════════════════════════════════════════
CreateThread(function()
    Wait(25000)
    
    while true do
        Wait(100)
        
        if ShouldCheckPlayer() and not IsInSafezone() then
            local ped = PlayerPedId()
            
            if not IsEntityDead(ped) then
                local coords = GetEntityCoords(ped)
                local groundZ = 0.0
                local foundGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)
                local heightAboveGround = coords.z - groundZ
                local isFalling = IsPedFalling(ped) or GetEntityHeightAboveGround(ped) > 3.0
                local velocity = GetEntityVelocity(ped)
                local fallSpeed = -velocity.z -- Negative Z = falling down
                
                local fallHeight = GetThreshold('fallHeight', 15.0)
                local fallMinDamage = GetThreshold('fallMinDamage', 10)
                local violationsNeeded = GetViolationsNeeded('fallDamage')
                
                -- Start tracking fall
                if isFalling and not godmodeData.isFalling and heightAboveGround > 10.0 then
                    godmodeData.isFalling = true
                    godmodeData.fallStartHeight = coords.z
                    godmodeData.fallDamageExpected = false
                end
                
                -- Check when landing
                if godmodeData.isFalling and not isFalling then
                    local fallDistance = godmodeData.fallStartHeight - coords.z
                    local healthBefore = godmodeData.lastHealth
                    local healthAfter = GetEntityHealth(ped)
                    
                    -- If fell more than threshold meters, should take damage
                    if fallDistance > fallHeight then
                        godmodeData.fallDamageExpected = true
                        
                        -- Wait a moment for damage to register
                        Wait(500)
                        
                        local healthNow = GetEntityHealth(ped)
                        local damageTaken = healthBefore - healthNow
                        
                        -- If fell and took less than minimum damage = suspicious
                        if damageTaken < fallMinDamage and not IsEntityDead(ped) then
                            godmodeData.fallDamageViolations = godmodeData.fallDamageViolations + 1
                            DebugPrint('[ANTICHEAT] ⚠️ NO FALL DAMAGE! Fell ' .. math.floor(fallDistance) .. 'm, Damage: ' .. damageTaken .. ', Violations: ' .. godmodeData.fallDamageViolations .. '/' .. violationsNeeded)
                            
                            if godmodeData.fallDamageViolations >= violationsNeeded then
                                DebugPrint('[ANTICHEAT] 🚨 GODMODE CONFIRMED - Fall damage immunity!')
                                TriggerServerEvent('anticheat:godmodeDetected', 'fall_damage_immune_' .. math.floor(fallDistance) .. 'm')
                                godmodeData.fallDamageViolations = 0
                            end
                        else
                            -- Took damage, reset violations
                            godmodeData.fallDamageViolations = 0
                        end
                    end
                    
                    godmodeData.isFalling = false
                    godmodeData.fallStartHeight = 0
                end
            end
        else
            godmodeData.isFalling = false
        end
    end
end)

-- ═══════════════════════════════════════════
-- METHOD 5: COMBAT DAMAGE DETECTION
-- If player is being shot but health doesn't decrease = godmode
-- ═══════════════════════════════════════════
CreateThread(function()
    Wait(30000)
    
    local lastCombatCheck = 0
    local combatHealthStart = 200
    local combatShotsStart = 0
    
    while true do
        Wait(500)
        
        if ShouldCheckPlayer() and not IsInSafezone() then
            local ped = PlayerPedId()
            
            if not IsEntityDead(ped) then
                local isInCombat = IsPedInMeleeCombat(ped) or IsPedBeingStunned(ped, 0) or IsEntityOnFire(ped)
                local health = GetEntityHealth(ped)
                local armor = GetPedArmour(ped)
                local totalProtection = health + armor
                
                local bulletMinShots = GetThreshold('bulletMinShots', 5)
                local bulletMinDamage = GetThreshold('bulletMinDamage', 20)
                local violationsNeeded = GetViolationsNeeded('bulletImmune')
                
                -- Check if someone is shooting at us (by checking if we're a target)
                local isBeingTargeted = false
                for _, player in ipairs(GetActivePlayers()) do
                    if player ~= PlayerId() then
                        local otherPed = GetPlayerPed(player)
                        if DoesEntityExist(otherPed) and not IsEntityDead(otherPed) then
                            if IsPlayerFreeAimingAtEntity(player, ped) or IsPedShooting(otherPed) then
                                local dist = #(GetEntityCoords(ped) - GetEntityCoords(otherPed))
                                if dist < 100.0 then
                                    isBeingTargeted = true
                                    break
                                end
                            end
                        end
                    end
                end
                
                -- Start combat tracking
                if isBeingTargeted and not godmodeData.inCombat then
                    godmodeData.inCombat = true
                    godmodeData.combatStartTime = GetGameTimer()
                    combatHealthStart = totalProtection
                    combatShotsStart = godmodeData.shotsTaken
                    godmodeData.damageReceived = 0
                end
                
                -- Check combat results after 5 seconds
                if godmodeData.inCombat then
                    local combatDuration = GetGameTimer() - godmodeData.combatStartTime
                    
                    if combatDuration > 5000 then
                        local shotsReceived = godmodeData.shotsTaken - combatShotsStart
                        local healthLost = combatHealthStart - totalProtection
                        
                        -- If received enough shots but lost less than minimum damage = suspicious
                        if shotsReceived >= bulletMinShots and healthLost < bulletMinDamage and not IsEntityDead(ped) then
                            godmodeData.bulletImmuneViolations = godmodeData.bulletImmuneViolations + 1
                            DebugPrint('[ANTICHEAT] ⚠️ BULLET IMMUNITY! Shots: ' .. shotsReceived .. ', Damage: ' .. healthLost .. ', Violations: ' .. godmodeData.bulletImmuneViolations .. '/' .. violationsNeeded)
                            
                            if godmodeData.bulletImmuneViolations >= violationsNeeded then
                                DebugPrint('[ANTICHEAT] 🚨 GODMODE CONFIRMED - Bullet immunity!')
                                TriggerServerEvent('anticheat:godmodeDetected', 'bullet_immune_' .. shotsReceived .. '_shots')
                                godmodeData.bulletImmuneViolations = 0
                            end
                        elseif healthLost > bulletMinDamage then
                            -- Took damage, reset violations
                            godmodeData.bulletImmuneViolations = 0
                        end
                        
                        -- Reset combat tracking
                        godmodeData.inCombat = false
                    end
                end
                
                -- End combat if not being targeted for 3 seconds
                if godmodeData.inCombat and not isBeingTargeted then
                    local timeSinceCombat = GetGameTimer() - godmodeData.combatStartTime
                    if timeSinceCombat > 3000 then
                        godmodeData.inCombat = false
                    end
                end
            end
        else
            godmodeData.inCombat = false
        end
    end
end)

-- ═══════════════════════════════════════════
-- METHOD 6: EXPLOSION DAMAGE DETECTION
-- If player is near explosion but takes no damage = godmode
-- ═══════════════════════════════════════════
CreateThread(function()
    Wait(35000)
    
    local lastExplosionCheck = 0
    
    while true do
        Wait(200)
        
        if ShouldCheckPlayer() and not IsInSafezone() then
            local ped = PlayerPedId()
            
            if not IsEntityDead(ped) then
                local coords = GetEntityCoords(ped)
                local healthBefore = GetEntityHealth(ped)
                
                local explosionMinDamage = GetThreshold('explosionMinDamage', 15)
                local violationsNeeded = GetViolationsNeeded('explosionImmune')
                
                -- Check if there's an explosion nearby
                local isNearExplosion = IsExplosionInArea(0, coords.x - 10.0, coords.y - 10.0, coords.z - 5.0, coords.x + 10.0, coords.y + 10.0, coords.z + 5.0)
                    or IsExplosionInArea(1, coords.x - 10.0, coords.y - 10.0, coords.z - 5.0, coords.x + 10.0, coords.y + 10.0, coords.z + 5.0)
                    or IsExplosionInArea(2, coords.x - 10.0, coords.y - 10.0, coords.z - 5.0, coords.x + 10.0, coords.y + 10.0, coords.z + 5.0)
                    or IsExplosionInArea(4, coords.x - 10.0, coords.y - 10.0, coords.z - 5.0, coords.x + 10.0, coords.y + 10.0, coords.z + 5.0)
                    or IsExplosionInArea(5, coords.x - 10.0, coords.y - 10.0, coords.z - 5.0, coords.x + 10.0, coords.y + 10.0, coords.z + 5.0)
                
                if isNearExplosion and GetGameTimer() - lastExplosionCheck > 3000 then
                    lastExplosionCheck = GetGameTimer()
                    
                    -- Wait for damage to register
                    Wait(500)
                    
                    local healthAfter = GetEntityHealth(ped)
                    local damageTaken = healthBefore - healthAfter
                    
                    -- If near explosion and took less than minimum damage = suspicious
                    if damageTaken < explosionMinDamage and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, false) then
                        godmodeData.noDamageViolations = godmodeData.noDamageViolations + 1
                        DebugPrint('[ANTICHEAT] ⚠️ EXPLOSION IMMUNITY! Damage: ' .. damageTaken .. ', Violations: ' .. godmodeData.noDamageViolations .. '/' .. violationsNeeded)
                        
                        if godmodeData.noDamageViolations >= violationsNeeded then
                            DebugPrint('[ANTICHEAT] 🚨 GODMODE CONFIRMED - Explosion immunity!')
                            TriggerServerEvent('anticheat:godmodeDetected', 'explosion_immune')
                            godmodeData.noDamageViolations = 0
                        end
                    elseif damageTaken > explosionMinDamage then
                        godmodeData.noDamageViolations = 0
                    end
                end
            end
        end
    end
end)

-- ═══════════════════════════════════════════
-- METHOD 7: FIRE DAMAGE DETECTION
-- If player is on fire but health doesn't decrease = godmode
-- ═══════════════════════════════════════════
CreateThread(function()
    Wait(40000)
    
    local fireStartHealth = 0
    local fireStartTime = 0
    local wasOnFire = false
    local fireViolations = 0
    
    while true do
        Wait(500)
        
        if ShouldCheckPlayer() and not IsInSafezone() then
            local ped = PlayerPedId()
            
            if not IsEntityDead(ped) then
                local isOnFire = IsEntityOnFire(ped)
                local health = GetEntityHealth(ped)
                
                local fireMinDamage = GetThreshold('fireMinDamage', 20)
                local fireDurationThreshold = GetThreshold('fireDuration', 3000)
                local violationsNeeded = GetViolationsNeeded('fireImmune')
                
                -- Start tracking fire damage
                if isOnFire and not wasOnFire then
                    wasOnFire = true
                    fireStartHealth = health
                    fireStartTime = GetGameTimer()
                end
                
                -- Check fire damage after threshold
                if wasOnFire and isOnFire then
                    local fireDuration = GetGameTimer() - fireStartTime
                    
                    if fireDuration > fireDurationThreshold then
                        local damageTaken = fireStartHealth - health
                        
                        -- If on fire and took less than minimum damage = suspicious
                        if damageTaken < fireMinDamage and not IsEntityDead(ped) then
                            fireViolations = fireViolations + 1
                            DebugPrint('[ANTICHEAT] ⚠️ FIRE IMMUNITY! Duration: ' .. math.floor(fireDuration/1000) .. 's, Damage: ' .. damageTaken .. ', Violations: ' .. fireViolations .. '/' .. violationsNeeded)
                            
                            if fireViolations >= violationsNeeded then
                                TriggerServerEvent('anticheat:godmodeDetected', 'fire_immune_' .. math.floor(fireDuration/1000) .. 's')
                                fireViolations = 0
                            end
                        else
                            fireViolations = 0
                        end
                        
                        -- Reset tracking
                        fireStartHealth = health
                        fireStartTime = GetGameTimer()
                    end
                end
                
                -- Reset when fire stops
                if not isOnFire and wasOnFire then
                    wasOnFire = false
                end
            end
        else
            wasOnFire = false
        end
    end
end)

-- ═══════════════════════════════════════════
-- METHOD 8: DROWNING DETECTION
-- If player is underwater too long without damage = godmode
-- ═══════════════════════════════════════════
CreateThread(function()
    Wait(45000)
    
    local underwaterStartTime = 0
    local underwaterStartHealth = 0
    local wasUnderwater = false
    local drownViolations = 0
    
    while true do
        Wait(1000)
        
        if ShouldCheckPlayer() and not IsInSafezone() then
            local ped = PlayerPedId()
            
            if not IsEntityDead(ped) then
                local isUnderwater = IsPedSwimmingUnderWater(ped)
                local health = GetEntityHealth(ped)
                
                local drownMinDamage = GetThreshold('drownMinDamage', 50)
                local drownDuration = GetThreshold('drownDuration', 30000)
                local violationsNeeded = GetViolationsNeeded('drownImmune')
                
                -- Start tracking underwater time
                if isUnderwater and not wasUnderwater then
                    wasUnderwater = true
                    underwaterStartTime = GetGameTimer()
                    underwaterStartHealth = health
                end
                
                -- Check after threshold underwater
                if wasUnderwater and isUnderwater then
                    local underwaterDurationNow = GetGameTimer() - underwaterStartTime
                    
                    if underwaterDurationNow > drownDuration then
                        local damageTaken = underwaterStartHealth - health
                        
                        -- If underwater too long and took less than minimum damage = suspicious
                        if damageTaken < drownMinDamage and not IsEntityDead(ped) then
                            drownViolations = drownViolations + 1
                            DebugPrint('[ANTICHEAT] ⚠️ DROWNING IMMUNITY! Duration: ' .. math.floor(underwaterDurationNow/1000) .. 's, Damage: ' .. damageTaken .. ', Violations: ' .. drownViolations .. '/' .. violationsNeeded)
                            
                            if drownViolations >= violationsNeeded then
                                TriggerServerEvent('anticheat:godmodeDetected', 'drown_immune_' .. math.floor(underwaterDurationNow/1000) .. 's')
                                drownViolations = 0
                            end
                        else
                            drownViolations = 0
                        end
                        
                        -- Reset tracking
                        underwaterStartTime = GetGameTimer()
                        underwaterStartHealth = health
                    end
                end
                
                -- Reset when surfacing
                if not isUnderwater and wasUnderwater then
                    wasUnderwater = false
                end
            end
        else
            wasUnderwater = false
        end
    end
end)

-- ============================================
-- ANTI-KILL (Kill without weapon in inventory)
-- ============================================
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' and ShouldCheckPlayer() then
        local victim = args[1]
        local attacker = args[2]
        local isFatal = args[4] == 1
        local weaponHash = args[7]
        
        -- Check if WE killed someone (not NPC)
        if attacker == PlayerPedId() and victim ~= PlayerPedId() and IsPedAPlayer(victim) and isFatal then
            local myPed = PlayerPedId()
            local currentWeapon = GetSelectedPedWeapon(myPed)
            
            -- Check if weapon is in inventory
            if currentWeapon ~= GetHashKey('WEAPON_UNARMED') then
                local hasWeaponInInventory = false
                
                for _, w in ipairs(playerWeapons) do
                    if GetHashKey(w) == currentWeapon then
                        hasWeaponInInventory = true
                        break
                    end
                end
                
                -- Killed with weapon NOT in inventory = cheating
                if not hasWeaponInInventory and GetResourceState('ox_inventory') == 'started' then
                    local victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
                    DebugPrint('[ANTICHEAT] KILL WITHOUT INVENTORY WEAPON! Weapon: ' .. currentWeapon)
                    TriggerServerEvent('anticheat:illegalKill', victimId, currentWeapon, 'weapon_not_in_inventory')
                end
            else
                -- Killed someone while UNARMED (fist kill is ok, but instant kill is not)
                -- This could be a kill aura or similar
                local distance = #(GetEntityCoords(myPed) - GetEntityCoords(victim))
                if distance > 5.0 then
                    -- Killed from distance while unarmed = impossible
                    local victimId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim))
                    DebugPrint('[ANTICHEAT] KILL WHILE UNARMED FROM DISTANCE! Dist: ' .. math.floor(distance))
                    TriggerServerEvent('anticheat:illegalKill', victimId, 0, 'unarmed_distance_kill')
                end
            end
        end
    end
end)

-- ============================================
-- ANTI-SUICIDE (Cheat suicide detection)
-- ============================================
local lastSuicideCheck = 0
local suicideData = {
    lastHealth = 200,
    wasHealthy = true
}

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' and ShouldCheckPlayer() then
        local victim = args[1]
        local attacker = args[2]
        local isFatal = args[4] == 1
        
        -- Check if WE died and WE are the attacker (suicide)
        if victim == PlayerPedId() and attacker == PlayerPedId() and isFatal then
            -- Self-inflicted death
            local weaponHash = args[7]
            local health = suicideData.lastHealth
            
            -- If we were healthy and suddenly died by our own hand = cheat suicide
            if health > 150 then
                DebugPrint('[ANTICHEAT] CHEAT SUICIDE DETECTED! Was at ' .. health .. ' health')
                TriggerServerEvent('anticheat:cheatSuicide', health, weaponHash)
            end
        end
    end
end)

-- Track health for suicide detection
CreateThread(function()
    Wait(5000)
    while true do
        Wait(500)
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            if not IsEntityDead(ped) then
                suicideData.lastHealth = GetEntityHealth(ped)
                suicideData.wasHealthy = suicideData.lastHealth > 150
            end
        end
    end
end)

-- ============================================
-- ANTI-SELF REVIVE & ANTI-SELF HEAL
-- ============================================
CreateThread(function()
    Wait(10000)
    
    while true do
        Wait(1000)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            local health = GetEntityHealth(ped)
            local armor = GetPedArmour(ped)
            local isDead = IsEntityDead(ped)
            
            -- Track death state
            if isDead then
                selfHealData.wasDeadRecently = true
                selfHealData.lastDeathTime = GetGameTimer()
            end
            
            -- Check for self-revive (was dead, now alive without medic)
            if selfHealData.wasDeadRecently and not isDead then
                local timeSinceDeath = GetGameTimer() - selfHealData.lastDeathTime
                
                -- If revived within 2 seconds of death = suspicious
                if timeSinceDeath < 2000 then
                    selfHealData.violations = selfHealData.violations + 1
                    DebugPrint('[ANTICHEAT] SELF-REVIVE DETECTED! Violations: ' .. selfHealData.violations)
                    TriggerServerEvent('anticheat:selfRevive', selfHealData.violations, timeSinceDeath)
                end
                
                selfHealData.wasDeadRecently = false
            end
            
            -- Check for instant heal (health jumped up significantly)
            if not isDead and selfHealData.lastHealth > 0 then
                local healthGain = health - selfHealData.lastHealth
                
                -- If health increased by more than 50 in 1 second = suspicious
                if healthGain > 50 then
                    selfHealData.violations = selfHealData.violations + 1
                    DebugPrint('[ANTICHEAT] SELF-HEAL DETECTED! Gained ' .. healthGain .. ' HP, Violations: ' .. selfHealData.violations)
                    TriggerServerEvent('anticheat:selfHeal', selfHealData.violations, healthGain)
                end
                
                -- Check for instant armor
                local armorGain = armor - selfHealData.lastArmor
                if armorGain > 50 then
                    selfHealData.violations = selfHealData.violations + 1
                    DebugPrint('[ANTICHEAT] SELF-ARMOR DETECTED! Gained ' .. armorGain .. ' armor, Violations: ' .. selfHealData.violations)
                    TriggerServerEvent('anticheat:selfHeal', selfHealData.violations, armorGain)
                end
            end
            
            selfHealData.lastHealth = health
            selfHealData.lastArmor = armor
        end
    end
end)


-- ============================================
-- ADVANCED ANTI-TELEPORT
-- ============================================
CreateThread(function()
    Wait(5000)
    local ped = PlayerPedId()
    lastPosition = GetEntityCoords(ped)
    lastPositionTime = GetGameTimer()
    
    while true do
        Wait(500)
        
        if ShouldCheckPlayer() then
            ped = PlayerPedId()
            local currentPos = GetEntityCoords(ped)
            local currentTime = GetGameTimer()
            local timeDiff = (currentTime - lastPositionTime) / 1000
            
            if lastPosition and timeDiff > 0.3 then
                local distance = #(currentPos - lastPosition)
                local speed = distance / timeDiff
                
                local maxSpeed = 50.0
                
                if IsPedInAnyVehicle(ped, false) then
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    local vehSpeed = GetEntitySpeed(vehicle) * 3.6
                    maxSpeed = math.max(400, vehSpeed * 1.5)
                elseif IsPedFalling(ped) or IsPedRagdoll(ped) then
                    maxSpeed = 150
                elseif IsPedInParachuteFreeFall(ped) then
                    maxSpeed = 200
                end
                
                if speed > maxSpeed and distance > 50 then
                    teleportViolations = teleportViolations + 1
                    DebugPrint('[ANTICHEAT] Teleport! Speed: ' .. math.floor(speed) .. ' m/s, Dist: ' .. math.floor(distance) .. 'm')
                    
                    if teleportViolations >= 3 then
                        TriggerServerEvent('anticheat:teleportDetected', math.floor(distance), math.floor(speed))
                        teleportViolations = 0
                    end
                else
                    teleportViolations = math.max(0, teleportViolations - 1)
                end
            end
            
            lastPosition = currentPos
            lastPositionTime = currentTime
        end
    end
end)

-- ============================================
-- ADVANCED ANTI-INVISIBLE DETECTION (PERMA BAN)
-- Multiple detection methods for invisibility cheats
-- ============================================
local invisibleViolations = 0
local invisibleData = {
    lastAlpha = 255,
    wasInvisible = false,
    invisibleStartTime = 0,
    totalInvisibleTime = 0
}

CreateThread(function()
    Wait(10000)
    
    while true do
        Wait(500) -- Check more frequently
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            local playerId = PlayerId()
            
            -- Skip if dead or in loading
            if IsEntityDead(ped) or IsScreenFadedOut() or IsScreenFadingOut() then
                goto continueInvisible
            end
            
            -- METHOD 1: Check IsEntityVisible
            local isVisible = IsEntityVisible(ped)
            
            -- METHOD 2: Check Entity Alpha
            local alpha = GetEntityAlpha(ped)
            
            -- Combine checks
            local isInvisible = false
            local invisibleReason = ''
            
            if not isVisible then
                isInvisible = true
                invisibleReason = 'entity_not_visible'
            elseif alpha < 200 then
                isInvisible = true
                invisibleReason = 'low_alpha_' .. alpha
            elseif alpha < 100 then
                -- Very low alpha = instant detection
                invisibleViolations = invisibleViolations + 3
                invisibleReason = 'very_low_alpha_' .. alpha
            end
            
            -- Track invisible time
            if isInvisible then
                if not invisibleData.wasInvisible then
                    invisibleData.invisibleStartTime = GetGameTimer()
                    invisibleData.wasInvisible = true
                end
                
                local invisibleDuration = GetGameTimer() - invisibleData.invisibleStartTime
                
                -- If invisible for more than 2 seconds = suspicious
                if invisibleDuration > 2000 then
                    invisibleViolations = invisibleViolations + 1
                    DebugPrint('[ANTICHEAT] INVISIBLE! Reason: ' .. invisibleReason .. ', Duration: ' .. math.floor(invisibleDuration/1000) .. 's, Violations: ' .. invisibleViolations)
                end
                
                -- If invisible for more than 5 seconds = definitely cheating
                if invisibleDuration > 5000 then
                    invisibleViolations = invisibleViolations + 2
                end
            else
                invisibleData.wasInvisible = false
                invisibleData.invisibleStartTime = 0
                -- Decay violations slowly
                invisibleViolations = math.max(0, invisibleViolations - 0.5)
            end
            
            -- Check for instant alpha changes (cheat toggle)
            local alphaDiff = math.abs(alpha - invisibleData.lastAlpha)
            if alphaDiff > 100 and alpha < 200 then
                invisibleViolations = invisibleViolations + 2
                DebugPrint('[ANTICHEAT] INSTANT ALPHA CHANGE! From ' .. invisibleData.lastAlpha .. ' to ' .. alpha)
            end
            invisibleData.lastAlpha = alpha
            
            -- Ban threshold
            if invisibleViolations >= 4 then
                DebugPrint('[ANTICHEAT] INVISIBLE CONFIRMED! Banning...')
                TriggerServerEvent('anticheat:invisibleDetected', alpha)
                invisibleViolations = 0
            end
            
            ::continueInvisible::
        end
    end
end)

-- Additional check: Monitor SetEntityVisible calls
CreateThread(function()
    Wait(15000)
    
    while true do
        Wait(2000)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            
            -- Force visibility check - if someone set us invisible, fix it
            if not IsEntityVisible(ped) and not IsScreenFadedOut() then
                -- Try to make visible again
                SetEntityVisible(ped, true, false)
                
                -- Check if still invisible after fix attempt
                Wait(100)
                if not IsEntityVisible(ped) then
                    invisibleViolations = invisibleViolations + 2
                    DebugPrint('[ANTICHEAT] FORCED INVISIBLE - Cannot fix!')
                end
            end
            
            -- Check alpha and fix if needed
            local alpha = GetEntityAlpha(ped)
            if alpha < 200 and not IsScreenFadedOut() then
                ResetEntityAlpha(ped)
                
                Wait(100)
                local newAlpha = GetEntityAlpha(ped)
                if newAlpha < 200 then
                    invisibleViolations = invisibleViolations + 2
                    DebugPrint('[ANTICHEAT] FORCED LOW ALPHA - Cannot fix!')
                end
            end
        end
    end
end)

-- ============================================
-- ADVANCED ANTI-NOCLIP v3.1
-- 3 Main Detection Methods:
-- 1. Wall Passing Detection (Multi-Raycast)
-- 2. Impossible Acceleration Detection
-- 3. Floating in Air Detection
-- Plus: Underground, Invisible, Frozen checks
-- FIXED: False positives when falling from heights
-- ============================================
local noclipData = {
    violations = 0,
    lastPos = nil,
    lastVelocity = nil,
    lastTime = 0,
    -- Wall passing
    wallPassCount = 0,
    consecutiveWallHits = 0,
    solidGeoCount = 0, -- Track solid geometry detections
    -- Floating detection
    floatingTime = 0,
    lastGroundTime = 0,
    stationaryAirTime = 0,
    lastRagdollTime = 0,
    lastFallTime = 0,
    lastLandingTime = 0, -- Track when player lands
    lastHighFallTime = 0, -- Track high falls
    wasInAir = false, -- Track if player was in air
    lastAirHeight = 0, -- Track height when in air
    -- Acceleration tracking
    accelerationHistory = {},
    maxAccelHistory = 10,
    -- Position history for pattern detection
    positionHistory = {},
    maxPosHistory = 20,
    -- Config - Less strict to avoid false positives
    maxViolations = 8 -- Need 8 violations for ban (increased for safety)
}

-- Helper: Calculate acceleration
local function CalculateAcceleration(currentVel, lastVel, deltaTime)
    if deltaTime <= 0 then return 0 end
    local velChange = #(currentVel - lastVel)
    return velChange / deltaTime
end

-- Helper: Check if position is inside solid geometry
local function IsPositionInsideSolid(pos)
    -- Cast rays in all 6 directions from position
    local directions = {
        vector3(1, 0, 0), vector3(-1, 0, 0),
        vector3(0, 1, 0), vector3(0, -1, 0),
        vector3(0, 0, 1), vector3(0, 0, -1)
    }
    
    local solidCount = 0
    for _, dir in ipairs(directions) do
        local endPos = pos + (dir * 0.5)
        local ray = StartShapeTestRay(pos.x, pos.y, pos.z, endPos.x, endPos.y, endPos.z, 1, PlayerPedId(), 0)
        local _, hit, _, _, _ = GetShapeTestResult(ray)
        if hit then
            solidCount = solidCount + 1
        end
    end
    
    -- If 4+ directions hit solid = inside geometry
    return solidCount >= 4
end

-- Helper: Multi-point raycast for wall detection
local function CheckWallPass(fromPos, toPos, ped)
    local hits = 0
    local distance = #(toPos - fromPos)
    
    -- Main ray
    local ray1 = StartShapeTestRay(fromPos.x, fromPos.y, fromPos.z, toPos.x, toPos.y, toPos.z, 1, ped, 0)
    local _, hit1, _, _, _ = GetShapeTestResult(ray1)
    if hit1 then hits = hits + 1 end
    
    -- Offset rays (check sides)
    local direction = norm(toPos - fromPos)
    local perpendicular = vector3(-direction.y, direction.x, 0)
    
    -- Left side ray
    local leftFrom = fromPos + (perpendicular * 0.3)
    local leftTo = toPos + (perpendicular * 0.3)
    local ray2 = StartShapeTestRay(leftFrom.x, leftFrom.y, leftFrom.z, leftTo.x, leftTo.y, leftTo.z, 1, ped, 0)
    local _, hit2, _, _, _ = GetShapeTestResult(ray2)
    if hit2 then hits = hits + 1 end
    
    -- Right side ray
    local rightFrom = fromPos - (perpendicular * 0.3)
    local rightTo = toPos - (perpendicular * 0.3)
    local ray3 = StartShapeTestRay(rightFrom.x, rightFrom.y, rightFrom.z, rightTo.x, rightTo.y, rightTo.z, 1, ped, 0)
    local _, hit3, _, _, _ = GetShapeTestResult(ray3)
    if hit3 then hits = hits + 1 end
    
    -- Vertical rays (head and feet level)
    local headFrom = vector3(fromPos.x, fromPos.y, fromPos.z + 0.8)
    local headTo = vector3(toPos.x, toPos.y, toPos.z + 0.8)
    local ray4 = StartShapeTestRay(headFrom.x, headFrom.y, headFrom.z, headTo.x, headTo.y, headTo.z, 1, ped, 0)
    local _, hit4, _, _, _ = GetShapeTestResult(ray4)
    if hit4 then hits = hits + 1 end
    
    return hits
end

CreateThread(function()
    Wait(8000)
    DebugPrint('[ANTICHEAT] Advanced Anti-Noclip v3.1 Active (BALANCED MODE)')
    DebugPrint('[ANTICHEAT] ├─ Wall Passing Detection (Multi-Raycast)')
    DebugPrint('[ANTICHEAT] ├─ Impossible Acceleration Detection')
    DebugPrint('[ANTICHEAT] └─ Floating in Air Detection')
    DebugPrint('[ANTICHEAT] └─ Fall Protection: ENABLED')
    
    while true do
        Wait(150) -- Even faster checks
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local velocity = GetEntityVelocity(ped)
            local currentTime = GetGameTimer()
            local isInVehicle = IsPedInAnyVehicle(ped, false)
            local speed = #velocity
            local heightAboveGround = GetEntityHeightAboveGround(ped)
            local verticalVelocity = velocity.z
            
            -- Skip if dead or loading
            if IsEntityDead(ped) or IsScreenFadedOut() then
                noclipData.lastPos = nil
                noclipData.lastVelocity = nil
                noclipData.lastTime = 0
                noclipData.wasInAir = false
                goto continueNoclip
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- FALL TRACKING SYSTEM - Prevent false positives
            -- ═══════════════════════════════════════════════════════════
            local isRagdoll = IsPedRagdoll(ped)
            local isFalling = IsPedFalling(ped)
            local isJumping = IsPedJumping(ped)
            local isClimbing = IsPedClimbing(ped)
            local isInParachute = IsPedInParachuteFreeFall(ped) or GetPedParachuteState(ped) ~= -1
            
            -- Track if player is in air
            if heightAboveGround > 3.0 then
                noclipData.wasInAir = true
                noclipData.lastAirHeight = math.max(noclipData.lastAirHeight, heightAboveGround)
            end
            
            -- Detect landing (was in air, now on ground)
            if noclipData.wasInAir and heightAboveGround < 2.0 then
                noclipData.lastLandingTime = currentTime
                -- If fell from high, give longer grace period
                if noclipData.lastAirHeight > 10.0 then
                    noclipData.lastHighFallTime = currentTime
                    DebugPrint('[ANTICHEAT] High fall detected - grace period active (height: ' .. math.floor(noclipData.lastAirHeight) .. 'm)')
                end
                noclipData.wasInAir = false
                noclipData.lastAirHeight = 0
            end
            
            -- Track ragdoll state
            if isRagdoll then
                noclipData.lastRagdollTime = currentTime
            end
            
            -- Track falling state
            if isFalling or verticalVelocity < -3.0 then
                noclipData.lastFallTime = currentTime
            end
            
            -- Grace periods
            local wasRecentlyRagdoll = noclipData.lastRagdollTime and (currentTime - noclipData.lastRagdollTime) < 10000 -- 10 seconds after ragdoll
            local wasRecentlyFalling = noclipData.lastFallTime and (currentTime - noclipData.lastFallTime) < 6000 -- 6 seconds after falling
            local wasRecentlyLanding = noclipData.lastLandingTime and (currentTime - noclipData.lastLandingTime) < 5000 -- 5 seconds after landing
            local wasRecentlyHighFall = noclipData.lastHighFallTime and (currentTime - noclipData.lastHighFallTime) < 8000 -- 8 seconds after high fall
            local wasRecentlyOnGround = (currentTime - noclipData.lastGroundTime) < 5000
            
            -- Skip if dead or loading
            if IsEntityDead(ped) or IsScreenFadedOut() then
                noclipData.lastPos = nil
                noclipData.lastVelocity = nil
                noclipData.lastTime = 0
                goto continueNoclip
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- METHOD 1: ADVANCED WALL PASSING DETECTION
            -- SKIP when falling - raycasts give false positives at high speeds
            -- ═══════════════════════════════════════════════════════════
            local skipWallCheck = isFalling or isRagdoll or wasRecentlyFalling or wasRecentlyRagdoll 
                or wasRecentlyLanding or wasRecentlyHighFall or isInParachute 
                or verticalVelocity < -5.0 -- Falling fast
                or heightAboveGround > 5.0 -- In the air
                or noclipData.wasInAir -- Was recently in air
            
            if noclipData.lastPos and not isInVehicle and not skipWallCheck then
                local distance = #(coords - noclipData.lastPos)
                
                -- Check if moved (lower threshold for faster detection)
                if distance > 1.5 and distance < 100.0 then
                    local wallHits = CheckWallPass(noclipData.lastPos, coords, ped)
                    
                    -- 3+ rays hit = wall pass (increased from 2)
                    if wallHits >= 3 then
                        noclipData.consecutiveWallHits = noclipData.consecutiveWallHits + 1
                        noclipData.wallPassCount = noclipData.wallPassCount + wallHits
                        
                        DebugPrint('[ANTICHEAT] 🧱 WALL PASS! Rays: ' .. wallHits .. ', Consecutive: ' .. noclipData.consecutiveWallHits .. ', Total: ' .. noclipData.wallPassCount)
                        
                        -- Need 3 consecutive OR 10 total (increased thresholds)
                        if noclipData.consecutiveWallHits >= 3 or noclipData.wallPassCount >= 10 then
                            noclipData.violations = noclipData.violations + 3
                            DebugPrint('[ANTICHEAT] 🚨 WALL NOCLIP CONFIRMED!')
                            noclipData.wallPassCount = 0
                            noclipData.consecutiveWallHits = 0
                        end
                    else
                        noclipData.consecutiveWallHits = math.max(0, noclipData.consecutiveWallHits - 1)
                        noclipData.wallPassCount = math.max(0, noclipData.wallPassCount - 1)
                    end
                    
                    -- Check if inside solid geometry - ONLY when on ground and not recently falling
                    if not skipWallCheck and heightAboveGround < 2.0 and IsPositionInsideSolid(coords) then
                        noclipData.solidGeoCount = (noclipData.solidGeoCount or 0) + 1
                        -- Need 3 consecutive detections to confirm
                        if noclipData.solidGeoCount >= 3 then
                            noclipData.violations = noclipData.violations + 2
                            DebugPrint('[ANTICHEAT] 🚨 INSIDE SOLID GEOMETRY!')
                            noclipData.solidGeoCount = 0
                        end
                    else
                        noclipData.solidGeoCount = 0
                    end
                end
            else
                -- Reset wall counters when skipping
                noclipData.consecutiveWallHits = 0
                noclipData.wallPassCount = 0
                noclipData.solidGeoCount = 0
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- METHOD 2: IMPOSSIBLE ACCELERATION DETECTION
            -- SKIP if player recently fell/landed/ragdolled
            -- ═══════════════════════════════════════════════════════════
            local skipAccelerationCheck = wasRecentlyRagdoll or wasRecentlyFalling or wasRecentlyLanding or wasRecentlyHighFall or isFalling or isRagdoll or isJumping or isClimbing or isInParachute
            
            if noclipData.lastVelocity and noclipData.lastTime > 0 and not isInVehicle and not skipAccelerationCheck then
                local deltaTime = (currentTime - noclipData.lastTime) / 1000.0
                
                if deltaTime > 0 and deltaTime < 1.0 then
                    local acceleration = CalculateAcceleration(velocity, noclipData.lastVelocity, deltaTime)
                    
                    -- Store acceleration history
                    table.insert(noclipData.accelerationHistory, acceleration)
                    if #noclipData.accelerationHistory > noclipData.maxAccelHistory then
                        table.remove(noclipData.accelerationHistory, 1)
                    end
                    
                    -- Max possible acceleration on foot is ~15 m/s² (sprint start)
                    -- Noclip typically shows 50+ m/s² instant changes
                    -- INCREASED threshold to avoid false positives
                    local maxNormalAccel = 35.0 -- Higher buffer for lag and physics
                    
                    if acceleration > maxNormalAccel then
                        -- Check if it's consistent (not just lag spike)
                        local highAccelCount = 0
                        for _, accel in ipairs(noclipData.accelerationHistory) do
                            if accel > maxNormalAccel then
                                highAccelCount = highAccelCount + 1
                            end
                        end
                        
                        -- Need MORE consistent high acceleration to trigger
                        if highAccelCount >= 5 then
                            noclipData.violations = noclipData.violations + 2
                            DebugPrint('[ANTICHEAT] ⚡ IMPOSSIBLE ACCELERATION! ' .. math.floor(acceleration) .. ' m/s² (Count: ' .. highAccelCount .. ')')
                        end
                    end
                    
                    -- Detect instant direction change while moving fast
                    -- SKIP if recently fell (landing causes direction changes)
                    local lastSpeed = #noclipData.lastVelocity
                    if lastSpeed > 5.0 and speed > 5.0 and not wasRecentlyLanding then
                        local dotProduct = (velocity.x * noclipData.lastVelocity.x + 
                                           velocity.y * noclipData.lastVelocity.y + 
                                           velocity.z * noclipData.lastVelocity.z) / (speed * lastSpeed)
                        
                        -- Dot product < -0.5 means almost opposite direction
                        if dotProduct < -0.5 and deltaTime < 0.3 then
                            noclipData.violations = noclipData.violations + 1
                            DebugPrint('[ANTICHEAT] ↩️ INSTANT DIRECTION CHANGE! Dot: ' .. string.format('%.2f', dotProduct))
                        end
                    end
                end
            elseif skipAccelerationCheck then
                -- Clear acceleration history during grace period to avoid false positives
                noclipData.accelerationHistory = {}
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- METHOD 3: FLOATING IN AIR DETECTION
            -- Detects players hovering/floating without falling
            -- VERY STRICT to avoid false positives
            -- ═══════════════════════════════════════════════════════════
            local isSwimming = IsPedSwimming(ped)
            local isSwimmingUnderWater = IsPedSwimmingUnderWater(ped)
            
            -- MANY conditions to skip checks - avoid false positives
            local shouldSkipCheck = isInVehicle or isInParachute or isRagdoll or wasRecentlyRagdoll 
                or isFalling or wasRecentlyFalling or wasRecentlyLanding or wasRecentlyHighFall 
                or isClimbing or isJumping or isSwimming or isSwimmingUnderWater
            
            if not shouldSkipCheck then
                -- Additional falling check - if moving down at all, probably falling
                local isActuallyFalling = verticalVelocity < -1.5
                
                -- Only check if VERY high and NOT falling at all
                if heightAboveGround > 5.0 and not isActuallyFalling and not wasRecentlyOnGround then
                    -- Check if stationary in air (floating) - need MUCH more time to confirm
                    if speed < 0.5 and math.abs(verticalVelocity) < 0.3 then
                        noclipData.stationaryAirTime = noclipData.stationaryAirTime + 1
                        
                        -- 6 seconds of being completely still in air (increased from 5)
                        if noclipData.stationaryAirTime >= 30 then
                            noclipData.violations = noclipData.violations + 3
                            DebugPrint('[ANTICHEAT] 🎈 FLOATING IN AIR! Height: ' .. string.format('%.1f', heightAboveGround) .. 'm')
                            noclipData.stationaryAirTime = 0
                        end
                    -- Moving horizontally while VERY high up - even stricter
                    elseif speed > 8.0 and math.abs(verticalVelocity) < 0.5 and heightAboveGround > 30.0 then
                        noclipData.floatingTime = noclipData.floatingTime + 1
                        
                        -- 7 seconds of horizontal flight (increased from 6)
                        if noclipData.floatingTime >= 35 then
                            noclipData.violations = noclipData.violations + 3
                            DebugPrint('[ANTICHEAT] ✈️ FLYING! Height: ' .. string.format('%.1f', heightAboveGround) .. 'm, Speed: ' .. string.format('%.1f', speed))
                            noclipData.floatingTime = 0
                        end
                    else
                        -- Decay counters
                        noclipData.floatingTime = math.max(0, noclipData.floatingTime - 2)
                        noclipData.stationaryAirTime = math.max(0, noclipData.stationaryAirTime - 2)
                    end
                    
                    -- Detect upward movement - only if going UP very fast
                    if verticalVelocity > 15.0 and not isJumping and not isClimbing and heightAboveGround > 15.0 then
                        noclipData.violations = noclipData.violations + 1
                        DebugPrint('[ANTICHEAT] ⬆️ UPWARD NOCLIP! Vertical speed: ' .. string.format('%.1f', verticalVelocity))
                    end
                else
                    -- Player is on ground or falling - reset counters fast
                    noclipData.floatingTime = math.max(0, noclipData.floatingTime - 5)
                    noclipData.stationaryAirTime = math.max(0, noclipData.stationaryAirTime - 3)
                    if heightAboveGround < 2.0 then
                        noclipData.lastGroundTime = currentTime
                    end
                end
            else
                noclipData.floatingTime = 0
                noclipData.stationaryAirTime = 0
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- ADDITIONAL CHECKS
            -- ═══════════════════════════════════════════════════════════
            
            -- Underground detection
            if coords.z < -50.0 then
                noclipData.violations = noclipData.violations + 3
                DebugPrint('[ANTICHEAT] 🕳️ UNDERGROUND! Z: ' .. math.floor(coords.z))
            end
            
            -- Invisible movement detection
            if not IsEntityVisible(ped) and not isInVehicle then
                if speed > 5.0 then
                    noclipData.violations = noclipData.violations + 1
                    DebugPrint('[ANTICHEAT] 👻 INVISIBLE NOCLIP! Speed: ' .. math.floor(speed))
                end
            end
            
            -- Frozen entity moving detection
            if IsEntityPositionFrozen(ped) and noclipData.lastPos then
                local moved = #(coords - noclipData.lastPos)
                if moved > 5.0 then
                    noclipData.violations = noclipData.violations + 2
                    DebugPrint('[ANTICHEAT] 🧊 FROZEN ENTITY MOVING! Dist: ' .. math.floor(moved))
                end
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- ADDITIONAL METHOD: PHASE THROUGH OBJECTS DETECTION
            -- Uses raycast to check if player is inside objects
            -- ═══════════════════════════════════════════════════════════
            if not isInVehicle and speed > 2.0 then
                -- Cast ray downward to check if standing on something
                local rayDown = StartShapeTestRay(coords.x, coords.y, coords.z + 0.5, coords.x, coords.y, coords.z - 1.5, 1, ped, 0)
                local _, hitDown, _, _, _ = GetShapeTestResult(rayDown)
                
                -- Cast ray in movement direction
                local moveDir = norm(velocity)
                local rayForward = StartShapeTestRay(
                    coords.x, coords.y, coords.z + 0.5,
                    coords.x + moveDir.x * 1.0, coords.y + moveDir.y * 1.0, coords.z + 0.5,
                    1, ped, 0
                )
                local _, hitForward, hitCoordFwd, _, _ = GetShapeTestResult(rayForward)
                
                -- If ray hits something in front but we're still moving through it
                if hitForward and noclipData.lastPos then
                    local distToHit = #(coords - hitCoordFwd)
                    if distToHit < 0.3 then
                        -- We're very close to or inside an object
                        noclipData.phaseCount = (noclipData.phaseCount or 0) + 1
                        if noclipData.phaseCount >= 5 then
                            noclipData.violations = noclipData.violations + 2
                            DebugPrint('[ANTICHEAT] 💨 PHASE THROUGH OBJECT! Distance to surface: ' .. string.format('%.2f', distToHit))
                            noclipData.phaseCount = 0
                        end
                    else
                        noclipData.phaseCount = math.max(0, (noclipData.phaseCount or 0) - 1)
                    end
                end
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- ADDITIONAL METHOD: SWIMMING IN AIR DETECTION
            -- Detects swim animation when not in water
            -- ═══════════════════════════════════════════════════════════
            if not isInVehicle then
                local isSwimming = IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped)
                local isInWater = IsEntityInWater(ped)
                
                if isSwimming and not isInWater then
                    noclipData.swimAirCount = (noclipData.swimAirCount or 0) + 1
                    if noclipData.swimAirCount >= 5 then
                        noclipData.violations = noclipData.violations + 2
                        DebugPrint('[ANTICHEAT] 🏊 SWIMMING IN AIR!')
                        noclipData.swimAirCount = 0
                    end
                else
                    noclipData.swimAirCount = 0
                end
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- ADDITIONAL METHOD: VELOCITY VS ANIMATION MISMATCH
            -- Detects when player moves fast but animation doesn't match
            -- SKIP after falls to avoid false positives
            -- ═══════════════════════════════════════════════════════════
            if not isInVehicle and speed > 8.0 and not wasRecentlyFalling and not wasRecentlyLanding and not wasRecentlyHighFall then
                local isRunning = IsPedRunning(ped)
                local isSprinting = IsPedSprinting(ped)
                
                -- Moving fast but not in any movement animation
                if not isRunning and not isSprinting and not isFalling and not isRagdoll and not isInParachute then
                    noclipData.animMismatchCount = (noclipData.animMismatchCount or 0) + 1
                    if noclipData.animMismatchCount >= 10 then -- Increased from 8
                        noclipData.violations = noclipData.violations + 2
                        DebugPrint('[ANTICHEAT] 🎭 VELOCITY/ANIMATION MISMATCH! Speed: ' .. string.format('%.1f', speed) .. ' but no movement anim')
                        noclipData.animMismatchCount = 0
                    end
                else
                    noclipData.animMismatchCount = math.max(0, (noclipData.animMismatchCount or 0) - 1)
                end
            else
                noclipData.animMismatchCount = 0
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- VIOLATION CHECK & BAN
            -- ═══════════════════════════════════════════════════════════
            if noclipData.violations >= noclipData.maxViolations then
                DebugPrint('[ANTICHEAT] 🚨 NOCLIP CONFIRMED! Total violations: ' .. noclipData.violations)
                TriggerServerEvent('anticheat:noclipDetected', 'noclip_v3_' .. noclipData.violations)
                noclipData.violations = 0
                noclipData.wallPassCount = 0
                noclipData.consecutiveWallHits = 0
                noclipData.floatingTime = 0
                noclipData.stationaryAirTime = 0
                noclipData.accelerationHistory = {}
            else
                -- Slow decay
                noclipData.violations = math.max(0, noclipData.violations - 0.3)
            end
            
            -- Store for next check
            noclipData.lastPos = coords
            noclipData.lastVelocity = velocity
            noclipData.lastTime = currentTime
            
            -- Store position history
            table.insert(noclipData.positionHistory, {pos = coords, time = currentTime})
            if #noclipData.positionHistory > noclipData.maxPosHistory then
                table.remove(noclipData.positionHistory, 1)
            end
            
            ::continueNoclip::
        end
    end
end)

-- ============================================
-- VEHICLE/PED/WEAPON CHECKS + SPOOFED DETECTION
-- ============================================

-- Track server-synced vehicles (real vehicles)
local serverVehicles = {}

RegisterNetEvent('anticheat:syncVehicles', function(vehicles)
    serverVehicles = vehicles or {}
end)

-- Anti-Spoofed Vehicle Detection (client-side spawned)
CreateThread(function()
    Wait(8000)
    
    while true do
        Wait(3000)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
                local isNetworked = NetworkGetEntityIsNetworked(vehicle)
                
                -- Check if vehicle is NOT networked (client-side only)
                if not isNetworked then
                    local model = GetEntityModel(vehicle)
                    local modelName = GetDisplayNameFromVehicleModel(model):lower()
                    DebugPrint('[ANTICHEAT] CLIENT-SIDE VEHICLE DETECTED! Model: ' .. modelName)
                    TriggerServerEvent('anticheat:spoofedVehicle', modelName, 'not_networked')
                    DeleteEntity(vehicle)
                end
            end
        end
    end
end)

CreateThread(function()
    Wait(5000)
    while true do
        Wait(2000)
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            
            -- Vehicle check (BLACKLIST - ban if vehicle IS in blacklist)
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local model = GetEntityModel(vehicle)
                local modelName = GetDisplayNameFromVehicleModel(model):lower()
                
                -- Check if vehicle is BLACKLISTED (not allowed)
                if blacklistedVehicles[model] or blacklistedVehicles[modelName] then
                    if GetPedInVehicleSeat(vehicle, -1) == ped then
                        TriggerServerEvent('anticheat:illegalVehicle', modelName)
                        DeleteEntity(vehicle)
                    else
                        TaskLeaveVehicle(ped, vehicle, 16)
                    end
                end
            end
            
            -- Ped check
            local pedModel = GetEntityModel(ped)
            if blacklistedPeds[pedModel] then
                TriggerServerEvent('anticheat:illegalPed', pedModel)
                local defaultModel = GetHashKey('mp_m_freemode_01')
                RequestModel(defaultModel)
                while not HasModelLoaded(defaultModel) do Wait(10) end
                SetPlayerModel(PlayerId(), defaultModel)
            end
        end
    end
end)

-- ============================================
-- ADVANCED WEAPON CHECK + SPOOFED WEAPON DETECTION
-- ============================================
CreateThread(function()
    Wait(10000) -- Wait longer for inventory to load
    local spoofedWeaponViolations = 0
    
    while true do
        Wait(1000) -- Check less frequently
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)
            
            if weapon ~= GetHashKey('WEAPON_UNARMED') then
                -- Check blacklisted weapons first
                if blacklistedWeapons[weapon] then
                    TriggerServerEvent('anticheat:illegalWeapon', weapon, 'blacklisted')
                    RemoveWeaponFromPed(ped, weapon)
                -- Check if weapon is in inventory (ox_inventory)
                elseif GetResourceState('ox_inventory') == 'started' and #playerWeapons > 0 then
                    local hasWeapon = false
                    local weaponName = nil
                    
                    -- Get weapon name from hash
                    for _, w in ipairs(Config.AllowedWeapons or {}) do
                        if GetHashKey(w) == weapon then
                            weaponName = w:upper()
                            break
                        end
                    end
                    
                    -- Check if weapon is in playerWeapons list
                    for _, w in ipairs(playerWeapons) do
                        local wUpper = w:upper()
                        if GetHashKey(wUpper) == weapon then
                            hasWeapon = true
                            break
                        end
                        -- Also check without WEAPON_ prefix
                        if GetHashKey('WEAPON_' .. wUpper:gsub('WEAPON_', '')) == weapon then
                            hasWeapon = true
                            break
                        end
                    end
                    
                    if not hasWeapon then
                        spoofedWeaponViolations = spoofedWeaponViolations + 1
                        DebugPrint('[ANTICHEAT] SPOOFED WEAPON! Hash: ' .. weapon .. ', Violations: ' .. spoofedWeaponViolations .. ', Inventory weapons: ' .. #playerWeapons)
                        
                        -- Need 5 violations (more tolerance)
                        if spoofedWeaponViolations >= 5 then
                            TriggerServerEvent('anticheat:spoofedWeapon', weapon)
                            RemoveWeaponFromPed(ped, weapon)
                            spoofedWeaponViolations = 0
                        end
                    else
                        spoofedWeaponViolations = math.max(0, spoofedWeaponViolations - 1)
                    end
                end
            else
                spoofedWeaponViolations = math.max(0, spoofedWeaponViolations - 1)
            end
        end
    end
end)

-- Request weapons more frequently
CreateThread(function()
    Wait(3000)
    while true do
        if GetResourceState('ox_inventory') == 'started' then
            TriggerServerEvent('anticheat:getInventoryWeapons')
        end
        Wait(3000) -- Every 3 seconds
    end
end)


-- ============================================
-- WARNING SYSTEM
-- ============================================
RegisterNetEvent('anticheat:showWarning', function()
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", true)
    
    CreateThread(function()
        local startTime = GetGameTimer()
        local duration = 10000
        
        while (GetGameTimer() - startTime) < duration do
            Wait(0)
            local alpha = math.floor(150 + 50 * math.sin(GetGameTimer() / 100))
            DrawRect(0.5, 0.5, 1.0, 1.0, 139, 0, 0, alpha)
            
            SetTextFont(4) SetTextScale(1.5, 1.5) SetTextColour(255, 255, 255, 255)
            SetTextCentre(true) SetTextOutline() SetTextEntry('STRING')
            AddTextComponentString('~r~ANTICHEAT WARNING') DrawText(0.5, 0.3)
            
            SetTextFont(4) SetTextScale(0.6, 0.6) SetTextColour(255, 200, 0, 255)
            SetTextCentre(true) SetTextOutline() SetTextEntry('STRING')
            AddTextComponentString('~y~DISCONNECT = 24H BAN!') DrawText(0.5, 0.5)
            
            local remaining = math.ceil((duration - (GetGameTimer() - startTime)) / 1000)
            SetTextFont(4) SetTextScale(0.5, 0.5) SetTextColour(200, 200, 200, 255)
            SetTextCentre(true) SetTextEntry('STRING')
            AddTextComponentString('Wait... ' .. remaining .. 's') DrawText(0.5, 0.6)
            
            DisableControlAction(0, 200, true)
            DisableControlAction(0, 322, true)
        end
    end)
end)

-- ============================================
-- CLEAR ENTITIES
-- ============================================
RegisterNetEvent('anticheat:clearEntities', function(entityType, centerCoords, radius, adminSrc)
    local count = 0
    local myPed = PlayerPedId()
    local center = vector3(centerCoords.x, centerCoords.y, centerCoords.z)
    
    if entityType == 'peds' or entityType == 'all' then
        for _, ped in ipairs(GetGamePool('CPed')) do
            if ped ~= myPed and not IsPedAPlayer(ped) and #(GetEntityCoords(ped) - center) <= radius then
                DeleteEntity(ped) count = count + 1
            end
        end
    end
    
    if entityType == 'vehicles' or entityType == 'all' then
        for _, veh in ipairs(GetGamePool('CVehicle')) do
            if #(GetEntityCoords(veh) - center) <= radius then
                local hasPlayer = false
                for seat = -1, GetVehicleMaxNumberOfPassengers(veh) - 1 do
                    if GetPedInVehicleSeat(veh, seat) ~= 0 and IsPedAPlayer(GetPedInVehicleSeat(veh, seat)) then
                        hasPlayer = true break
                    end
                end
                if not hasPlayer then DeleteEntity(veh) count = count + 1 end
            end
        end
    end
    
    if entityType == 'props' or entityType == 'all' then
        for _, obj in ipairs(GetGamePool('CObject')) do
            if #(GetEntityCoords(obj) - center) <= radius then
                DeleteEntity(obj) count = count + 1
            end
        end
    end
    
    if GetPlayerServerId(PlayerId()) == adminSrc then
        TriggerEvent('ox_lib:notify', { type = 'success', description = 'Cleared ' .. count .. ' ' .. entityType })
    end
end)

-- Final load message is handled by the fancy banner above


-- ============================================
-- BEHAVIOR ANALYSIS - ESP/AIMBOT DETECTION
-- Detects suspicious player behavior patterns
-- ============================================

local aimHistory = {}
local lookingAtHiddenPlayers = 0
local suspiciousAimCount = 0
local lastAimDirection = nil
local lastAimTime = 0

-- Track aim patterns for aimbot detection
CreateThread(function()
    Wait(15000)
    
    while true do
        Wait(100) -- Check frequently for aim snapping
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            local playerId = PlayerId()
            
            if IsPlayerFreeAiming(playerId) then
                local camRot = GetGameplayCamRot(2)
                local currentAim = vector3(camRot.x, camRot.y, camRot.z)
                local currentTime = GetGameTimer()
                
                if lastAimDirection then
                    local timeDiff = (currentTime - lastAimTime) / 1000
                    
                    if timeDiff > 0 and timeDiff < 0.2 then
                        -- Calculate aim speed (degrees per second)
                        local aimDelta = #(currentAim - lastAimDirection)
                        local aimSpeed = aimDelta / timeDiff
                        
                        -- Store in history
                        table.insert(aimHistory, { speed = aimSpeed, time = currentTime })
                        if #aimHistory > 50 then table.remove(aimHistory, 1) end
                        
                        -- Detect snap aiming (very fast, precise movement)
                        -- Normal human aim: 50-200 deg/s
                        -- Aimbot snap: 500+ deg/s with immediate stop
                        if aimSpeed > 400 then
                            -- Check if aim stopped immediately after snap (aimbot behavior)
                            Wait(50)
                            local newRot = GetGameplayCamRot(2)
                            local afterSnapSpeed = #(vector3(newRot.x, newRot.y, newRot.z) - currentAim) / 0.05
                            
                            if afterSnapSpeed < 50 then -- Stopped immediately = suspicious
                                suspiciousAimCount = suspiciousAimCount + 1
                                DebugPrint('[ANTICHEAT] Snap aim detected! Speed: ' .. math.floor(aimSpeed) .. ' deg/s')
                                
                                if suspiciousAimCount >= 5 then
                                    TriggerServerEvent('anticheat:suspiciousAim', math.floor(aimSpeed))
                                    suspiciousAimCount = 0
                                end
                            end
                        end
                    end
                end
                
                lastAimDirection = currentAim
                lastAimTime = currentTime
            else
                lastAimDirection = nil
            end
        end
    end
end)

-- ESP Detection - Check if player is looking at hidden enemies
CreateThread(function()
    Wait(20000)
    
    while true do
        Wait(2000)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            local myCoords = GetEntityCoords(ped)
            local camCoords = GetGameplayCamCoord()
            local camRot = GetGameplayCamRot(2)
            
            -- Calculate camera forward direction
            local camForward = vector3(
                -math.sin(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
                math.cos(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
                math.sin(math.rad(camRot.x))
            )
            
            local lookingAtHidden = false
            
            -- Check all players
            for _, player in ipairs(GetActivePlayers()) do
                if player ~= PlayerId() then
                    local targetPed = GetPlayerPed(player)
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(myCoords - targetCoords)
                    
                    -- Only check players at medium-long range
                    if distance > 50 and distance < 300 then
                        -- Direction to target
                        local toTarget = norm(targetCoords - camCoords)
                        
                        -- Dot product (1 = looking directly at, 0 = perpendicular, -1 = opposite)
                        local dot = camForward.x * toTarget.x + camForward.y * toTarget.y + camForward.z * toTarget.z
                        
                        -- If looking at target (within 15 degrees)
                        if dot > 0.96 then
                            -- Check line of sight
                            local hasLOS = HasEntityClearLosToEntity(ped, targetPed, 17)
                            
                            if not hasLOS then
                                -- Looking at someone through walls!
                                lookingAtHidden = true
                                lookingAtHiddenPlayers = lookingAtHiddenPlayers + 1
                                DebugPrint('[ANTICHEAT] Looking at hidden player! Distance: ' .. math.floor(distance) .. 'm, LOS: false')
                            end
                        end
                    end
                end
            end
            
            if not lookingAtHidden then
                lookingAtHiddenPlayers = math.max(0, lookingAtHiddenPlayers - 1)
            end
            
            -- If consistently looking at hidden players = ESP
            if lookingAtHiddenPlayers >= 5 then
                TriggerServerEvent('anticheat:espDetected', lookingAtHiddenPlayers)
                lookingAtHiddenPlayers = 0
            end
        end
    end
end)

-- ============================================
-- WALLHACK DETECTION (Shooting through walls)
-- 2 detections in 20 seconds = BAN
-- ============================================
local wallhackData = {
    violations = 0,
    firstViolationTime = 0,
    windowTime = 20000 -- 20 seconds window
}

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' and ShouldCheckPlayer() then
        local victim = args[1]
        local attacker = args[2]
        local weaponHash = args[7]
        
        -- Check if we are the attacker
        if attacker == PlayerPedId() and victim ~= PlayerPedId() then
            -- Check if victim is a ped (player or NPC)
            if not DoesEntityExist(victim) then return end
            if not IsEntityAPed(victim) then return end
            
            local myCoords = GetEntityCoords(attacker)
            local victimCoords = GetEntityCoords(victim)
            local distance = #(myCoords - victimCoords)
            local isPlayer = IsPedAPlayer(victim)
            local hasLOS = HasEntityClearLosToEntity(attacker, victim, 17)
            
            -- For PvP hits, also report to server for more reliable detection
            if isPlayer and distance > 20 then
                local victimPlayerId = NetworkGetPlayerIndexFromPed(victim)
                local victimServerId = GetPlayerServerId(victimPlayerId)
                if victimServerId and victimServerId > 0 then
                    TriggerServerEvent('anticheat:reportPvPHit', victimServerId, distance, hasLOS, weaponHash)
                end
            end
            
            -- For long range shots, check LOS
            if distance > 30 then
                if not hasLOS then
                    local currentTime = GetGameTimer()
                    
                    -- Reset if window expired
                    if currentTime - wallhackData.firstViolationTime > wallhackData.windowTime then
                        wallhackData.violations = 0
                        wallhackData.firstViolationTime = currentTime
                    end
                    
                    wallhackData.violations = wallhackData.violations + 1
                    
                    -- Set first violation time if this is the first
                    if wallhackData.violations == 1 then
                        wallhackData.firstViolationTime = currentTime
                    end
                    
                    DebugPrint('[ANTICHEAT] WALLHACK! Damage through walls! Distance: ' .. math.floor(distance) .. 'm, Violations: ' .. wallhackData.violations .. '/2, IsPlayer: ' .. tostring(isPlayer))
                    
                    -- 2 violations in 20 seconds = BAN
                    if wallhackData.violations >= 2 then
                        DebugPrint('[ANTICHEAT] WALLHACK CONFIRMED! Banning...')
                        TriggerServerEvent('anticheat:wallhackDetected', math.floor(distance), wallhackData.violations)
                        wallhackData.violations = 0
                    end
                end
            end
        end
    end
end)


-- ============================================
-- ADVANCED ANTI-AIMBOT & ANTI-SILENT AIM v3.0
-- Complete rewrite with 10 detection methods
-- Works with both Players AND NPCs
-- ============================================

local aimbotData = {
    -- Basic tracking
    lastAimCoords = nil,
    lastAimTime = 0,
    lastShotTime = 0,
    
    -- Snap detection
    aimSnapCount = 0,
    snapHistory = {},
    lastCamRot = nil,
    
    -- Accuracy tracking
    headshots = 0,
    totalShots = 0,
    totalHits = 0,
    consecutiveHits = 0,
    consecutiveHeadshots = 0,
    hitRate = {},
    
    -- Silent aim
    silentAimViolations = 0,
    offTargetHits = {},
    
    -- Smooth aimbot
    smoothAimViolations = 0,
    aimSmoothness = {},
    
    -- Target tracking
    lastTargetBone = nil,
    perfectTrackingTime = 0,
    targetSwitchTimes = {},
    lastTargetEntity = nil,
    
    -- Triggerbot
    triggerbotViolations = 0,
    aimToShootTimes = {},
    
    -- Bone lock detection
    boneLockCount = 0,
    lastHitBones = {},
    
    -- Distance tracking
    longRangeHits = 0,
    longRangeHeadshots = 0,
    
    -- Recoil detection
    recoilPatterns = {},
    noRecoilViolations = 0,
}

-- Helper: Get angle between two vectors
local function GetAngleBetweenVectors(v1, v2)
    local dot = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
    local len1 = math.sqrt(v1.x^2 + v1.y^2 + v1.z^2)
    local len2 = math.sqrt(v2.x^2 + v2.y^2 + v2.z^2)
    if len1 == 0 or len2 == 0 then return 0 end
    local cosAngle = math.max(-1, math.min(1, dot / (len1 * len2)))
    return math.deg(math.acos(cosAngle))
end

-- Helper: Calculate standard deviation
local function CalculateStdDev(values)
    if #values < 2 then return 999 end
    local sum = 0
    for _, v in ipairs(values) do sum = sum + v end
    local mean = sum / #values
    local sqDiffSum = 0
    for _, v in ipairs(values) do sqDiffSum = sqDiffSum + (v - mean)^2 end
    return math.sqrt(sqDiffSum / (#values - 1))
end

-- ============================================
-- METHOD 1-5: DAMAGE EVENT ANALYSIS
-- Silent Aim, Headshot Rate, Bone Lock, Pattern, Target Switch
-- ============================================
AddEventHandler('gameEventTriggered', function(name, args)
    if not ShouldCheckPlayer() then return end
    
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local isFatal = args[4] == 1
        local weaponHash = args[7]
        
        -- Check damage from us to ANY ped
        if attacker == PlayerPedId() and victim ~= PlayerPedId() then
            if not DoesEntityExist(victim) then return end
            if not IsEntityAPed(victim) then return end
            
            local myPed = PlayerPedId()
            local myCoords = GetEntityCoords(myPed)
            local victimCoords = GetEntityCoords(victim)
            local distance = #(myCoords - victimCoords)
            local currentTime = GetGameTimer()
            local isPlayer = IsPedAPlayer(victim)
            
            -- Get camera direction
            local camCoords = GetGameplayCamCoord()
            local camRot = GetGameplayCamRot(2)
            local camForward = vector3(
                -math.sin(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
                math.cos(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
                math.sin(math.rad(camRot.x))
            )
            
            local toVictim = norm(victimCoords - camCoords)
            local aimAlignment = camForward.x * toVictim.x + camForward.y * toVictim.y + camForward.z * toVictim.z
            local angleDiff = GetAngleBetweenVectors(camForward, toVictim)
            
            -- Dynamic threshold based on distance
            local maxAngle = 10.0
            if distance > 30 then maxAngle = 6.0 end
            if distance > 50 then maxAngle = 4.0 end
            if distance > 100 then maxAngle = 2.5 end
            
            -- ═══════════════════════════════════════════════════════════
            -- METHOD 1: SILENT AIM DETECTION
            -- ═══════════════════════════════════════════════════════════
            if angleDiff > maxAngle and distance > 10 then
                aimbotData.silentAimViolations = aimbotData.silentAimViolations + 1
                DebugPrint('[ANTICHEAT] 🎯 SILENT AIM! Angle: ' .. string.format("%.1f", angleDiff) .. '° at ' .. math.floor(distance) .. 'm')
                
                if aimbotData.silentAimViolations >= 3 then
                    DebugPrint('[ANTICHEAT] 🚨 SILENT AIM CONFIRMED!')
                    TriggerServerEvent('anticheat:silentAim', math.floor(distance), string.format("%.1f", angleDiff))
                    aimbotData.silentAimViolations = 0
                end
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- METHOD 2: HEADSHOT TRACKING
            -- ═══════════════════════════════════════════════════════════
            local _, boneIndex = GetPedLastDamageBone(victim)
            local isHeadshot = boneIndex == 31086 or boneIndex == 39317
            
            aimbotData.totalHits = aimbotData.totalHits + 1
            aimbotData.consecutiveHits = aimbotData.consecutiveHits + 1
            
            -- Track bones for bone lock
            table.insert(aimbotData.lastHitBones, boneIndex)
            while #aimbotData.lastHitBones > 15 do
                table.remove(aimbotData.lastHitBones, 1)
            end
            
            if isHeadshot then
                aimbotData.headshots = aimbotData.headshots + 1
                aimbotData.consecutiveHeadshots = aimbotData.consecutiveHeadshots + 1
                
                if distance > 50 then
                    aimbotData.longRangeHeadshots = aimbotData.longRangeHeadshots + 1
                end
                
                if aimbotData.consecutiveHeadshots >= 5 then
                    DebugPrint('[ANTICHEAT] 🎯 ' .. aimbotData.consecutiveHeadshots .. ' CONSECUTIVE HEADSHOTS!')
                    TriggerServerEvent('anticheat:suspiciousAccuracy', 'consecutive_headshots', aimbotData.consecutiveHeadshots)
                end
            else
                aimbotData.consecutiveHeadshots = 0
            end
            
            if distance > 50 then
                aimbotData.longRangeHits = aimbotData.longRangeHits + 1
            end
            
            -- Store hit data
            table.insert(aimbotData.hitRate, {
                time = currentTime,
                distance = distance,
                headshot = isHeadshot,
                angle = angleDiff,
                bone = boneIndex,
                isPlayer = isPlayer
            })
            while #aimbotData.hitRate > 50 do
                table.remove(aimbotData.hitRate, 1)
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- METHOD 3: BONE LOCK DETECTION
            -- ═══════════════════════════════════════════════════════════
            if #aimbotData.lastHitBones >= 10 then
                local boneCounts = {}
                for _, bone in ipairs(aimbotData.lastHitBones) do
                    boneCounts[bone] = (boneCounts[bone] or 0) + 1
                end
                
                local maxBone, maxCount = nil, 0
                for bone, count in pairs(boneCounts) do
                    if count > maxCount then
                        maxBone, maxCount = bone, count
                    end
                end
                
                if maxCount >= 9 then
                    aimbotData.boneLockCount = aimbotData.boneLockCount + 1
                    DebugPrint('[ANTICHEAT] 🔒 BONE LOCK! ' .. maxCount .. '/10 on bone ' .. tostring(maxBone))
                    
                    if aimbotData.boneLockCount >= 2 then
                        TriggerServerEvent('anticheat:suspiciousAccuracy', 'bone_lock', maxCount .. '/10')
                        aimbotData.boneLockCount = 0
                        aimbotData.lastHitBones = {}
                    end
                end
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- METHOD 4: PATTERN ANALYSIS
            -- ═══════════════════════════════════════════════════════════
            if #aimbotData.hitRate >= 15 then
                local recentHeadshots = 0
                local angles = {}
                
                for i = math.max(1, #aimbotData.hitRate - 14), #aimbotData.hitRate do
                    local hit = aimbotData.hitRate[i]
                    if hit.headshot then recentHeadshots = recentHeadshots + 1 end
                    table.insert(angles, hit.angle)
                end
                
                if recentHeadshots >= 11 then
                    DebugPrint('[ANTICHEAT] 🎯 AIMBOT! ' .. recentHeadshots .. '/15 headshots!')
                    TriggerServerEvent('anticheat:suspiciousAccuracy', 'headshot_rate', recentHeadshots .. '/15')
                end
                
                local angleStdDev = CalculateStdDev(angles)
                if angleStdDev < 0.5 and #angles >= 10 then
                    DebugPrint('[ANTICHEAT] 🤖 ROBOTIC AIM! StdDev: ' .. string.format("%.2f", angleStdDev))
                    TriggerServerEvent('anticheat:suspiciousAccuracy', 'robotic_aim', string.format("%.2f", angleStdDev))
                end
                
                if aimbotData.longRangeHits >= 10 then
                    local longRangeHsRate = aimbotData.longRangeHeadshots / aimbotData.longRangeHits
                    if longRangeHsRate > 0.7 then
                        DebugPrint('[ANTICHEAT] 🎯 LONG RANGE AIMBOT! ' .. math.floor(longRangeHsRate * 100) .. '%')
                        TriggerServerEvent('anticheat:suspiciousAccuracy', 'long_range_hs', math.floor(longRangeHsRate * 100) .. '%')
                        aimbotData.longRangeHits = 0
                        aimbotData.longRangeHeadshots = 0
                    end
                end
            end
            
            -- ═══════════════════════════════════════════════════════════
            -- METHOD 5: TARGET SWITCH SPEED
            -- ═══════════════════════════════════════════════════════════
            if aimbotData.lastTargetEntity and aimbotData.lastTargetEntity ~= victim then
                local switchTime = currentTime - aimbotData.lastShotTime
                
                if switchTime < 200 and switchTime > 0 then
                    table.insert(aimbotData.targetSwitchTimes, switchTime)
                    while #aimbotData.targetSwitchTimes > 10 do
                        table.remove(aimbotData.targetSwitchTimes, 1)
                    end
                    
                    if #aimbotData.targetSwitchTimes >= 5 then
                        local avgSwitch = 0
                        for _, t in ipairs(aimbotData.targetSwitchTimes) do
                            avgSwitch = avgSwitch + t
                        end
                        avgSwitch = avgSwitch / #aimbotData.targetSwitchTimes
                        
                        if avgSwitch < 150 then
                            DebugPrint('[ANTICHEAT] ⚡ INSTANT TARGET SWITCH! ' .. math.floor(avgSwitch) .. 'ms')
                            TriggerServerEvent('anticheat:suspiciousAccuracy', 'instant_switch', math.floor(avgSwitch) .. 'ms')
                            aimbotData.targetSwitchTimes = {}
                        end
                    end
                end
            end
            
            aimbotData.lastTargetEntity = victim
            aimbotData.lastShotTime = currentTime
            
            -- ═══════════════════════════════════════════════════════════
            -- REPORT TO SERVER FOR SERVER-SIDE ANALYSIS
            -- ═══════════════════════════════════════════════════════════
            local targetType = isPlayer and 'player' or 'npc'
            TriggerServerEvent('anticheat:hitRegistered', targetType, math.floor(distance), isHeadshot, weaponHash, boneIndex)
            
            -- Kill rate tracking
            if isFatal then
                -- Report kill to server
                local victimServerId = isPlayer and GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim)) or 0
                TriggerServerEvent('anticheat:killRegistered', victimServerId, math.floor(distance), isHeadshot, weaponHash)
                
                if not aimbotData.kills then aimbotData.kills = {} end
                table.insert(aimbotData.kills, currentTime)
                while #aimbotData.kills > 0 and (currentTime - aimbotData.kills[1]) > 60000 do
                    table.remove(aimbotData.kills, 1)
                end
                if #aimbotData.kills >= 10 then
                    local timeSpan = (currentTime - aimbotData.kills[1]) / 1000
                    local killsPerMinute = (#aimbotData.kills / timeSpan) * 60
                    if killsPerMinute > 30 then
                        DebugPrint('[ANTICHEAT] 💀 IMPOSSIBLE KILL RATE! ' .. math.floor(killsPerMinute) .. '/min')
                        TriggerServerEvent('anticheat:suspiciousAccuracy', 'kill_rate', math.floor(killsPerMinute) .. '/min')
                    end
                end
            end
        end
    end
end)

-- ============================================
-- METHOD 6-7: AIM SNAP & SMOOTH AIMBOT DETECTION
-- ============================================
CreateThread(function()
    Wait(8000)
    DebugPrint('[ANTICHEAT] Anti-Aimbot v3.0 Active (10 Methods)')
    
    while true do
        Wait(33)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            
            if IsPlayerFreeAiming(PlayerId()) then
                local camRot = GetGameplayCamRot(2)
                local currentRot = vector3(camRot.x, camRot.y, camRot.z)
                
                if aimbotData.lastCamRot then
                    local rotDelta = math.sqrt(
                        (currentRot.x - aimbotData.lastCamRot.x)^2 + 
                        (currentRot.z - aimbotData.lastCamRot.z)^2
                    )
                    local rotSpeed = rotDelta / 0.033
                    
                    table.insert(aimbotData.aimSmoothness, rotSpeed)
                    while #aimbotData.aimSmoothness > 30 do
                        table.remove(aimbotData.aimSmoothness, 1)
                    end
                    
                    -- METHOD 6: Snap detection
                    if rotSpeed > 600 then
                        Wait(40)
                        local newRot = GetGameplayCamRot(2)
                        local afterDelta = math.sqrt(
                            (newRot.x - currentRot.x)^2 + 
                            (newRot.z - currentRot.z)^2
                        )
                        local afterSpeed = afterDelta / 0.04
                        
                        if afterSpeed < 80 then
                            aimbotData.aimSnapCount = aimbotData.aimSnapCount + 1
                            DebugPrint('[ANTICHEAT] ⚡ AIM SNAP! ' .. math.floor(rotSpeed) .. ' → ' .. math.floor(afterSpeed) .. ' deg/s')
                            
                            if aimbotData.aimSnapCount >= 4 then
                                TriggerServerEvent('anticheat:aimbotSnap', math.floor(rotSpeed), aimbotData.aimSnapCount)
                                aimbotData.aimSnapCount = 0
                            end
                        end
                    end
                    
                    -- METHOD 7: Smooth aimbot detection
                    if #aimbotData.aimSmoothness >= 20 then
                        local stdDev = CalculateStdDev(aimbotData.aimSmoothness)
                        local avgSpeed = 0
                        for _, s in ipairs(aimbotData.aimSmoothness) do
                            avgSpeed = avgSpeed + s
                        end
                        avgSpeed = avgSpeed / #aimbotData.aimSmoothness
                        
                        if stdDev < 5 and avgSpeed > 30 and avgSpeed < 200 then
                            aimbotData.smoothAimViolations = aimbotData.smoothAimViolations + 1
                            
                            if aimbotData.smoothAimViolations >= 10 then
                                DebugPrint('[ANTICHEAT] 🤖 SMOOTH AIMBOT! StdDev: ' .. string.format("%.1f", stdDev))
                                TriggerServerEvent('anticheat:suspiciousAccuracy', 'smooth_aimbot', string.format("%.1f", stdDev))
                                aimbotData.smoothAimViolations = 0
                                aimbotData.aimSmoothness = {}
                            end
                        else
                            aimbotData.smoothAimViolations = math.max(0, aimbotData.smoothAimViolations - 1)
                        end
                    end
                end
                
                aimbotData.lastCamRot = currentRot
            else
                aimbotData.lastCamRot = nil
                aimbotData.aimSnapCount = math.max(0, aimbotData.aimSnapCount - 0.05)
            end
        end
    end
end)

-- ============================================
-- METHOD 8: TRIGGERBOT DETECTION
-- Detects instant shooting when crosshair on target
-- ============================================
local triggerbotData = {
    aimStartTime = 0,
    wasAimingAtTarget = false,
    reactionTimes = {},
    violations = 0
}

CreateThread(function()
    Wait(10000)
    
    while true do
        Wait(16)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            
            if IsPlayerFreeAiming(PlayerId()) then
                local _, targetEntity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                local isAimingAtPed = targetEntity and DoesEntityExist(targetEntity) and IsEntityAPed(targetEntity)
                
                if isAimingAtPed and not triggerbotData.wasAimingAtTarget then
                    triggerbotData.aimStartTime = GetGameTimer()
                    triggerbotData.wasAimingAtTarget = true
                elseif not isAimingAtPed then
                    triggerbotData.wasAimingAtTarget = false
                end
                
                if isAimingAtPed and IsPedShooting(ped) and triggerbotData.aimStartTime > 0 then
                    local reactionTime = GetGameTimer() - triggerbotData.aimStartTime
                    
                    if reactionTime < 100 and reactionTime > 0 then
                        table.insert(triggerbotData.reactionTimes, reactionTime)
                        while #triggerbotData.reactionTimes > 10 do
                            table.remove(triggerbotData.reactionTimes, 1)
                        end
                        
                        if #triggerbotData.reactionTimes >= 5 then
                            local avgReaction = 0
                            for _, t in ipairs(triggerbotData.reactionTimes) do
                                avgReaction = avgReaction + t
                            end
                            avgReaction = avgReaction / #triggerbotData.reactionTimes
                            
                            if avgReaction < 80 then
                                triggerbotData.violations = triggerbotData.violations + 1
                                DebugPrint('[ANTICHEAT] 🔫 TRIGGERBOT! Avg: ' .. math.floor(avgReaction) .. 'ms')
                                
                                if triggerbotData.violations >= 3 then
                                    TriggerServerEvent('anticheat:suspiciousAccuracy', 'triggerbot', math.floor(avgReaction) .. 'ms')
                                    triggerbotData.violations = 0
                                    triggerbotData.reactionTimes = {}
                                end
                            end
                        end
                    end
                    triggerbotData.aimStartTime = 0
                end
            else
                triggerbotData.wasAimingAtTarget = false
                triggerbotData.aimStartTime = 0
            end
        end
    end
end)

-- ============================================
-- METHOD 9: NO RECOIL DETECTION
-- Detects weapons firing without recoil
-- ============================================
local recoilData = {
    lastShotRot = nil,
    shotRotations = {},
    noRecoilCount = 0
}

CreateThread(function()
    Wait(12000)
    
    while true do
        Wait(50)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            
            if IsPedShooting(ped) then
                local camRot = GetGameplayCamRot(2)
                
                if recoilData.lastShotRot then
                    local recoilAmount = camRot.x - recoilData.lastShotRot.x
                    
                    table.insert(recoilData.shotRotations, recoilAmount)
                    while #recoilData.shotRotations > 15 do
                        table.remove(recoilData.shotRotations, 1)
                    end
                    
                    if #recoilData.shotRotations >= 10 then
                        local zeroRecoilCount = 0
                        
                        for _, r in ipairs(recoilData.shotRotations) do
                            if math.abs(r) < 0.1 then
                                zeroRecoilCount = zeroRecoilCount + 1
                            end
                        end
                        
                        if zeroRecoilCount >= 8 then
                            recoilData.noRecoilCount = recoilData.noRecoilCount + 1
                            DebugPrint('[ANTICHEAT] 🔫 NO RECOIL! ' .. zeroRecoilCount .. '/10 zero recoil')
                            
                            if recoilData.noRecoilCount >= 3 then
                                TriggerServerEvent('anticheat:suspiciousAccuracy', 'no_recoil', zeroRecoilCount .. '/10')
                                recoilData.noRecoilCount = 0
                                recoilData.shotRotations = {}
                            end
                        end
                    end
                end
                
                recoilData.lastShotRot = camRot
                Wait(100)
            end
        end
    end
end)

-- ============================================
-- METHOD 10: MISS TRACKING (Reset consecutive hits)
-- ============================================
CreateThread(function()
    Wait(5000)
    
    while true do
        Wait(100)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            
            if IsPedShooting(ped) then
                local shotTime = GetGameTimer()
                if aimbotData.totalShots then
                    aimbotData.totalShots = aimbotData.totalShots + 1
                end
                Wait(150)
                
                if aimbotData.lastShotTime and aimbotData.lastShotTime < shotTime then
                    aimbotData.consecutiveHits = 0
                end
            end
        end
    end
end)


-- ============================================
-- ANTI-LUA EXECUTOR DETECTION (CAREFUL VERSION)
-- Detects Eulen, Hammafia, and other Lua executors
-- Only bans on CONFIRMED detections, not suspicious activity
-- ============================================

local luaExecutorData = {
    violations = 0,
    confirmedMenus = {},
    lastCheck = 0
}

-- ONLY known cheat menu global variables (very specific)
local confirmedCheatGlobals = {
    -- Eulen (confirmed)
    'Eulen', 'EulenMenu', 'EulenAPI',
    -- Hammafia (confirmed)
    'Hammafia', 'HammafiaMenu', 'HammafiaAPI',
    -- Lynx (confirmed)
    'LynxMenu', 'LynxAPI',
    -- RedEngine (confirmed)
    'RedEngine', 'RedEngineMenu',
    -- Brutan (confirmed)
    'BrutanMenu', 'BrutanAPI',
    -- Cherax (confirmed)
    'CheraxMenu', 'CheraxAPI',
    -- Skid (confirmed)
    'SkidMenu', 'SkidAPI',
    -- 2Take1 (confirmed)
    '2Take1', '2T1Menu',
    -- Stand (confirmed)
    'StandMenu', 'StandAPI',
}

-- Check ONLY for confirmed cheat menu globals
CreateThread(function()
    Wait(30000) -- Wait 30 seconds before checking (let everything load)
    
    while true do
        Wait(10000) -- Check every 10 seconds (not too aggressive)
        
        if ShouldCheckPlayer() then
            -- ONLY check for CONFIRMED cheat menu globals
            for _, globalName in ipairs(confirmedCheatGlobals) do
                local found = false
                
                -- Check _G
                if _G[globalName] ~= nil then
                    found = true
                end
                
                -- Check rawget
                if rawget(_G, globalName) ~= nil then
                    found = true
                end
                
                if found and not luaExecutorData.confirmedMenus[globalName] then
                    luaExecutorData.confirmedMenus[globalName] = true
                    luaExecutorData.violations = luaExecutorData.violations + 1
                    DebugPrint('[ANTICHEAT] CONFIRMED CHEAT MENU: ' .. globalName)
                    TriggerServerEvent('anticheat:luaExecutorConfirmed', globalName)
                end
            end
        end
    end
end)

DebugPrint('[ANTICHEAT] Anti-Lua Executor loaded (careful mode)!')


-- ============================================
-- ============================================
-- ANTI-WEAPON MODIFIER v3.0 (REWRITTEN)
-- Rapid Fire, Infinite Ammo, No Reload
-- ============================================

local weaponData = {
    lastAmmo = -1,
    lastShotTime = 0,
    shotsInClip = 0,
    infiniteAmmoCount = 0,
    rapidFireCount = 0
}

-- Common melee weapons to ignore
local meleeWeapons = {}
for _, w in ipairs({'WEAPON_KNIFE', 'WEAPON_BAT', 'WEAPON_CROWBAR', 'WEAPON_HAMMER', 'WEAPON_MACHETE', 'WEAPON_FLASHLIGHT', 'WEAPON_KNUCKLE', 'WEAPON_NIGHTSTICK', 'WEAPON_WRENCH', 'WEAPON_POOLCUE', 'WEAPON_BOTTLE', 'WEAPON_DAGGER', 'WEAPON_HATCHET', 'WEAPON_SWITCHBLADE', 'WEAPON_BATTLEAXE', 'WEAPON_STONE_HATCHET', 'WEAPON_UNARMED'}) do
    meleeWeapons[GetHashKey(w)] = true
end

-- Weapons that are naturally very fast or special (Exceptions for Rapid Fire)
local fastWeapons = {
    [GetHashKey('WEAPON_MINIGUN')] = true,
    [GetHashKey('WEAPON_RAYPISTOL')] = true,
    [GetHashKey('WEAPON_MG')] = true,
    [GetHashKey('WEAPON_COMBATMG')] = true,
    [GetHashKey('WEAPON_COMBATMG_MK2')] = true,
}

CreateThread(function()
    Wait(15000)
    DebugPrint('[ANTICHEAT] Advanced Weapon Modifier Protection v3.0 Active')
    
    while true do
        -- Optimize: Check less often when idle, every frame when shooting
        local sleep = 200
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            
            if IsPedShooting(ped) then
                sleep = 0 -- Run every frame while shooting for accuracy
                
                local weapon = GetSelectedPedWeapon(ped)
                
                -- Skip melee and unarmed
                if not meleeWeapons[weapon] and weapon ~= 966099553 then 
                    
                    local _, currentAmmo = GetAmmoInClip(ped, weapon)
                    local now = GetGameTimer()
                    local maxClip = GetMaxAmmoInClip(ped, weapon, true)
                    
                    -- ===========================
                    -- 1. INFINITE AMMO & NO RELOAD
                    -- ===========================
                    if weaponData.lastAmmo ~= -1 and maxClip > 0 then
                        -- Removed debug prints for production

                        if currentAmmo > weaponData.lastAmmo then
                            -- Ammo increased (Reload or Magic?)
                            if currentAmmo == maxClip then
                                -- Likely a instant reload or genuine reload finished just now
                                weaponData.shotsInClip = 0
                            end
                        elseif currentAmmo == weaponData.lastAmmo then
                            -- Ammo didn't change while shooting (Infinite Ammo)
                            -- We allow small glitches, but consistent non-drop is a cheat
                            weaponData.infiniteAmmoCount = weaponData.infiniteAmmoCount + 1
                            
                            if weaponData.infiniteAmmoCount >= 3 then -- ULTRA STRICT: 3 shots = BAN
                                DebugPrint('[ANTICHEAT] INFINITE AMMO DETECTED! Stuck at ' .. currentAmmo)
                                TriggerServerEvent('anticheat:weaponModifier', 'infinite_ammo', weapon)
                                weaponData.infiniteAmmoCount = 0
                                Wait(1000)
                            end
                        else
                            -- Ammo decreased naturally
                            weaponData.infiniteAmmoCount = 0
                            weaponData.shotsInClip = weaponData.shotsInClip + 1
                        end
                        
                        -- NO RELOAD CHECK: STRICT - only +2 tolerance
                        if weaponData.shotsInClip > (maxClip + 2) and maxClip > 5 then
                            DebugPrint('[ANTICHEAT] NO RELOAD DETECTED! Fired ' .. weaponData.shotsInClip .. ' shots (Max: ' .. maxClip .. ')')
                            TriggerServerEvent('anticheat:weaponModifier', 'no_reload_clip', weapon)
                            weaponData.shotsInClip = 0
                            Wait(1000)
                        end
                    end
                    
                    -- ===========================
                    -- 2. RAPID FIRE (Frame-perfect delta check)
                    -- ===========================
                    if weaponData.lastShotTime > 0 then
                        local timeDiff = now - weaponData.lastShotTime
                        
                        -- Limit 40ms = ~1500 RPM (Most rifles are 600-900 RPM)
                        local limit = 40 
                        if fastWeapons[weapon] then limit = 15 end -- Miniguns need 15ms
                        
                        if timeDiff < limit and timeDiff > 0 then 
                            -- Shot was too fast
                            weaponData.rapidFireCount = weaponData.rapidFireCount + 1
                            
                            -- STRICT: 10 rapid shots = BAN
                            if weaponData.rapidFireCount >= 10 then
                                DebugPrint('[ANTICHEAT] RAPID FIRE DETECTED! Avg interval: ' .. timeDiff .. 'ms')
                                TriggerServerEvent('anticheat:weaponModifier', 'rapid_fire', weapon)
                                weaponData.rapidFireCount = 0 
                                Wait(1000)
                            end
                        else
                            -- Shot was normal speed, decay counter quickly
                            weaponData.rapidFireCount = math.max(0, weaponData.rapidFireCount - 2)
                        end
                    end
                    
                    weaponData.lastShotTime = now
                    weaponData.lastAmmo = currentAmmo
                end
            else
                -- Not shooting
                local ped = PlayerPedId()
                
                -- Detect Reloading to reset counters
                if IsPedReloading(ped) then
                    weaponData.shotsInClip = 0
                    weaponData.infiniteAmmoCount = 0
                end
                
                -- Sync logic for ammo tracking (prevent false positives on weapon switch)
                local weapon = GetSelectedPedWeapon(ped)
                local _, currentAmmo = GetAmmoInClip(ped, weapon)
                if currentAmmo ~= weaponData.lastAmmo then
                    weaponData.lastAmmo = currentAmmo
                    -- If ammo changed while not shooting, likely weapon switch or reload
                    weaponData.shotsInClip = 0 
                end
                
                -- Reset rapid fire count when not shooting
                weaponData.rapidFireCount = 0
            end
        end
        
        Wait(sleep)
    end
end)

DebugPrint('[ANTICHEAT] Anti-Weapon Modifier loaded!')


-- ============================================
-- UNIFIED ANTI-FREECAM / SPECTATE SYSTEM v4.0
-- Camera tracking, Wall detection, Player spectating
-- ============================================

local freecamData = {
    violations = 0,
    lastCamPos = nil,
    lastPlayerPos = nil,
    maxViolations = 20 -- Increased from 8 to reduce false positives
}

CreateThread(function()
    Wait(20000)
    DebugPrint('[ANTICHEAT] Unified Anti-Freecam System v4.0 Active')

    while true do
        Wait(400)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local camCoords = GetGameplayCamCoord()
            
            -- ===========================
            -- GLOBAL EXEMPTIONS
            -- ===========================
            if IsEntityDead(ped) or 
               IsPedRagdoll(ped) or 
               IsCutsceneActive() or 
               IsScreenFadedOut() or 
               IsScreenFadingOut() or
               IsScreenFadingIn() or
               GetRenderingCam() ~= -1 then -- Scripted camera (mechanic, clothes, etc)
                
                freecamData.violations = math.max(0, freecamData.violations - 1)
                goto continueFreecam
            end

            local distance = #(pedCoords - camCoords)

            -- ===========================
            -- 1. DISTANCE-BASED DETECTION
            -- ===========================
            local maxDist = 25.0 -- Default on foot
            
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                local model = GetEntityModel(veh)
                if IsThisModelAHeli(model) or IsThisModelAPlane(model) then
                    maxDist = 180.0 -- Aircraft have huge zoom
                elseif IsThisModelABoat(model) then
                    maxDist = 80.0
                else
                    maxDist = 70.0 -- Cars/bikes
                end
            elseif IsPedInParachuteFreeFall(ped) or IsPedFalling(ped) then
                maxDist = 120.0
            end
            
            -- Extra distance for aiming (sniper scopes)
            if IsPlayerFreeAiming(PlayerId()) then
                maxDist = maxDist + 60.0
            end
            
            -- First person mode = close camera
            if GetFollowPedCamViewMode() == 4 then
                maxDist = 5.0
            end

            if distance > maxDist then
                freecamData.violations = freecamData.violations + 1 -- Reduced from 2
                DebugPrint('[ANTICHEAT] FREECAM! Dist: ' .. math.floor(distance) .. 'm (Max: ' .. maxDist .. 'm)')
            else
                freecamData.violations = math.max(0, freecamData.violations - 0.5)
            end

            -- ===========================
            -- 2. CAMERA THROUGH WALLS (Raycast)
            -- ===========================
            if distance > 5.0 then
                local ray = StartShapeTestRay(
                    pedCoords.x, pedCoords.y, pedCoords.z + 0.5,
                    camCoords.x, camCoords.y, camCoords.z,
                    1, -- World geometry only
                    ped,
                    0
                )
                local _, hit, _, _, _ = GetShapeTestResult(ray)
                
                if hit and distance > 30.0 then
                    -- Camera is behind a wall AND far away
                    freecamData.violations = freecamData.violations + 1
                    DebugPrint('[ANTICHEAT] CAMERA THROUGH WALL! Dist: ' .. math.floor(distance) .. 'm')
                end
            end

            -- ===========================
            -- 3. STATIONARY PLAYER + FAST CAMERA
            -- ===========================
            if freecamData.lastCamPos and freecamData.lastPlayerPos then
                local camMoved = #(camCoords - freecamData.lastCamPos)
                local playerMoved = #(pedCoords - freecamData.lastPlayerPos)
                
                -- Player barely moved but camera flew across the map
                if playerMoved < 2.0 and camMoved > 50.0 and not IsPedInAnyVehicle(ped, false) then -- Increased from 30.0 to 50.0
                    freecamData.violations = freecamData.violations + 2 -- Reduced from 3
                    DebugPrint('[ANTICHEAT] SPECTATE MODE! Cam speed: ' .. math.floor(camMoved * 2.5) .. 'm/s')
                end
            end
            
            freecamData.lastCamPos = camCoords
            freecamData.lastPlayerPos = pedCoords

            -- ===========================
            -- CHECK BAN THRESHOLD
            -- ===========================
            if freecamData.violations >= freecamData.maxViolations then
                DebugPrint('[ANTICHEAT] FREECAM CONFIRMED! Banning...')
                TriggerServerEvent('anticheat:freecamDetected', math.floor(distance))
                freecamData.violations = 0
            end
            
            ::continueFreecam::
        end
    end
end)

-- ============================================
-- SPECTATING OTHER PLAYERS DETECTION
-- Detects when camera is closer to another player than you
-- ============================================
CreateThread(function()
    Wait(25000)
    DebugPrint('[ANTICHEAT] Spectate Other Players Detection Active')
    
    while true do
        Wait(1500)
        
        if ShouldCheckPlayer() then
            local ped = PlayerPedId()
            local myCoords = GetEntityCoords(ped)
            local camCoords = GetGameplayCamCoord()
            local camRot = GetGameplayCamRot(2)
            
            -- Skip if in legit state
            if IsEntityDead(ped) or GetRenderingCam() ~= -1 then
                goto continueSpectateOther
            end
            
            -- Calculate camera forward direction
            local radX = math.rad(camRot.x)
            local radZ = math.rad(camRot.z)
            local forward = vector3(
                -math.sin(radZ) * math.cos(radX),
                math.cos(radZ) * math.cos(radX),
                math.sin(radX)
            )
            
            -- Check each other player
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local otherPed = GetPlayerPed(playerId)
                    if DoesEntityExist(otherPed) then
                        local otherCoords = GetEntityCoords(otherPed)
                        local distCamToOther = #(camCoords - otherCoords)
                        local distMeToOther = #(myCoords - otherCoords)
                        
                        -- Camera is WAY closer to other player than we are
                        if distCamToOther < distMeToOther - 80.0 and distMeToOther > 150.0 then
                            -- Check if actually looking at them
                            local toOther = otherCoords - camCoords
                            local toOtherNorm = toOther / #toOther
                            local dot = forward.x * toOtherNorm.x + forward.y * toOtherNorm.y + forward.z * toOtherNorm.z
                            
                            if dot > 0.7 then -- Looking at them
                                freecamData.violations = freecamData.violations + 2 -- Reduced from 4
                                DebugPrint('[ANTICHEAT] SPECTATING PLAYER! Dist to them: ' .. math.floor(distMeToOther) .. 'm')
                                
                                if freecamData.violations >= freecamData.maxViolations then
                                    TriggerServerEvent('anticheat:freecamDetected', math.floor(distMeToOther))
                                    freecamData.violations = 0
                                end
                            end
                        end
                    end
                end
            end
            
            ::continueSpectateOther::
        end
    end
end)

DebugPrint('[ANTICHEAT] Anti-Freecam/Spectate System loaded!')





-- ============================================
-- ANTI-BLACKLISTED PLATES
-- Detects cheaters who change vehicle plates to known cheat signatures
-- ============================================

if Config and Config.Anticheat and Config.Anticheat.enabled and Config.BlacklistedPlates then
    CreateThread(function()
        Wait(20000) -- Wait for player to fully load
        DebugPrint('[ANTICHEAT] Anti-Blacklisted Plates System Active')
        
        local checkInterval = Config.PlateCheckInterval or 5000
        local checkedVehicles = {} -- Cache to avoid spam
        
        while true do
            Wait(checkInterval)
            
            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped, false) then
                goto continuePlateCheck
            end
            
            local vehicle = GetVehiclePedIsIn(ped, false)
            if not vehicle or vehicle == 0 then
                goto continuePlateCheck
            end
            
            -- Get plate
            local plate = GetVehicleNumberPlateText(vehicle)
            if not plate or plate == '' then
                goto continuePlateCheck
            end
            
            -- Clean plate (remove spaces)
            plate = string.gsub(plate, "%s+", "")
            
            -- Check if already checked this vehicle recently
            if checkedVehicles[vehicle] and checkedVehicles[vehicle] == plate then
                goto continuePlateCheck
            end
            
            -- Check against blacklist
            for _, blacklistedPlate in ipairs(Config.BlacklistedPlates) do
                local cleanBlacklist = string.gsub(blacklistedPlate, "%s+", "")
                
                -- Case-insensitive check
                if string.lower(plate) == string.lower(cleanBlacklist) or 
                   string.find(string.lower(plate), string.lower(cleanBlacklist), 1, true) then
                    
                    DebugPrint('[ANTICHEAT] [CLIENT] BLACKLISTED PLATE DETECTED!')
                    DebugPrint('[ANTICHEAT] [CLIENT] Plate: ' .. plate)
                    DebugPrint('[ANTICHEAT] [CLIENT] Matched: ' .. blacklistedPlate)
                    DebugPrint('[ANTICHEAT] [CLIENT] Vehicle NetId: ' .. tostring(VehToNet(vehicle)))
                    DebugPrint('[ANTICHEAT] [CLIENT] Sending event to server...')
                    
                    -- Report to server
                    TriggerServerEvent('anticheat:blacklistedPlate', plate, blacklistedPlate, VehToNet(vehicle))
                    
                    DebugPrint('[ANTICHEAT] [CLIENT] Event sent!')
                    
                    -- Mark as checked to avoid spam
                    checkedVehicles[vehicle] = plate
                    
                    break
                end
            end
            
            -- Cache this vehicle as checked
            checkedVehicles[vehicle] = plate
            
            ::continuePlateCheck::
        end
    end)
end

DebugPrint('[ANTICHEAT] Anti-Blacklisted Plates loaded!')


-- ============================================
-- ANTI-ILLEGAL VEHICLE MODIFICATIONS
-- Detects when players modify vehicles outside mechanic shops
-- ============================================

if Config and Config.Anticheat and Config.Anticheat.enabled and Config.MechanicShops then
    CreateThread(function()
        Wait(25000)
        DebugPrint('[ANTICHEAT] Anti-Illegal Vehicle Modifications Active')
        
        local checkInterval = Config.VehicleModCheckInterval or 2000
        local lastVehicleData = {}
        
        -- Helper: Check if player is in a mechanic shop
        local function IsInMechanicShop()
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            
            for _, shop in ipairs(Config.MechanicShops) do
                local distance = #(coords - shop.coords)
                if distance <= shop.radius then
                    return true, shop.name
                end
            end
            
            return false, nil
        end
        
        -- Helper: Get vehicle mod data
        local function GetVehicleModData(vehicle)
            return {
                engine = GetVehicleMod(vehicle, 11), -- Engine
                brakes = GetVehicleMod(vehicle, 12), -- Brakes
                transmission = GetVehicleMod(vehicle, 13), -- Transmission
                suspension = GetVehicleMod(vehicle, 15), -- Suspension
                armor = GetVehicleMod(vehicle, 16), -- Armor
                turbo = IsToggleModOn(vehicle, 18), -- Turbo
                primaryColor = GetVehicleColours(vehicle),
                customPrimaryColor = GetIsVehiclePrimaryColourCustom(vehicle),
                livery = GetVehicleLivery(vehicle),
                windowTint = GetVehicleWindowTint(vehicle),
            }
        end
        
        -- Helper: Compare vehicle data
        local function HasVehicleChanged(oldData, newData)
            if not oldData then return false end
            
            -- Check performance mods
            if oldData.engine ~= newData.engine then return true, "Engine Level" end
            if oldData.brakes ~= newData.brakes then return true, "Brakes" end
            if oldData.transmission ~= newData.transmission then return true, "Transmission" end
            if oldData.suspension ~= newData.suspension then return true, "Suspension" end
            if oldData.armor ~= newData.armor then return true, "Armor" end
            if oldData.turbo ~= newData.turbo then return true, "Turbo" end
            
            -- Check visual mods
            if oldData.primaryColor ~= newData.primaryColor then return true, "Primary Color" end
            if oldData.customPrimaryColor ~= newData.customPrimaryColor then return true, "Custom Color" end
            if oldData.livery ~= newData.livery then return true, "Livery" end
            if oldData.windowTint ~= newData.windowTint then return true, "Window Tint" end
            
            return false, nil
        end
        
        while true do
            Wait(checkInterval)
            
            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped, false) then
                lastVehicleData = {}
                goto continueModCheck
            end
            
            local vehicle = GetVehiclePedIsIn(ped, false)
            if not vehicle or vehicle == 0 then
                goto continueModCheck
            end
            
            -- Get current vehicle data
            local currentData = GetVehicleModData(vehicle)
            
            -- Check if vehicle has changed
            if lastVehicleData[vehicle] then
                local hasChanged, modType = HasVehicleChanged(lastVehicleData[vehicle], currentData)
                
                if hasChanged then
                    -- Check if in mechanic shop
                    local inShop, shopName = IsInMechanicShop()
                    
                    if not inShop then
                        DebugPrint('[ANTICHEAT] [CLIENT] ILLEGAL VEHICLE MODIFICATION DETECTED!')
                        DebugPrint('[ANTICHEAT] [CLIENT] Type: ' .. tostring(modType))
                        DebugPrint('[ANTICHEAT] [CLIENT] Vehicle NetId: ' .. tostring(VehToNet(vehicle)))
                        DebugPrint('[ANTICHEAT] [CLIENT] Sending event to server...')
                        
                        -- Report to server
                        local coords = GetEntityCoords(ped)
                        TriggerServerEvent('anticheat:illegalVehicleMod', modType, coords, VehToNet(vehicle))
                        
                        DebugPrint('[ANTICHEAT] [CLIENT] Event sent!')
                        
                        -- Clear cache to avoid spam
                        lastVehicleData[vehicle] = nil
                        
                        goto continueModCheck
                    else
                        -- In shop, update cache silently
                        lastVehicleData[vehicle] = currentData
                    end
                end
            else
                -- First time seeing this vehicle, cache it
                lastVehicleData[vehicle] = currentData
            end
            
            ::continueModCheck::
        end
    end)
end

DebugPrint('[ANTICHEAT] Anti-Illegal Vehicle Modifications loaded!')


-- ============================================
-- AC INFO UI - Minimal & Beautiful
-- ============================================
local infoUIActive = false

RegisterNetEvent('anticheat:showInfo', function()
    if infoUIActive then return end
    
    infoUIActive = true
    
    -- Disable controls while UI is open
    CreateThread(function()
        while infoUIActive do
            Wait(0)
            
            -- Disable all controls except ESC and Enter
            DisableAllControlActions(0)
            EnableControlAction(0, 322, true) -- ESC
            EnableControlAction(0, 18, true)  -- Enter
            EnableControlAction(0, 191, true) -- Enter (alternative)
            
            -- Check for Enter key to close
            if IsControlJustPressed(0, 18) or IsControlJustPressed(0, 191) then
                infoUIActive = false
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
        end
    end)
    
    -- Draw the UI
    CreateThread(function()
        local startTime = GetGameTimer()
        local fadeInDuration = 300
        
        while infoUIActive do
            Wait(0)
            
            -- Calculate fade in alpha
            local elapsed = GetGameTimer() - startTime
            local fadeAlpha = math.min(255, (elapsed / fadeInDuration) * 255)
            
            -- Background overlay
            DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, math.floor(180 * (fadeAlpha / 255)))
            
            -- Main panel background (minimal dark)
            local panelX = 0.5
            local panelY = 0.5
            local panelW = 0.35
            local panelH = 0.55  -- Increased from 0.45 to 0.55
            
            DrawRect(panelX, panelY, panelW, panelH, 15, 15, 20, math.floor(fadeAlpha))
            
            -- Top accent line (cyan)
            DrawRect(panelX, panelY - (panelH / 2) + 0.002, panelW, 0.004, 0, 200, 255, math.floor(fadeAlpha))
            
            -- Title
            SetTextFont(4)
            SetTextProportional(1)
            SetTextScale(0.0, 0.55)
            SetTextColour(0, 200, 255, math.floor(fadeAlpha))
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("AETHER ANTICHEAT")
            DrawText(panelX, panelY - (panelH / 2) + 0.025)
            
            -- Version
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.35)
            SetTextColour(150, 150, 150, math.floor(fadeAlpha))
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("Version 4.5")
            DrawText(panelX, panelY - (panelH / 2) + 0.065)
            
            -- Separator line
            DrawRect(panelX, panelY - (panelH / 2) + 0.095, panelW - 0.04, 0.001, 100, 100, 100, math.floor(fadeAlpha))
            
            -- Info sections
            local startY = panelY - (panelH / 2) + 0.12
            local lineHeight = 0.04
            
            -- Developer
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.32)
            SetTextColour(200, 200, 200, math.floor(fadeAlpha))
            SetTextCentre(false)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("Developer:")
            DrawText(panelX - (panelW / 2) + 0.03, startY)
            
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.32)
            SetTextColour(255, 255, 255, math.floor(fadeAlpha))
            SetTextCentre(false)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("konpep")
            DrawText(panelX + 0.05, startY)
            
            -- Protection Level
            startY = startY + lineHeight
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.32)
            SetTextColour(200, 200, 200, math.floor(fadeAlpha))
            SetTextCentre(false)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("Protection Level:")
            DrawText(panelX - (panelW / 2) + 0.03, startY)
            
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.32)
            SetTextColour(0, 255, 100, math.floor(fadeAlpha))
            SetTextCentre(false)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("Advanced")
            DrawText(panelX + 0.05, startY)
            
            -- Features title
            startY = startY + lineHeight + 0.02
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.35)
            SetTextColour(0, 200, 255, math.floor(fadeAlpha))
            SetTextCentre(false)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("FEATURES")
            DrawText(panelX - (panelW / 2) + 0.03, startY)
            
            -- Feature list
            local features = {
                "Godmode Detection",
                "Noclip Detection",
                "Teleport Detection",
                "Weapon/Vehicle Spawn",
                "Blacklisted Plates",
                "Illegal Vehicle Mods",
                "Resource Protection",
                "Screenshot System"
            }
            
            startY = startY + 0.035
            for i, feature in ipairs(features) do
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.30)
                SetTextColour(180, 180, 180, math.floor(fadeAlpha))
                SetTextCentre(false)
                SetTextDropshadow(0, 0, 0, 0, 0)
                SetTextEdge(0, 0, 0, 0, 0)
                SetTextEntry("STRING")
                AddTextComponentString("~c~• ~s~" .. feature)
                DrawText(panelX - (panelW / 2) + 0.03, startY + ((i - 1) * 0.035))
            end
            
            -- Bottom instruction
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.30)
            SetTextColour(100, 100, 100, math.floor(fadeAlpha))
            SetTextCentre(true)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("Press ~b~ENTER~s~ to close")
            DrawText(panelX, panelY + (panelH / 2) - 0.025)
        end
    end)
end)
