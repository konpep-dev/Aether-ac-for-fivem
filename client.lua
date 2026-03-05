local isOpen = false
local hasPermission = false
local adminGroup = nil
local adminPerms = nil
local espEnabled = false
local noclipEnabled = false
local spectating = false
local spectateTarget = nil

-- Initialize framework on client
CreateThread(function()
    Wait(1000)
    Framework.Detect()
end)

-- Check permission on resource start
CreateThread(function()
    Wait(2000)
    TriggerServerEvent('aether_admin:checkPermission')
end)

RegisterNetEvent('aether_admin:permissionResult', function(result, group, perms)
    hasPermission = result
    adminGroup = group
    adminPerms = perms
end)

-- Open command
RegisterCommand(Config.OpenCommand, function()
    if hasPermission then
        OpenAdminPanel()
    else
        Framework.Notify('No permission', 'error')
    end
end, false)

-- Keybinds (Default: INSERT for panel, DELETE for noclip)
-- Note: Players can change these in Settings > Key Bindings > FiveM
RegisterKeyMapping(Config.OpenCommand, 'Open Admin Panel', 'keyboard', 'INSERT')
RegisterKeyMapping('adminnoclip', 'Admin Noclip', 'keyboard', 'DELETE')

-- Noclip command
RegisterCommand('adminnoclip', function()
    if hasPermission and adminPerms and adminPerms.noclip then
        noclipEnabled = not noclipEnabled
        ToggleNoclip(noclipEnabled)
        Framework.Notify(noclipEnabled and 'Noclip ON' or 'Noclip OFF', 'info')
    end
end, false)

-- Report command for ALL players
RegisterCommand('report', function(_, args)
    local reason = table.concat(args, ' ')
    if reason == '' then
        Framework.Notify('Usage: /report [reason]', 'error')
        return
    end
    
    local players = GetActivePlayers()
    local myCoords = GetEntityCoords(PlayerPedId())
    local closestPlayer = nil
    local closestDistance = 10.0
    
    for _, player in ipairs(players) do
        if player ~= PlayerId() then
            local targetCoords = GetEntityCoords(GetPlayerPed(player))
            local distance = #(myCoords - targetCoords)
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = GetPlayerServerId(player)
            end
        end
    end
    
    local category = 'Other'
    local lowerReason = reason:lower()
    if lowerReason:find('rdm') or lowerReason:find('kill') then category = 'RDM'
    elseif lowerReason:find('vdm') or lowerReason:find('car') then category = 'VDM'
    elseif lowerReason:find('hack') or lowerReason:find('cheat') then category = 'Cheating'
    elseif lowerReason:find('grief') or lowerReason:find('troll') then category = 'Griefing'
    end
    
    TriggerServerEvent('aether_admin:submitReport', closestPlayer, reason, category)
end, false)

TriggerEvent('chat:addSuggestion', '/report', 'Report a player', {{ name = 'reason', help = 'Reason' }})

function OpenAdminPanel()
    if isOpen then return end
    isOpen = true
    SetNuiFocus(true, true)
    
    TriggerServerEvent('aether_admin:getPlayers')
    TriggerServerEvent('aether_admin:getItems')
    TriggerServerEvent('aether_admin:getReports')
    
    local vehicles = {}
    for k, v in pairs(Config.VehicleCategories) do vehicles[k] = v end
    if adminGroup == 'superadmin' and Config.SuperAdminVehicles then
        for k, v in pairs(Config.SuperAdminVehicles) do vehicles[k] = v end
    end
    
    SendNUIMessage({
        action = 'open',
        group = adminGroup,
        perms = adminPerms,
        weather = Config.WeatherTypes,
        locations = Config.TeleportLocations,
        vehicles = vehicles
    })
end

function CloseAdminPanel()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

-- Auto refresh every 5 seconds
CreateThread(function()
    while true do
        Wait(5000)
        if isOpen then
            TriggerServerEvent('aether_admin:getPlayers')
            TriggerServerEvent('aether_admin:getReports')
        end
    end
end)

-- Server events
RegisterNetEvent('aether_admin:updatePlayers', function(players)
    SendNUIMessage({ action = 'updatePlayers', players = players })
end)

RegisterNetEvent('aether_admin:itemsList', function(items)
    SendNUIMessage({ action = 'updateItems', items = items })
end)

RegisterNetEvent('aether_admin:adminsList', function(admins)
    SendNUIMessage({ action = 'updateAdmins', admins = admins })
end)

RegisterNetEvent('aether_admin:reportsList', function(reports)
    SendNUIMessage({ action = 'updateReports', reports = reports })
end)

RegisterNetEvent('aether_admin:newReport', function(report)
    SendNUIMessage({ action = 'newReport', report = report })
    if hasPermission then
        Framework.Notify('New Report: ' .. report.category, 'warning')
    end
end)

RegisterNetEvent('aether_admin:reportUpdated', function(report)
    SendNUIMessage({ action = 'updateReport', report = report })
end)

RegisterNetEvent('aether_admin:reportClosed', function(id)
    SendNUIMessage({ action = 'closeReport', id = id })
end)

-- Screenshot result
RegisterNetEvent('aether_admin:screenshotResult', function(imageData, targetName)
    SendNUIMessage({ action = 'showScreenshot', image = imageData, targetName = targetName })
    Framework.Notify('Screenshot of ' .. targetName, 'success')
end)

-- Inventory viewing
RegisterNetEvent('aether_admin:showInventory', function(data)
    SendNUIMessage({ action = 'showInventory', inventory = data })
end)

RegisterNetEvent('aether_admin:inventoryData', function(data)
    SendNUIMessage({ action = 'showInventory', inventory = data })
end)

-- Logs data
RegisterNetEvent('aether_admin:logsData', function(logs)
    SendNUIMessage({ action = 'updateLogs', logs = logs })
end)

-- Bans data
RegisterNetEvent('aether_admin:bansList', function(bans)
    SendNUIMessage({ action = 'updateBans', bans = bans })
end)

