-- ============================================
-- AETHER ANTICHEAT - AUTO UPDATE SYSTEM
-- Automatically checks for updates from GitHub
-- ============================================

local GITHUB_REPO = "konpep-dev/Aether-ac-for-fivem"
local GITHUB_API = "https://api.github.com/repos/" .. GITHUB_REPO .. "/releases/latest"
local CURRENT_VERSION = "4.5.0"  -- Update this with each release
local CHECK_INTERVAL = 30 * 60 * 1000  -- Check every 30 minutes

local updateAvailable = false
local latestVersion = nil
local downloadUrl = nil

-- Function to compare versions
local function CompareVersions(current, latest)
    local function ParseVersion(version)
        local major, minor, patch = version:match("(%d+)%.(%d+)%.(%d+)")
        return {
            major = tonumber(major) or 0,
            minor = tonumber(minor) or 0,
            patch = tonumber(patch) or 0
        }
    end
    
    local curr = ParseVersion(current)
    local late = ParseVersion(latest)
    
    if late.major > curr.major then return true end
    if late.major < curr.major then return false end
    
    if late.minor > curr.minor then return true end
    if late.minor < curr.minor then return false end
    
    if late.patch > curr.patch then return true end
    
    return false
end

-- Check for updates
local function CheckForUpdates()
    print('[AUTO-UPDATE] Checking for updates...')
    print('[AUTO-UPDATE] Current version: ' .. CURRENT_VERSION)
    
    PerformHttpRequest(GITHUB_API, function(statusCode, response, headers)
        if statusCode ~= 200 then
            print('[AUTO-UPDATE] Failed to check for updates (Status: ' .. statusCode .. ')')
            return
        end
        
        local success, data = pcall(function() return json.decode(response) end)
        
        if not success or not data then
            print('[AUTO-UPDATE] Failed to parse update data')
            return
        end
        
        local version = data.tag_name or data.name
        if not version then
            print('[AUTO-UPDATE] No version found in release')
            return
        end
        
        -- Remove 'v' prefix if exists
        version = version:gsub("^v", "")
        
        latestVersion = version
        downloadUrl = data.zipball_url
        
        if CompareVersions(CURRENT_VERSION, version) then
            updateAvailable = true
            print('[AUTO-UPDATE] ========================================')
            print('[AUTO-UPDATE] 🎉 NEW UPDATE AVAILABLE!')
            print('[AUTO-UPDATE] Current: ' .. CURRENT_VERSION)
            print('[AUTO-UPDATE] Latest:  ' .. version)
            print('[AUTO-UPDATE] ========================================')
            print('[AUTO-UPDATE] Use /update command to install')
            print('[AUTO-UPDATE] Or download from: https://github.com/' .. GITHUB_REPO .. '/releases')
            
            -- Notify all online admins
            for _, playerId in ipairs(GetPlayers()) do
                local adminGroup = GetAdminGroup(tonumber(playerId))
                if adminGroup then
                    TriggerClientEvent('chat:addMessage', playerId, {
                        color = {100, 255, 100},
                        multiline = true,
                        args = {"Auto-Update", "🎉 New Aether AC update available! v" .. version .. " | Use /update to install"}
                    })
                end
            end
            
            -- Send webhook notification
            if Config and Config.Webhooks and Config.Webhooks.main then
                PerformHttpRequest(Config.Webhooks.main, function() end, 'POST', json.encode({
                    username = 'Aether Auto-Update',
                    embeds = {{
                        title = '🎉 New Update Available!',
                        description = 'A new version of Aether Anticheat is available',
                        color = 65280,
                        fields = {
                            { name = '📦 Current Version', value = CURRENT_VERSION, inline = true },
                            { name = '🆕 Latest Version', value = version, inline = true },
                            { name = '📥 Download', value = '[GitHub Releases](https://github.com/' .. GITHUB_REPO .. '/releases)', inline = false },
                        },
                        footer = { text = 'Use /update command to auto-install' }
                    }}
                }), { ['Content-Type'] = 'application/json' })
            end
        else
            print('[AUTO-UPDATE] ✅ You are running the latest version (' .. CURRENT_VERSION .. ')')
        end
    end, 'GET', '', {
        ['User-Agent'] = 'Aether-Anticheat-Updater'
    })
