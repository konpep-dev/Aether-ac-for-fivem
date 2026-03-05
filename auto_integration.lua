-- ============================================
-- AUTO INTEGRATION SYSTEM
-- Automatically adds Safe Mode to common scripts
-- ============================================

local integratedScripts = {}

-- Configuration for auto-integration
local autoIntegrationConfig = {
    -- Multicharacter scripts
    ['qb-multicharacter'] = {
        { event = 'qb-multicharacter:server:loadUserData', safeMode = true, duration = 5000 },
        { event = 'qb-multicharacter:server:createCharacter', safeMode = true, duration = 5000 },
        { event = 'qb-multicharacter:server:selectCharacter', safeMode = true, duration = 5000 }
    },
    ['qbx_core'] = {  -- QBX has multicharacter built-in
        { event = 'qbx_core:server:loadUserData', safeMode = true, duration = 5000 },
        { event = 'qbx_core:server:createCharacter', safeMode = true, duration = 5000 },
        { event = 'qbx_core:server:selectCharacter', safeMode = true, duration = 5000 },
        { event = 'qbx_core:server:onPlayerLoaded', safeMode = true, duration = 5000 }
    },
    ['esx_multicharacter'] = {
        { event = 'esx_multicharacter:CharacterChosen', safeMode = true, duration = 5000 }
    },
    
    -- Spawn scripts
    ['qb-spawn'] = {
        { event = 'qb-spawn:server:spawnPlayer', safeMode = true, duration = 3000 }
    },
    ['qbx_spawn'] = {
        { event = 'qbx_spawn:server:spawnPlayer', safeMode = true, duration = 3000 }
    },
    
    -- Ambulance scripts
    ['qb-ambulancejob'] = {
        { event = 'qb-ambulancejob:server:RespawnAtHospital', safeMode = true, duration = 3000 }
    },
    ['esx_ambulancejob'] = {
        { event = 'esx_ambulancejob:revive', safeMode = true, duration = 3000 }
    }
}

-- Resources to ignore (don't check for anticheat)
local whitelistedResources = {
    'qbx_core',      -- QBX core has built-in character selection
    'qb-core',       -- QB core
    'es_extended',   -- ESX
    'ox_lib',        -- OX Library
    'oxmysql',       -- Database
    'screenshot-basic' -- Screenshot tool
}

-- Hook into events
local function HookEvent(eventName, config)
    AddEventHandler(eventName, function()
        local src = source
        
        if config.safeMode then
            exports['aether-anticheat']:SetPlayerSafeMode(src, true)
            print('[AUTO-INTEGRATION] 🛡️ Safe mode enabled: ' .. GetPlayerName(src) .. ' (' .. eventName .. ')')
            
            if config.duration > 0 then
                SetTimeout(config.duration, function()
                    exports['aether-anticheat']:SetPlayerSafeMode(src, false)
                    print('[AUTO-INTEGRATION] ✅ Safe mode disabled: ' .. GetPlayerName(src) .. ' (' .. eventName .. ')')
                end)
            end
        end
    end)
end

-- Integrate a resource
local function IntegrateResource(resourceName)
    local config = autoIntegrationConfig[resourceName]
    if not config then return false end
    
    local resourceState = GetResourceState(resourceName)
    if resourceState ~= 'started' and resourceState ~= 'starting' then
        return false
    end
    
    print('[AUTO-INTEGRATION] 🔧 Integrating: ' .. resourceName)
    
    for _, eventConfig in ipairs(config) do
        HookEvent(eventConfig.event, eventConfig)
    end
    
    integratedScripts[resourceName] = true
    return true
end

-- Initialize
CreateThread(function()
    Wait(10000) -- Wait for resources to start
    
    print('========================================')
    print('  🔌 AUTO-INTEGRATION SYSTEM')
    print('========================================')
    print('')
    
    -- List all running resources
    print('[AUTO-INTEGRATION] 📋 Scanning for compatible scripts...')
    print('')
    
    local integratedCount = 0
    
    for resourceName, _ in pairs(autoIntegrationConfig) do
        local state = GetResourceState(resourceName)
        print('[AUTO-INTEGRATION] ' .. resourceName .. ' - State: ' .. state)
        
        if IntegrateResource(resourceName) then
            integratedCount = integratedCount + 1
        end
    end
    
    print('')
    if integratedCount > 0 then
        print('[AUTO-INTEGRATION] ✅ Integrated ' .. integratedCount .. ' scripts')
        print('[AUTO-INTEGRATION] 📋 Safe Mode will activate automatically')
    else
        print('[AUTO-INTEGRATION] ℹ️ No compatible scripts found')
        print('[AUTO-INTEGRATION] 💡 Add manual integration with:')
        print('[AUTO-INTEGRATION]    exports["aether-anticheat"]:SetPlayerSafeMode(source, true)')
        print('[AUTO-INTEGRATION] 📖 See INTEGRATION.md for examples')
    end
    print('========================================')
end)

-- Export to add custom integration
function AddAutoIntegration(resourceName, eventName, duration)
    if not autoIntegrationConfig[resourceName] then
        autoIntegrationConfig[resourceName] = {}
    end
    
    table.insert(autoIntegrationConfig[resourceName], {
        event = eventName,
        safeMode = true,
        duration = duration or 3000
    })
    
    HookEvent(eventName, { safeMode = true, duration = duration or 3000 })
    print('[AUTO-INTEGRATION] ➕ Added custom integration: ' .. eventName)
end