-- NUI Callbacks
RegisterNUICallback('close', function(_, cb) CloseAdminPanel() cb({}) end)
RegisterNUICallback('teleport', function(data, cb)
    if data.coords then SetEntityCoords(PlayerPedId(), data.coords.x, data.coords.y, data.coords.z, false, false, false, false) end
    cb({})
end)
RegisterNUICallback('teleportToPlayer', function(data, cb) TriggerServerEvent('aether_admin:teleportToPlayer', data.id) cb({}) end)
RegisterNUICallback('bringPlayer', function(data, cb) TriggerServerEvent('aether_admin:bringPlayer', data.id) cb({}) end)
RegisterNUICallback('kickPlayer', function(data, cb) TriggerServerEvent('aether_admin:kickPlayer', data.id, data.reason) cb({}) end)
RegisterNUICallback('banPlayer', function(data, cb) TriggerServerEvent('aether_admin:banPlayer', data.id, data.reason, data.duration) cb({}) end)
RegisterNUICallback('freezePlayer', function(data, cb) TriggerServerEvent('aether_admin:freezePlayer', data.id) cb({}) end)
RegisterNUICallback('setWeather', function(data, cb) TriggerServerEvent('aether_admin:setWeather', data.weather) cb({}) end)
RegisterNUICallback('setTime', function(data, cb) TriggerServerEvent('aether_admin:setTime', data.hour, data.minute) cb({}) end)
RegisterNUICallback('revivePlayer', function(data, cb) TriggerServerEvent('aether_admin:revivePlayer', data.id) cb({}) end)
RegisterNUICallback('announce', function(data, cb) TriggerServerEvent('aether_admin:announce', data.message) cb({}) end)
RegisterNUICallback('refreshPlayers', function(_, cb) TriggerServerEvent('aether_admin:getPlayers') cb({}) end)
RegisterNUICallback('getAdmins', function(_, cb) TriggerServerEvent('aether_admin:getAdmins') cb({}) end)
RegisterNUICallback('setAdmin', function(data, cb) TriggerServerEvent('aether_admin:setAdmin', data.license, data.group) cb({}) end)
RegisterNUICallback('removeAdmin', function(data, cb) TriggerServerEvent('aether_admin:removeAdmin', data.license) cb({}) end)
RegisterNUICallback('toggleEsp', function(data, cb) espEnabled = data.enabled cb({}) end)
RegisterNUICallback('giveItem', function(data, cb) TriggerServerEvent('aether_admin:giveItem', data.targetId, data.item, data.count) cb({}) end)
RegisterNUICallback('giveWeapon', function(data, cb) TriggerServerEvent('aether_admin:giveItem', data.targetId or GetPlayerServerId(PlayerId()), data.weapon, 1) cb({}) end)

-- Ban list callbacks
RegisterNUICallback('getBans', function(_, cb) TriggerServerEvent('aether_admin:getBans') cb({}) end)
RegisterNUICallback('unbanPlayer', function(data, cb) TriggerServerEvent('aether_admin:unbanPlayer', data.id) cb({}) end)

-- Anticheat callbacks
RegisterNUICallback('clearEntities', function(data, cb) TriggerServerEvent('aether_admin:clearEntities', data.type, data.radius) cb({}) end)
RegisterNUICallback('warnPlayer', function(data, cb) TriggerServerEvent('aether_admin:warnPlayer', data.id) cb({}) end)
RegisterNUICallback('toggleAnticheatDebug', function(data, cb) TriggerServerEvent('anticheat:toggleDebugMode', data.enabled) cb({}) end)

-- Screenshot callback
RegisterNUICallback('takeScreenshot', function(data, cb) TriggerServerEvent('aether_admin:takeScreenshot', data.id) cb({}) end)

-- Spectate callback
RegisterNUICallback('spectatePlayer', function(data, cb) TriggerServerEvent('aether_admin:spectatePlayer', data.id) cb({}) end)

-- View inventory callback
RegisterNUICallback('viewInventory', function(data, cb) TriggerServerEvent('aether_admin:getPlayerInventory', data.id) cb({}) end)

-- Get logs callback
RegisterNUICallback('getLogs', function(data, cb) TriggerServerEvent('aether_admin:getLogs', data.logType, data.limit) cb({}) end)

-- Report callbacks
RegisterNUICallback('getReports', function(_, cb) TriggerServerEvent('aether_admin:getReports') cb({}) end)
RegisterNUICallback('claimReport', function(data, cb) TriggerServerEvent('aether_admin:claimReport', data.id) cb({}) end)
RegisterNUICallback('closeReport', function(data, cb) TriggerServerEvent('aether_admin:closeReport', data.id) cb({}) end)
RegisterNUICallback('gotoReport', function(data, cb) TriggerServerEvent('aether_admin:gotoReport', data.id) cb({}) end)

-- View player inventory (shows in corner panel, doesn't close admin menu)
RegisterNUICallback('openPlayerInventory', function(data, cb)
    -- Don't close the panel - just request inventory data
    TriggerServerEvent('aether_admin:getPlayerInventory', data.id)
    cb({})
end)

-- Legacy: Open ox_inventory directly (not used anymore)
RegisterNetEvent('aether_admin:openTargetInventory', function(targetId)
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:openInventory('player', targetId)
    end
end)

-- Self actions
RegisterNUICallback('heal', function(_, cb) SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId())) cb({}) end)
RegisterNUICallback('armor', function(_, cb) SetPedArmour(PlayerPedId(), 100) cb({}) end)

-- Godmode with proper implementation
local godModeActive = false
RegisterNUICallback('godMode', function(data, cb) 
    godModeActive = data.enabled
    local ped = PlayerPedId()
    
    if godModeActive then
        SetEntityInvincible(ped, true)
        SetPlayerInvincible(PlayerId(), true)
        -- Notify anticheat to ignore godmode detection
        TriggerServerEvent('anticheat:adminActionProtection', GetPlayerServerId(PlayerId()), 'godmode', 999999)
    else
        SetEntityInvincible(ped, false)
        SetPlayerInvincible(PlayerId(), false)
    end
    
    cb({}) 
end)

