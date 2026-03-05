-- ============================================
-- MULTI-FRAMEWORK SUPPORT
-- Supports: QBCore, QBX, ESX, Standalone
-- ============================================

Framework = {}
Framework.Type = nil
Framework.Object = nil

-- Auto-detect framework
function Framework.Detect()
    if Config.Framework ~= 'auto' then
        Framework.Type = Config.Framework
        print('[wasteland_admin] Framework set to: ' .. Config.Framework)
    else
        -- Try QBX first (newer)
        if GetResourceState('qbx_core') == 'started' then
            Framework.Type = 'qbx'
            print('[wasteland_admin] Detected QBX Framework')
        -- Try QBCore
        elseif GetResourceState('qb-core') == 'started' then
            Framework.Type = 'qb'
            print('[wasteland_admin] Detected QBCore Framework')
        -- Try ESX
        elseif GetResourceState('es_extended') == 'started' then
            Framework.Type = 'esx'
            print('[wasteland_admin] Detected ESX Framework')
        else
            Framework.Type = 'standalone'
            print('[wasteland_admin] No framework detected - Running standalone')
        end
    end
    
    -- Load framework object
    if Framework.Type == 'qb' then
        Framework.Object = exports['qb-core']:GetCoreObject()
    elseif Framework.Type == 'qbx' then
        Framework.Object = exports.qbx_core
    elseif Framework.Type == 'esx' then
        Framework.Object = exports['es_extended']:getSharedObject()
    end
    
    return Framework.Type
end

-- Get player from source (server-side)
function Framework.GetPlayer(src)
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        return Framework.Object.Functions.GetPlayer(src)
    elseif Framework.Type == 'esx' then
        return Framework.Object.GetPlayerFromId(src)
    end
    return nil
end

-- Get player identifier (server-side)
function Framework.GetIdentifier(src)
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        return Player and Player.PlayerData.citizenid or nil
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        return Player and Player.identifier or nil
    end
    return nil
end

-- Get player job (server-side)
function Framework.GetJob(src)
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        return Player and Player.PlayerData.job or nil
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        return Player and Player.job or nil
    end
    return nil
end

-- Get player money (server-side)
function Framework.GetMoney(src, moneyType)
    moneyType = moneyType or 'cash'
    
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        if not Player then return 0 end
        return Player.PlayerData.money[moneyType] or 0
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        if not Player then return 0 end
        local account = moneyType == 'cash' and 'money' or moneyType
        return Player.getAccount(account).money or 0
    end
    return 0
end

-- Add money (server-side)
function Framework.AddMoney(src, moneyType, amount)
    moneyType = moneyType or 'cash'
    
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        if Player then
            Player.Functions.AddMoney(moneyType, amount)
            return true
        end
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        if Player then
            local account = moneyType == 'cash' and 'money' or moneyType
            Player.addAccountMoney(account, amount)
            return true
        end
    end
    return false
end

-- Remove money (server-side)
function Framework.RemoveMoney(src, moneyType, amount)
    moneyType = moneyType or 'cash'
    
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        if Player then
            Player.Functions.RemoveMoney(moneyType, amount)
            return true
        end
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        if Player then
            local account = moneyType == 'cash' and 'money' or moneyType
            Player.removeAccountMoney(account, amount)
            return true
        end
    end
    return false
end

-- Get player inventory (server-side)
function Framework.GetInventory(src)
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        return Player and Player.PlayerData.items or {}
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        return Player and Player.getInventory() or {}
    end
    return {}
end

-- Get all items list (server-side)
function Framework.GetItemsList()
    -- Check for ox_inventory first (used by QB/QBX)
    if GetResourceState('ox_inventory') == 'started' then
        return exports.ox_inventory:Items() or {}
    end
    
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        return Framework.Object.Shared.Items or {}
    elseif Framework.Type == 'esx' then
        return Framework.Object.GetItems() or {}
    end
    return {}
end

-- Add item (server-side) - Enhanced for ox_inventory
function Framework.AddItem(src, item, count, metadata)
    count = count or 1
    
    -- Check for ox_inventory first (used by QB/QBX)
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:AddItem(src, item, count, metadata)
        return true
    end
    
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        if Player then
            Player.Functions.AddItem(item, count, false, metadata)
            return true
        end
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        if Player then
            Player.addInventoryItem(item, count)
            return true
        end
    end
    return false
end

-- Remove item (server-side) - Enhanced for ox_inventory
function Framework.RemoveItem(src, item, count)
    count = count or 1
    
    -- Check for ox_inventory first (used by QB/QBX)
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:RemoveItem(src, item, count)
        return true
    end
    
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        if Player then
            Player.Functions.RemoveItem(item, count)
            return true
        end
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        if Player then
            Player.removeInventoryItem(item, count)
            return true
        end
    end
    return false
end

-- Revive player (server-side)
function Framework.Revive(src)
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        TriggerClientEvent('hospital:client:Revive', src)
    elseif Framework.Type == 'esx' then
        TriggerClientEvent('esx_ambulancejob:revive', src)
    else
        -- Fallback to basic revive
        TriggerClientEvent('wasteland_admin:revive', src)
    end
