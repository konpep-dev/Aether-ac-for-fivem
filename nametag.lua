-- ============================================
-- CUSTOM DEVELOPER NAMETAG (Client)
-- ============================================
local devPlayers = {} -- Store server IDs of dev players: devPlayers[serverId] = "konpep"

-- Request dev players list from server on load
CreateThread(function()
    Wait(5000)
    TriggerServerEvent('wasteland_admin:requestDevPlayers')
end)

-- Receive the full list of dev players
RegisterNetEvent('wasteland_admin:syncDevPlayers', function(players)
    devPlayers = players or {}
    for id, name in pairs(devPlayers) do
        print('[NameTag] Synced dev player: ' .. name .. ' (ID: ' .. id .. ')')
    end
end)

-- When a new dev player is added
RegisterNetEvent('wasteland_admin:addDevPlayer', function(serverId, playerName)
    devPlayers[serverId] = playerName
    print('[NameTag] Dev player added: ' .. playerName .. ' (ID: ' .. serverId .. ')')
end)

-- When a dev player leaves
RegisterNetEvent('wasteland_admin:removeDevPlayer', function(serverId)
    if devPlayers[serverId] then
        print('[NameTag] Dev player removed: ' .. devPlayers[serverId])
        devPlayers[serverId] = nil
    end
end)

-- Draw nametags for ALL dev players
CreateThread(function()
    while true do
        Wait(0)
        
        local hasDevPlayers = false
        
        for _, player in ipairs(GetActivePlayers()) do
            local serverId = GetPlayerServerId(player)
            local devName = devPlayers[serverId]
            
            if devName then
                hasDevPlayers = true
                local targetPed = GetPlayerPed(player)
                
                if DoesEntityExist(targetPed) and not IsEntityDead(targetPed) then
                    -- Get head position
                    local headPos = GetPedBoneCoords(targetPed, 31086, 0.0, 0.0, 0.0)
                    headPos = vector3(headPos.x, headPos.y, headPos.z + 0.5)
                    
                    -- Check if on screen
                    local onScreen, screenX, screenY = World3dToScreen2d(headPos.x, headPos.y, headPos.z)
                    
                    if onScreen then
                        -- Check distance for scaling
                        local myPed = PlayerPedId()
                        local myCoords = GetEntityCoords(myPed)
                        local distance = #(myCoords - headPos)
                        
                        if distance < 50.0 then
                            local scale = math.max(0.2, 0.4 * (1 - distance / 50))
                            
                            -- Draw "Development" tag (top) - Gold
                            SetTextScale(0.0, scale * 0.8)
                            SetTextFont(4)
                            SetTextColour(255, 215, 0, 255)
                            SetTextOutline()
                            SetTextCentre(true)
                            SetTextEntry('STRING')
                            AddTextComponentString('Development')
                            DrawText(screenX, screenY - 0.018)
                            
                            -- Draw player name (below) - White
                            SetTextScale(0.0, scale)
                            SetTextFont(4)
                            SetTextColour(255, 255, 255, 255)
                            SetTextOutline()
                            SetTextCentre(true)
                            SetTextEntry('STRING')
                            AddTextComponentString(devName)
                            DrawText(screenX, screenY)
                        end
                    end
                end
            end
        end
        
        -- Slow down if no dev players nearby
        if not hasDevPlayers then
            Wait(1000)
        end
    end
end)