-- Godmode thread to maintain invincibility
CreateThread(function()
    while true do
        Wait(0)
        if godModeActive then
            local ped = PlayerPedId()
            SetEntityInvincible(ped, true)
            SetPlayerInvincible(PlayerId(), true)
            
            -- Prevent all damage
            SetEntityProofs(ped, true, true, true, true, true, true, true, true)
            
            -- Keep health and armor full
            if GetEntityHealth(ped) < 200 then
                SetEntityHealth(ped, 200)
            end
            if GetPedArmour(ped) < 100 then
                SetPedArmour(ped, 100)
            end
        end
    end
end)

RegisterNUICallback('invisible', function(data, cb) SetEntityVisible(PlayerPedId(), not data.enabled, false) cb({}) end)
RegisterNUICallback('noclip', function(data, cb) ToggleNoclip(data.enabled) cb({}) end)

-- Vehicle callbacks
RegisterNUICallback('spawnVehicle', function(data, cb)
    local model = GetHashKey(data.vehicle)
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 50 do Wait(100) timeout = timeout + 1 end
    if HasModelLoaded(model) then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
        SetPedIntoVehicle(ped, vehicle, -1)
        SetModelAsNoLongerNeeded(model)
    end
    cb({})
end)
RegisterNUICallback('deleteVehicle', function(_, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then DeleteEntity(vehicle) end
    cb({})
end)
RegisterNUICallback('repairVehicle', function(_, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then SetVehicleFixed(vehicle) SetVehicleEngineHealth(vehicle, 1000.0) end
    cb({})
end)

-- Noclip system
function ToggleNoclip(enabled)
    noclipEnabled = enabled
    local ped = PlayerPedId()
    if enabled then
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        CreateThread(function()
            while noclipEnabled do
                local camRot = GetGameplayCamRot(2)
                local speed = 1.0
                if IsControlPressed(0, 21) then speed = 3.0 end
                if IsControlPressed(0, 36) then speed = 0.3 end
                local fwd = GetEntityForwardVector(ped)
                local newPos = GetEntityCoords(ped)
                if IsControlPressed(0, 32) then newPos = newPos + fwd * speed end
                if IsControlPressed(0, 33) then newPos = newPos - fwd * speed end
                if IsControlPressed(0, 34) then newPos = newPos - vector3(-fwd.y, fwd.x, 0) * speed end
                if IsControlPressed(0, 35) then newPos = newPos + vector3(-fwd.y, fwd.x, 0) * speed end
                if IsControlPressed(0, 44) then newPos = newPos - vector3(0, 0, speed) end
                if IsControlPressed(0, 38) then newPos = newPos + vector3(0, 0, speed) end
                SetEntityCoordsNoOffset(ped, newPos.x, newPos.y, newPos.z, false, false, false)
                SetEntityHeading(ped, camRot.z)
                Wait(0)
            end
        end)
    else
        FreezeEntityPosition(ped, false)
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
    end
end

-- Event handlers
local isFrozen = false
RegisterNetEvent('aether_admin:freeze', function() isFrozen = not isFrozen FreezeEntityPosition(PlayerPedId(), isFrozen) end)
RegisterNetEvent('aether_admin:teleportTo', function(coords) SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z, false, false, false, false) end)
RegisterNetEvent('aether_admin:revive', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 100)
    if IsEntityDead(ped) then NetworkResurrectLocalPlayer(GetEntityCoords(ped), GetEntityHeading(ped), true, false) end
end)
RegisterNetEvent('aether_admin:syncWeather', function(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypePersist(weather)
    SetOverrideWeather(weather)
end)
RegisterNetEvent('aether_admin:syncTime', function(hour, minute) NetworkOverrideClockTime(hour, minute, 0) end)

-- Spectate system
RegisterNetEvent('aether_admin:startSpectate', function(targetId, coords)
    spectating = true
    spectateTarget = targetId
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z + 50.0, false, false, false, false)
    SetEntityVisible(ped, false, false)
    SetEntityCollision(ped, false, false)
    FreezeEntityPosition(ped, true)
    
    CreateThread(function()
        while spectating do
            local targetPed = GetPlayerPed(GetPlayerFromServerId(spectateTarget))
            if targetPed and DoesEntityExist(targetPed) then
                local targetCoords = GetEntityCoords(targetPed)
                SetEntityCoords(ped, targetCoords.x, targetCoords.y, targetCoords.z + 5.0, false, false, false, false)
            end
            Wait(100)
        end
    end)
end)

RegisterCommand('stopspectate', function()
    if spectating then
        spectating = false
        spectateTarget = nil
        local ped = PlayerPedId()
        SetEntityVisible(ped, true, false)
        SetEntityCollision(ped, true, true)
        FreezeEntityPosition(ped, false)
        Framework.Notify('Stopped spectating', 'info')
    end
end, false)

-- ESC to close
CreateThread(function()
    while true do
        Wait(0)
        if isOpen and IsControlJustPressed(0, 200) then CloseAdminPanel() end
    end
end)

-- Kill logging (detect when player kills someone)
local lastKillCheck = 0
CreateThread(function()
    while true do
        Wait(500)
        local ped = PlayerPedId()
        if IsPedShooting(ped) then
            local _, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if entity and IsEntityAPed(entity) and IsPedAPlayer(entity) then
                local targetPlayer = NetworkGetPlayerIndexFromPed(entity)
                if targetPlayer and GetEntityHealth(entity) <= 0 then
                    local weapon = GetSelectedPedWeapon(ped)
                    local weaponName = GetWeaponName(weapon)
                    local headshot = GetPedLastDamageBone(entity) == 31086
                    TriggerServerEvent('aether_admin:logKill', GetPlayerServerId(targetPlayer), weaponName, headshot)
                end
            end
        end
    end
end)