end

-- Notify player (client-side)
function Framework.Notify(message, type, duration)
    type = type or 'info'
    duration = duration or 5000
    
    -- Try QB/QBX first
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local success = pcall(function()
            if Framework.Object and Framework.Object.Functions then
                Framework.Object.Functions.Notify(message, type, duration)
            else
                TriggerEvent('QBCore:Notify', message, type, duration)
            end
        end)
        if success then return end
    end
    
    -- Try ESX
    if Framework.Type == 'esx' then
        local success = pcall(function()
            if Framework.Object and Framework.Object.ShowNotification then
                Framework.Object.ShowNotification(message)
            else
                TriggerEvent('esx:showNotification', message)
            end
        end)
        if success then return end
    end
    
    -- Try ox_lib
    local success = pcall(function()
        exports.ox_lib:notify({ type = type, description = message, duration = duration })
    end)
    if success then return end
    
    -- Fallback: Simple chat message (always works)
    local color = {255, 255, 255}
    if type == 'error' then
        color = {255, 0, 0}
    elseif type == 'success' then
        color = {0, 255, 0}
    elseif type == 'warning' then
        color = {255, 165, 0}
    elseif type == 'info' then
        color = {100, 149, 237}
    end
    
    TriggerEvent('chat:addMessage', {
        color = color,
        multiline = false,
        args = {"[INFO]", message}
    })
end

-- ============================================
-- ANTI-FALSE POSITIVE FUNCTIONS
-- Check if player is in safe state (shouldn't be banned)
-- ============================================

-- Track players in safe mode (server-side)
local playersInSafeMode = {}

-- Check if player is fully loaded (server-side)
function Framework.IsPlayerLoaded(src)
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        return Player ~= nil
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        return Player ~= nil
    end
    return true
end

-- Check if player is in character selection (server-side)
function Framework.IsInCharacterSelection(src)
    -- Check manual safe mode first
    if playersInSafeMode[src] then
        return true
    end
    
    -- QB/QBX: Check if player has selected character
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        -- If no player object, they're in character selection
        if not Player then
            return true
        end
        -- QBX: Check if player data is loaded
        if Framework.Type == 'qbx' and Player.PlayerData then
            if not Player.PlayerData.citizenid or Player.PlayerData.citizenid == '' then
                return true
            end
        end
        return false
    end
    
    -- ESX: Check if player is loaded
    if Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        return Player == nil
    end
    
    return false
end

-- EXPORT: Enable safe mode for player (called by other scripts)
function Framework.SetPlayerSafeMode(src, enabled)
    if enabled then
        playersInSafeMode[src] = true
        print('[ANTICHEAT] Safe mode ENABLED for player ' .. src)
    else
        playersInSafeMode[src] = nil
        print('[ANTICHEAT] Safe mode DISABLED for player ' .. src)
    end
end

-- EXPORT: Check if player is in safe mode
function Framework.IsPlayerInSafeMode(src)
    return playersInSafeMode[src] == true
end

-- Clean up on disconnect
if IsDuplicityVersion() then
    AddEventHandler('playerDropped', function()
        local src = source
        playersInSafeMode[src] = nil
    end)
end

-- Check if player is in safe zone (client-side)
function Framework.IsInSafeZone()
    local ped = PlayerPedId()
    
    -- Check if in character selection screen
    if IsScreenFadedOut() then
        return true
    end
    
    -- Check if in loading screen
    if GetIsLoadingScreenActive() then
        return true
    end
    
    -- Check if player model is not loaded
    if not HasModelLoaded(GetEntityModel(ped)) then
        return true
    end
    
    -- Check if player is invisible (character selection)
    if not IsEntityVisible(ped) then
        return true
    end
    
    -- Check if player has no collision (character selection)
    if GetEntityAlpha(ped) == 0 then
        return true
    end
    
    -- Check if in cutscene
    if IsPedInAnyVehicle(ped, false) then
        local veh = GetVehiclePedIsIn(ped, false)
        if GetVehicleClass(veh) == 16 then -- Plane/Heli cutscene
            return true
        end
    end
    
    return false
end

-- Check if player should be immune to anticheat (server-side)
function Framework.IsAnticheatImmune(src)
    -- Check if player is in character selection
    if Framework.IsInCharacterSelection(src) then
        return true
    end
    
    -- Check if player just connected (grace period)
    local connectTime = GetPlayerEP(src) -- This is a placeholder, you'd track this yourself
    -- Add your own tracking here if needed
    
    return false
end

-- Get player spawn status (server-side)
function Framework.HasPlayerSpawned(src)
    if Framework.Type == 'qb' or Framework.Type == 'qbx' then
        local Player = Framework.GetPlayer(src)
        if not Player then return false end
        -- Check if player has spawned (has position data)
        return Player.PlayerData.position ~= nil
    elseif Framework.Type == 'esx' then
        local Player = Framework.GetPlayer(src)
        if not Player then return false end
        -- ESX players are spawned if they have a player object
        return true
    end
    return true
end

return Framework