end

-- Start auto-check on resource start
CreateThread(function()
    Wait(10000)  -- Wait 10 seconds after server start
    CheckForUpdates()
    
    -- Check periodically
    while true do
        Wait(CHECK_INTERVAL)
        CheckForUpdates()
    end
end)

-- Manual update check command
RegisterCommand('checkupdate', function(source, args, rawCommand)
    if source ~= 0 then
        local adminGroup = GetAdminGroup(source)
        if not adminGroup then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"Auto-Update", "No permission!"}
            })
            return
        end
    end
    
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 200, 255},
            args = {"Auto-Update", "Checking for updates..."}
        })
    end
    
    CheckForUpdates()
    
    Wait(2000)
    
    if source ~= 0 then
        if updateAvailable then
            TriggerClientEvent('chat:addMessage', source, {
                color = {100, 255, 100},
                args = {"Auto-Update", "🎉 Update available! v" .. latestVersion .. " | Use /update to install"}
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {100, 255, 100},
                args = {"Auto-Update", "✅ You are running the latest version"}
            })
        end
    end
end, false)

-- Update installation command
RegisterCommand('update', function(source, args, rawCommand)
    if source ~= 0 then
        local adminGroup = GetAdminGroup(source)
        if not adminGroup or adminGroup ~= 'superadmin' then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                args = {"Auto-Update", "Only superadmins can install updates!"}
            })
            return
        end
    end
    
    if not updateAvailable then
        if source ~= 0 then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 200, 0},
                args = {"Auto-Update", "No updates available. Use /checkupdate first"}
            })
        else
            print('[AUTO-UPDATE] No updates available')
        end
        return
    end
    
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 200, 255},
            args = {"Auto-Update", "⚠️ IMPORTANT: This will restart the resource!"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 200, 255},
            args = {"Auto-Update", "📋 Steps to update:"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 200, 255},
            args = {"Auto-Update", "1. Your config.lua will be backed up to config.lua.bk"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 200, 255},
            args = {"Auto-Update", "2. Download latest from: https://github.com/" .. GITHUB_REPO .. "/releases"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 200, 255},
            args = {"Auto-Update", "3. Extract and replace files (keep config.lua.bk)"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 200, 255},
            args = {"Auto-Update", "4. Restore your settings from config.lua.bk"}
        })
        TriggerClientEvent('chat:addMessage', source, {
            color = {100, 200, 255},
            args = {"Auto-Update", "5. Restart the resource"}
        })
    else
        print('[AUTO-UPDATE] ========================================')
        print('[AUTO-UPDATE] UPDATE INSTRUCTIONS')
        print('[AUTO-UPDATE] ========================================')
        print('[AUTO-UPDATE] 1. Backup config.lua → config.lua.bk')
        print('[AUTO-UPDATE] 2. Download: https://github.com/' .. GITHUB_REPO .. '/releases')
        print('[AUTO-UPDATE] 3. Extract and replace files')
        print('[AUTO-UPDATE] 4. Restore settings from config.lua.bk')
        print('[AUTO-UPDATE] 5. Restart resource')
        print('[AUTO-UPDATE] ========================================')
    end
end, false)

-- Export functions
exports('GetCurrentVersion', function()
    return CURRENT_VERSION
end)

exports('IsUpdateAvailable', function()
    return updateAvailable
end)

exports('GetLatestVersion', function()
    return latestVersion
end)

print('[AUTO-UPDATE] System initialized')
print('[AUTO-UPDATE] Current version: ' .. CURRENT_VERSION)
print('[AUTO-UPDATE] Checking for updates every ' .. (CHECK_INTERVAL / 60000) .. ' minutes')