-- Get weapon name helper - ALL GTA WEAPONS
local WeaponNames = {}
CreateThread(function()
    WeaponNames = {
        -- Melee
        [GetHashKey('WEAPON_DAGGER')] = 'Antique Cavalry Dagger',
        [GetHashKey('WEAPON_BAT')] = 'Baseball Bat',
        [GetHashKey('WEAPON_BOTTLE')] = 'Broken Bottle',
        [GetHashKey('WEAPON_CROWBAR')] = 'Crowbar',
        [GetHashKey('WEAPON_UNARMED')] = 'Fist',
        [GetHashKey('WEAPON_FLASHLIGHT')] = 'Flashlight',
        [GetHashKey('WEAPON_GOLFCLUB')] = 'Golf Club',
        [GetHashKey('WEAPON_HAMMER')] = 'Hammer',
        [GetHashKey('WEAPON_HATCHET')] = 'Hatchet',
        [GetHashKey('WEAPON_KNUCKLE')] = 'Brass Knuckles',
        [GetHashKey('WEAPON_KNIFE')] = 'Knife',
        [GetHashKey('WEAPON_MACHETE')] = 'Machete',
        [GetHashKey('WEAPON_SWITCHBLADE')] = 'Switchblade',
        [GetHashKey('WEAPON_NIGHTSTICK')] = 'Nightstick',
        [GetHashKey('WEAPON_WRENCH')] = 'Pipe Wrench',
        [GetHashKey('WEAPON_BATTLEAXE')] = 'Battle Axe',
        [GetHashKey('WEAPON_POOLCUE')] = 'Pool Cue',
        [GetHashKey('WEAPON_STONE_HATCHET')] = 'Stone Hatchet',
        -- Handguns
        [GetHashKey('WEAPON_PISTOL')] = 'Pistol',
        [GetHashKey('WEAPON_PISTOL_MK2')] = 'Pistol Mk II',
        [GetHashKey('WEAPON_COMBATPISTOL')] = 'Combat Pistol',
        [GetHashKey('WEAPON_APPISTOL')] = 'AP Pistol',
        [GetHashKey('WEAPON_STUNGUN')] = 'Stun Gun',
        [GetHashKey('WEAPON_PISTOL50')] = 'Pistol .50',
        [GetHashKey('WEAPON_SNSPISTOL')] = 'SNS Pistol',
        [GetHashKey('WEAPON_SNSPISTOL_MK2')] = 'SNS Pistol Mk II',
        [GetHashKey('WEAPON_HEAVYPISTOL')] = 'Heavy Pistol',
        [GetHashKey('WEAPON_VINTAGEPISTOL')] = 'Vintage Pistol',
        [GetHashKey('WEAPON_FLAREGUN')] = 'Flare Gun',
        [GetHashKey('WEAPON_MARKSMANPISTOL')] = 'Marksman Pistol',
        [GetHashKey('WEAPON_REVOLVER')] = 'Heavy Revolver',
        [GetHashKey('WEAPON_REVOLVER_MK2')] = 'Heavy Revolver Mk II',
        [GetHashKey('WEAPON_DOUBLEACTION')] = 'Double Action Revolver',
        [GetHashKey('WEAPON_RAYPISTOL')] = 'Up-n-Atomizer',
        [GetHashKey('WEAPON_CERAMICPISTOL')] = 'Ceramic Pistol',
        [GetHashKey('WEAPON_NAVYREVOLVER')] = 'Navy Revolver',
        [GetHashKey('WEAPON_GADGETPISTOL')] = 'Perico Pistol',
        -- SMGs
        [GetHashKey('WEAPON_MICROSMG')] = 'Micro SMG',
        [GetHashKey('WEAPON_SMG')] = 'SMG',
        [GetHashKey('WEAPON_SMG_MK2')] = 'SMG Mk II',
        [GetHashKey('WEAPON_ASSAULTSMG')] = 'Assault SMG',
        [GetHashKey('WEAPON_COMBATPDW')] = 'Combat PDW',
        [GetHashKey('WEAPON_MACHINEPISTOL')] = 'Machine Pistol',
        [GetHashKey('WEAPON_MINISMG')] = 'Mini SMG',
        [GetHashKey('WEAPON_RAYCARBINE')] = 'Unholy Hellbringer',
        -- Shotguns
        [GetHashKey('WEAPON_PUMPSHOTGUN')] = 'Pump Shotgun',
        [GetHashKey('WEAPON_PUMPSHOTGUN_MK2')] = 'Pump Shotgun Mk II',
        [GetHashKey('WEAPON_SAWNOFFSHOTGUN')] = 'Sawed-Off Shotgun',
        [GetHashKey('WEAPON_ASSAULTSHOTGUN')] = 'Assault Shotgun',
        [GetHashKey('WEAPON_BULLPUPSHOTGUN')] = 'Bullpup Shotgun',
        [GetHashKey('WEAPON_MUSKET')] = 'Musket',
        [GetHashKey('WEAPON_HEAVYSHOTGUN')] = 'Heavy Shotgun',
        [GetHashKey('WEAPON_DBSHOTGUN')] = 'Double Barrel Shotgun',
        [GetHashKey('WEAPON_AUTOSHOTGUN')] = 'Sweeper Shotgun',
        [GetHashKey('WEAPON_COMBATSHOTGUN')] = 'Combat Shotgun',
        -- Assault Rifles
        [GetHashKey('WEAPON_ASSAULTRIFLE')] = 'Assault Rifle',
        [GetHashKey('WEAPON_ASSAULTRIFLE_MK2')] = 'Assault Rifle Mk II',
        [GetHashKey('WEAPON_CARBINERIFLE')] = 'Carbine Rifle',
        [GetHashKey('WEAPON_CARBINERIFLE_MK2')] = 'Carbine Rifle Mk II',
        [GetHashKey('WEAPON_ADVANCEDRIFLE')] = 'Advanced Rifle',
        [GetHashKey('WEAPON_SPECIALCARBINE')] = 'Special Carbine',
        [GetHashKey('WEAPON_SPECIALCARBINE_MK2')] = 'Special Carbine Mk II',
        [GetHashKey('WEAPON_BULLPUPRIFLE')] = 'Bullpup Rifle',
        [GetHashKey('WEAPON_BULLPUPRIFLE_MK2')] = 'Bullpup Rifle Mk II',
        [GetHashKey('WEAPON_COMPACTRIFLE')] = 'Compact Rifle',
        [GetHashKey('WEAPON_MILITARYRIFLE')] = 'Military Rifle',
        [GetHashKey('WEAPON_HEAVYRIFLE')] = 'Heavy Rifle',
        [GetHashKey('WEAPON_TACTICALRIFLE')] = 'Service Carbine',
        -- Machine Guns
        [GetHashKey('WEAPON_MG')] = 'MG',
        [GetHashKey('WEAPON_COMBATMG')] = 'Combat MG',
        [GetHashKey('WEAPON_COMBATMG_MK2')] = 'Combat MG Mk II',
        [GetHashKey('WEAPON_GUSENBERG')] = 'Gusenberg Sweeper',
        -- Sniper Rifles
        [GetHashKey('WEAPON_SNIPERRIFLE')] = 'Sniper Rifle',
        [GetHashKey('WEAPON_HEAVYSNIPER')] = 'Heavy Sniper',
        [GetHashKey('WEAPON_HEAVYSNIPER_MK2')] = 'Heavy Sniper Mk II',
        [GetHashKey('WEAPON_MARKSMANRIFLE')] = 'Marksman Rifle',
        [GetHashKey('WEAPON_MARKSMANRIFLE_MK2')] = 'Marksman Rifle Mk II',
        [GetHashKey('WEAPON_PRECISIONRIFLE')] = 'Precision Rifle',
        -- Heavy Weapons
        [GetHashKey('WEAPON_RPG')] = 'RPG',
        [GetHashKey('WEAPON_GRENADELAUNCHER')] = 'Grenade Launcher',
        [GetHashKey('WEAPON_GRENADELAUNCHER_SMOKE')] = 'Smoke Grenade Launcher',
        [GetHashKey('WEAPON_MINIGUN')] = 'Minigun',
        [GetHashKey('WEAPON_FIREWORK')] = 'Firework Launcher',
        [GetHashKey('WEAPON_RAILGUN')] = 'Railgun',
        [GetHashKey('WEAPON_HOMINGLAUNCHER')] = 'Homing Launcher',
        [GetHashKey('WEAPON_COMPACTLAUNCHER')] = 'Compact Grenade Launcher',
        [GetHashKey('WEAPON_RAYMINIGUN')] = 'Widowmaker',
        [GetHashKey('WEAPON_EMPLAUNCHER')] = 'EMP Launcher',
        -- Throwables
        [GetHashKey('WEAPON_GRENADE')] = 'Grenade',
        [GetHashKey('WEAPON_BZGAS')] = 'BZ Gas',
        [GetHashKey('WEAPON_MOLOTOV')] = 'Molotov Cocktail',
        [GetHashKey('WEAPON_STICKYBOMB')] = 'Sticky Bomb',
        [GetHashKey('WEAPON_PROXMINE')] = 'Proximity Mine',
        [GetHashKey('WEAPON_SNOWBALL')] = 'Snowball',
        [GetHashKey('WEAPON_PIPEBOMB')] = 'Pipe Bomb',
        [GetHashKey('WEAPON_BALL')] = 'Ball',
        [GetHashKey('WEAPON_SMOKEGRENADE')] = 'Tear Gas',
        [GetHashKey('WEAPON_FLARE')] = 'Flare',
        [GetHashKey('WEAPON_ACIDPACKAGE')] = 'Acid Package',
        -- Miscellaneous
        [GetHashKey('WEAPON_PETROLCAN')] = 'Jerry Can',
        [GetHashKey('WEAPON_PARACHUTE')] = 'Parachute',
        [GetHashKey('WEAPON_FIREEXTINGUISHER')] = 'Fire Extinguisher',
        [GetHashKey('WEAPON_HAZARDCAN')] = 'Hazardous Jerry Can',
        [GetHashKey('WEAPON_FERTILIZERCAN')] = 'Fertilizer Can',
        -- Vehicle Weapons
        [GetHashKey('VEHICLE_WEAPON_ROTORS')] = 'Vehicle Rotors',
        [GetHashKey('VEHICLE_WEAPON_TANK')] = 'Tank Cannon',
        [GetHashKey('VEHICLE_WEAPON_PLAYER_LASER')] = 'Vehicle Laser',
        [GetHashKey('VEHICLE_WEAPON_PLAYER_BULLET')] = 'Vehicle Gun',
        [GetHashKey('VEHICLE_WEAPON_PLAYER_BUZZARD')] = 'Buzzard Gun',
        [GetHashKey('VEHICLE_WEAPON_PLAYER_HUNTER')] = 'Hunter Gun',
        [GetHashKey('VEHICLE_WEAPON_PLANE_ROCKET')] = 'Plane Rocket',
        [GetHashKey('VEHICLE_WEAPON_SPACE_ROCKET')] = 'Space Rocket',
        [GetHashKey('VEHICLE_WEAPON_APC_CANNON')] = 'APC Cannon',
        [GetHashKey('VEHICLE_WEAPON_APC_MISSILE')] = 'APC Missile',
        [GetHashKey('VEHICLE_WEAPON_TURRET_INSURGENT')] = 'Insurgent Turret',
        [GetHashKey('VEHICLE_WEAPON_TURRET_TECHNICAL')] = 'Technical Turret',
        -- Other
        [GetHashKey('WEAPON_DROWNING')] = 'Drowned',
        [GetHashKey('WEAPON_DROWNING_IN_VEHICLE')] = 'Drowned in Vehicle',
        [GetHashKey('WEAPON_BLEEDING')] = 'Bleeding',
        [GetHashKey('WEAPON_ELECTRIC_FENCE')] = 'Electric Fence',
        [GetHashKey('WEAPON_EXPLOSION')] = 'Explosion',
        [GetHashKey('WEAPON_FALL')] = 'Fall',
        [GetHashKey('WEAPON_EXHAUSTION')] = 'Exhaustion',
        [GetHashKey('WEAPON_HIT_BY_WATER_CANNON')] = 'Water Cannon',
        [GetHashKey('WEAPON_RAMMED_BY_CAR')] = 'Vehicle Ramming',
        [GetHashKey('WEAPON_RUN_OVER_BY_CAR')] = 'Run Over',
        [GetHashKey('WEAPON_FIRE')] = 'Fire',
    }
end)

function GetWeaponName(hash)
    return WeaponNames[hash] or 'Unknown Weapon'
end

-- Enhanced ESP System with better visuals
CreateThread(function()
    while true do
        if espEnabled and hasPermission then
            local myPed = PlayerPedId()
            local myCoords = GetEntityCoords(myPed)
            
            for _, player in ipairs(GetActivePlayers()) do
                if player ~= PlayerId() then
                    local targetPed = GetPlayerPed(player)
                    local targetCoords = GetEntityCoords(targetPed)
                    local distance = #(myCoords - targetCoords)
                    
                    if distance < 300.0 then
                        local serverId = GetPlayerServerId(player)
                        local playerName = GetPlayerName(player)
                        local health = GetEntityHealth(targetPed)
                        local maxHealth = GetEntityMaxHealth(targetPed)
                        local armor = GetPedArmour(targetPed)
                        local weapon = GetSelectedPedWeapon(targetPed)
                        local weaponName = GetWeaponName(weapon)
                        local inVehicle = IsPedInAnyVehicle(targetPed, false)
                        
                        -- Get head position
                        local headPos = GetPedBoneCoords(targetPed, 31086, 0.0, 0.0, 0.0)
                        headPos = vector3(headPos.x, headPos.y, headPos.z + 0.5)
                        
                        local onScreen, screenX, screenY = World3dToScreen2d(headPos.x, headPos.y, headPos.z)
                        
                        if onScreen then
                            local scale = math.max(0.25, 0.4 * (1 - distance / 300))
                            
                            -- Health percentage
                            local healthPercent = math.max(0, (health - 100) / (maxHealth - 100))
                            local healthColor = {
                                r = math.floor(255 * (1 - healthPercent)),
                                g = math.floor(255 * healthPercent),
                                b = 50
                            }
                            
                            -- Draw name and ID (yellow/gold)
                            SetTextScale(0.0, scale)
                            SetTextFont(4)
                            SetTextColour(255, 200, 100, 255)
                            SetTextOutline()
                            SetTextCentre(true)
                            SetTextEntry('STRING')
                            AddTextComponentString(string.format('[%d] %s', serverId, playerName))
                            DrawText(screenX, screenY)
                            
                            -- Draw distance (white)
                            SetTextScale(0.0, scale * 0.8)
                            SetTextFont(4)
                            SetTextColour(200, 200, 200, 255)
                            SetTextOutline()
                            SetTextCentre(true)
                            SetTextEntry('STRING')
                            AddTextComponentString(string.format('%.0fm', distance))
                            DrawText(screenX, screenY + 0.018)
                            
                            -- Draw health bar background
                            local barWidth = 0.04
                            local barHeight = 0.006
                            local barY = screenY + 0.035
                            DrawRect(screenX, barY, barWidth, barHeight, 40, 40, 40, 200)
                            
                            -- Draw health bar
                            local healthWidth = barWidth * healthPercent
                            DrawRect(screenX - (barWidth - healthWidth) / 2, barY, healthWidth, barHeight, healthColor.r, healthColor.g, healthColor.b, 255)
                            
                            -- Draw armor bar if has armor
                            if armor > 0 then
                                local armorY = barY + 0.008
                                DrawRect(screenX, armorY, barWidth, barHeight * 0.6, 40, 40, 40, 200)
                                local armorWidth = barWidth * (armor / 100)
                                DrawRect(screenX - (barWidth - armorWidth) / 2, armorY, armorWidth, barHeight * 0.6, 100, 150, 255, 255)
                            end
                            
                            -- Draw weapon/status (colored based on threat)
                            local statusY = screenY + 0.055
                            local statusColor = {r = 150, g = 150, b = 150}
                            local statusText = weaponName
                            
                            if weapon ~= GetHashKey('WEAPON_UNARMED') then
                                statusColor = {r = 255, g = 100, b = 100}
                            end
                            
                            if inVehicle then
                                statusText = statusText .. ' [Vehicle]'
                                statusColor = {r = 100, g = 200, b = 255}
                            end
                            
                            SetTextScale(0.0, scale * 0.7)
                            SetTextFont(4)
                            SetTextColour(statusColor.r, statusColor.g, statusColor.b, 255)
                            SetTextOutline()
                            SetTextCentre(true)
                            SetTextEntry('STRING')
                            AddTextComponentString(statusText)
                            DrawText(screenX, statusY)
                            
                            -- Draw 3D line to player (optional, for close range)
                            if distance < 50.0 then
                                local feetPos = GetEntityCoords(targetPed)
                                DrawLine(myCoords.x, myCoords.y, myCoords.z, feetPos.x, feetPos.y, feetPos.z, 255, 200, 100, 100)
                            end
                        end
                    end
                end
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)









-- ============================================
-- PLAYER INFO UI - Minimal & Beautiful
-- ============================================
local playerInfoUIActive = false
local currentPlayerInfo = nil
local screenshotViewerActive = false
local currentScreenshotIndex = 1

RegisterNetEvent('admin:showPlayerInfo', function(playerInfo)
    print('[DEBUG] Received admin:showPlayerInfo event')
    print('[DEBUG] Player Info:', json.encode(playerInfo))
    
    if playerInfoUIActive then 
        print('[DEBUG] UI already active, ignoring')
        return 
    end
    
    currentPlayerInfo = playerInfo
    playerInfoUIActive = true
    screenshotViewerActive = false
    currentScreenshotIndex = 1
    
    -- Disable controls while UI is open
    CreateThread(function()
        while playerInfoUIActive do
            Wait(0)
            
            -- Disable all controls except specific ones
            DisableAllControlActions(0)
            EnableControlAction(0, 322, true) -- ESC
            EnableControlAction(0, 18, true)  -- Enter
            EnableControlAction(0, 191, true) -- Enter (alternative)
            EnableControlAction(0, 26, true)  -- C key
            EnableControlAction(0, 174, true) -- Left Arrow
            EnableControlAction(0, 175, true) -- Right Arrow
            
            -- Check for Enter or ESC key to close
            if IsControlJustPressed(0, 18) or IsControlJustPressed(0, 191) or IsControlJustPressed(0, 322) then
                playerInfoUIActive = false
                screenshotViewerActive = false
                currentPlayerInfo = nil
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
            
            -- Check for C key to toggle screenshot viewer
            if IsControlJustPressed(0, 26) and currentPlayerInfo.screenshots and #currentPlayerInfo.screenshots > 0 then
                screenshotViewerActive = not screenshotViewerActive
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            end
            
            -- Navigate screenshots with arrow keys
            if screenshotViewerActive and currentPlayerInfo.screenshots then
                if IsControlJustPressed(0, 174) then -- Left
                    currentScreenshotIndex = currentScreenshotIndex - 1
                    if currentScreenshotIndex < 1 then
                        currentScreenshotIndex = #currentPlayerInfo.screenshots
                    end
                    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                elseif IsControlJustPressed(0, 175) then -- Right
                    currentScreenshotIndex = currentScreenshotIndex + 1
                    if currentScreenshotIndex > #currentPlayerInfo.screenshots then
                        currentScreenshotIndex = 1
                    end
                    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                end
            end
        end
    end)
    
    -- Draw the UI
    CreateThread(function()
        local startTime = GetGameTimer()
        local fadeInDuration = 300
        
        print('[DEBUG] Starting UI draw thread')
        
        while playerInfoUIActive and currentPlayerInfo do
            Wait(0)
            
            -- Wrap in pcall to catch errors
            local success, err = pcall(function()
                -- Calculate fade in alpha
                local elapsed = GetGameTimer() - startTime
                local fadeAlpha = math.min(255, (elapsed / fadeInDuration) * 255)
                
                -- Background overlay
                DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, math.floor(180 * (fadeAlpha / 255)))
            
            -- Main panel background
            local panelX = 0.5
            local panelY = 0.5
            local panelW = 0.40
            local panelH = 0.60
            
            DrawRect(panelX, panelY, panelW, panelH, 15, 15, 20, math.floor(fadeAlpha))
            
            -- Top accent line (purple/blue)
            DrawRect(panelX, panelY - (panelH / 2) + 0.002, panelW, 0.004, 100, 100, 255, math.floor(fadeAlpha))
            
            -- Title
            SetTextFont(4)
            SetTextProportional(1)
            SetTextScale(0.0, 0.55)
            SetTextColour(100, 100, 255, math.floor(fadeAlpha))
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("PLAYER INFORMATION")
            DrawText(panelX, panelY - (panelH / 2) + 0.025)
            
            -- Player Name
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.40)
            SetTextColour(255, 255, 255, math.floor(fadeAlpha))
            SetTextCentre(true)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString(currentPlayerInfo.name .. " [ID: " .. currentPlayerInfo.id .. "]")
            DrawText(panelX, panelY - (panelH / 2) + 0.065)
            
            -- Separator line
            DrawRect(panelX, panelY - (panelH / 2) + 0.095, panelW - 0.04, 0.001, 100, 100, 100, math.floor(fadeAlpha))
            
            -- Info sections
            local startY = panelY - (panelH / 2) + 0.11
            local lineHeight = 0.035
            
            -- Helper function to draw info line
            local function DrawInfoLine(label, value, yPos, valueColor)
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.28)
                SetTextColour(150, 150, 150, math.floor(fadeAlpha))
                SetTextCentre(false)
                SetTextDropshadow(0, 0, 0, 0, 0)
                SetTextEdge(0, 0, 0, 0, 0)
                SetTextEntry("STRING")
                AddTextComponentString(label)
                DrawText(panelX - (panelW / 2) + 0.03, yPos)
                
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.28)
                SetTextColour(valueColor.r or 255, valueColor.g or 255, valueColor.b or 255, math.floor(fadeAlpha))
                SetTextCentre(false)
                SetTextDropshadow(0, 0, 0, 0, 0)
                SetTextEdge(0, 0, 0, 0, 0)
                SetTextEntry("STRING")
                AddTextComponentString(tostring(value))
                DrawText(panelX - 0.02, yPos)
            end
            
            -- Identifiers Section
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.32)
            SetTextColour(100, 100, 255, math.floor(fadeAlpha))
            SetTextCentre(false)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("IDENTIFIERS")
            DrawText(panelX - (panelW / 2) + 0.03, startY)
            
            startY = startY + 0.032
            DrawInfoLine("License:", string.sub(currentPlayerInfo.license, 1, 25) .. "...", startY, {r=200, g=200, b=200})
            
            startY = startY + lineHeight
            DrawInfoLine("Discord:", currentPlayerInfo.discord ~= "Unknown" and string.sub(currentPlayerInfo.discord, 1, 20) .. "..." or "Not Linked", startY, {r=200, g=200, b=200})
            
            startY = startY + lineHeight
            DrawInfoLine("Steam:", currentPlayerInfo.steam ~= "Unknown" and string.sub(currentPlayerInfo.steam, 1, 20) .. "..." or "Not Linked", startY, {r=200, g=200, b=200})
            
            startY = startY + lineHeight
            DrawInfoLine("IP Address:", currentPlayerInfo.ip, startY, {r=200, g=200, b=200})
            
            -- Statistics Section
            startY = startY + lineHeight + 0.015
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.32)
            SetTextColour(100, 100, 255, math.floor(fadeAlpha))
            SetTextCentre(false)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("STATISTICS")
            DrawText(panelX - (panelW / 2) + 0.03, startY)
            
            startY = startY + 0.032
            DrawInfoLine("Playtime:", currentPlayerInfo.playtime, startY, {r=100, g=255, b=100})
            
            startY = startY + lineHeight
            DrawInfoLine("First Join:", currentPlayerInfo.firstJoin, startY, {r=200, g=200, b=200})
            
            startY = startY + lineHeight
            DrawInfoLine("Last Seen:", currentPlayerInfo.lastSeen, startY, {r=100, g=255, b=100})
            
            -- Punishments Section
            startY = startY + lineHeight + 0.015
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.32)
            SetTextColour(255, 100, 100, math.floor(fadeAlpha))
            SetTextCentre(false)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("PUNISHMENTS")
            DrawText(panelX - (panelW / 2) + 0.03, startY)
            
            startY = startY + 0.032
            local banColor = currentPlayerInfo.bans > 0 and {r=255, g=50, b=50} or {r=100, g=255, b=100}
            DrawInfoLine("Total Bans:", currentPlayerInfo.bans, startY, banColor)
            
            startY = startY + lineHeight
            local kickColor = currentPlayerInfo.kicks > 0 and {r=255, g=150, b=50} or {r=100, g=255, b=100}
            DrawInfoLine("Total Kicks:", currentPlayerInfo.kicks, startY, kickColor)
            
            startY = startY + lineHeight
            local warnColor = currentPlayerInfo.warns > 0 and {r=255, g=200, b=50} or {r=100, g=255, b=100}
            DrawInfoLine("Total Warns:", currentPlayerInfo.warns, startY, warnColor)
            
            -- Bottom instructions
            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.0, 0.28)
            SetTextColour(100, 100, 100, math.floor(fadeAlpha))
            SetTextCentre(true)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            local hasScreenshots = currentPlayerInfo.screenshots and #currentPlayerInfo.screenshots > 0
            if hasScreenshots then
                AddTextComponentString("Press ~b~C~s~ for Screenshots | ~b~ENTER~s~/~b~ESC~s~ to close")
            else
                AddTextComponentString("Press ~b~ENTER~s~ or ~b~ESC~s~ to close")
            end
            DrawText(panelX, panelY + (panelH / 2) - 0.025)
            
            -- Screenshot Viewer Overlay
            if screenshotViewerActive and currentPlayerInfo.screenshots and #currentPlayerInfo.screenshots > 0 then
                local ss = currentPlayerInfo.screenshots[currentScreenshotIndex]
                
                -- Dark overlay
                DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 230)
                
                -- Screenshot panel
                local ssX = 0.5
                local ssY = 0.5
                local ssW = 0.6
                local ssH = 0.7
                
                DrawRect(ssX, ssY, ssW, ssH, 20, 20, 25, 255)
                
                -- Title
                SetTextFont(4)
                SetTextProportional(1)
                SetTextScale(0.0, 0.45)
                SetTextColour(100, 100, 255, 255)
                SetTextCentre(true)
                SetTextDropshadow(0, 0, 0, 0, 0)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextEntry("STRING")
                AddTextComponentString("SCREENSHOT VIEWER")
                DrawText(ssX, ssY - (ssH / 2) + 0.02)
                
                -- Screenshot info
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.30)
                SetTextColour(200, 200, 200, 255)
                SetTextCentre(true)
                SetTextDropshadow(0, 0, 0, 0, 0)
                SetTextEdge(0, 0, 0, 0, 0)
                SetTextEntry("STRING")
                AddTextComponentString(currentScreenshotIndex .. " / " .. #currentPlayerInfo.screenshots .. " - " .. ss.reason)
                DrawText(ssX, ssY - (ssH / 2) + 0.055)
                
                -- Screenshot placeholder (you'd load the actual image here)
                DrawRect(ssX, ssY + 0.02, ssW - 0.04, ssH - 0.18, 30, 30, 35, 255)
                
                -- Image URL text
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.25)
                SetTextColour(150, 150, 150, 255)
                SetTextCentre(true)
                SetTextDropshadow(0, 0, 0, 0, 0)
                SetTextEdge(0, 0, 0, 0, 0)
                SetTextEntry("STRING")
                AddTextComponentString("URL: " .. (ss.url or "No URL"))
                DrawText(ssX, ssY + (ssH / 2) - 0.08)
                
                -- Date
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.25)
                SetTextColour(150, 150, 150, 255)
                SetTextCentre(true)
                SetTextDropshadow(0, 0, 0, 0, 0)
                SetTextEdge(0, 0, 0, 0, 0)
                SetTextEntry("STRING")
                AddTextComponentString("Date: " .. (ss.date or "Unknown"))
                DrawText(ssX, ssY + (ssH / 2) - 0.055)
                
                -- Navigation instructions
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.28)
                SetTextColour(100, 100, 255, 255)
                SetTextCentre(true)
                SetTextDropshadow(0, 0, 0, 0, 0)
                SetTextEdge(0, 0, 0, 0, 0)
                SetTextEntry("STRING")
                AddTextComponentString("~b~← →~s~ Navigate | ~b~C~s~ Close Viewer | ~b~ESC~s~ Exit")
                DrawText(ssX, ssY + (ssH / 2) - 0.025)
            end
            end) -- End of pcall
            
            if not success then
                print('[ERROR] Player Info UI draw error: ' .. tostring(err))
                playerInfoUIActive = false
                currentPlayerInfo = nil
            end
        end
        print('[DEBUG] UI draw thread ended')
    end)
end)
